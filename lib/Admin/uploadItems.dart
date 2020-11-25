import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/gdeedcounter.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  var selectedProdCateg;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  TextEditingController _sellerNameTextEditingController =
      TextEditingController();
  String productID = DateTime.now().toString();
  bool uploading = false;
  bool get wantKeepAlive => true;
  File file;
  List<String> _prodcateg = <String>[
    'Chats',
    'Meals',
    'Fruits',
    'Vegetables',
    'Flowers',
    'Groceries',
    'Outfit',
    'Other'
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return file == null
        ? Scaffold(
            appBar: AppBar(
              elevation: 0.1,
              flexibleSpace: Container(
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.topLeft,
                    end: Alignment(
                        0.8, 0.0), // 10% of the width, so there are ten blinds.
                    stops: [0.0, 1.0],
                    tileMode:
                        TileMode.clamp, // repeats the gradient over the canvas
                  ),
                ),
              ),
              title: Text("Add a Street Vendor`s Product"),
            ),
            body: getAdminHomeScreen(),
          )
        : displayAdminUploadFormScreen();
  }

  getAdminHomeScreen() {
    return Container(
      decoration: new BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end:
              Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp, // repeats the gradient over the canvas
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset("images/logo.jpg")),
              height: 240.0,
              width: 240.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child: Text(
                  "Add New Products",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Please Provide Product Image",
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture With Camera",
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Pick From Gallery",
                  style: TextStyle(
                    color: Colors.purple,
                  ),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File ImageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );
    setState(() {
      file = ImageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File ImageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = ImageFile;
    });
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment(
                  0.8, 0.0), // 10% of the width, so there are ten blinds.
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp, // repeats the gradient over the canvas
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearFormInfo();
          },
        ),
        centerTitle: true,
        title: Text(
          "New Product",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            uploading ? circularProgress() : Text(""),
            Container(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(file), fit: BoxFit.contain)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0),
            ),
            Divider(
              color: Colors.purpleAccent,
            ),
            ListTile(
              leading: Icon(
                Icons.food_bank,
                color: Colors.pink,
              ),
              title: Container(
                width: 50.0,
                child: TextFormField(
                  maxLengthEnforced: true,
                  maxLength: 18,
                  showCursor: true,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(18),
                  ],
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: Colors.deepPurple),
                  controller: _titleTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Product Name",
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Product Name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.purpleAccent,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Container(
                width: 50.0,
                child: TextFormField(
                  maxLengthEnforced: true,
                  maxLength: 10,
                  showCursor: true,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(10),
                  ],
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: Colors.deepPurple),
                  controller: _sellerNameTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Seller Name",
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Seller Name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.purpleAccent,
            ),
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Colors.green,
              ),
              title: Container(
                width: 50.0,
                child: TextFormField(
                  maxLengthEnforced: true,
                  maxLength: 69,
                  showCursor: true,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(69),
                  ],
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: Colors.deepPurple),
                  controller: _shortInfoTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Location",
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Seller Name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.purpleAccent,
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.brown,
              ),
              title: Container(
                width: 50.0,
                child: TextFormField(
                  maxLengthEnforced: true,
                  maxLength: 100,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(100),
                  ],
                  showCursor: true,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: Colors.deepPurple),
                  controller: _descriptionTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Give Product Description';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.purpleAccent,
            ),
            ListTile(
              leading: Icon(
                Icons.monetization_on,
                color: Colors.green,
              ),
              title: Container(
                width: 50.0,
                child: TextFormField(
                  maxLengthEnforced: true,
                  maxLength: 5,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(5),
                  ],
                  showCursor: true,
                  style: TextStyle(color: Colors.deepPurple),
                  controller: _priceTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Price",
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Price';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.purpleAccent,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: DropdownButtonFormField(
                  items: _prodcateg
                      .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                            ),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (selectedCateg) {
                    setState(() {
                      selectedProdCateg = selectedCateg;
                    });
                  },
                  value: selectedProdCateg,
                  validator: (value) =>
                      value == null ? 'Please fill shop category' : null,
                  isExpanded: false,
                  icon: Icon(Icons.category),
                  hint: Text("Category"),
                ),
              ),
            ),
            SizedBox(
              height: 45,
              width: width * .8,
              child: RaisedButton(
                color: Colors.purpleAccent,
                onPressed: () {
                  if (_formKey.currentState.validate() && uploading != true) {
                    UploadImageAndSaveItemInfo();
                  }
                },
                elevation: 5.0,
                splashColor: Colors.purple[100],
                child: Text(
                  'Do Good',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      selectedProdCateg = null;
    });
  }

  UploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadURL = await uploadItemImage(file);

    saveItemInfo(imageDownloadURL);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productID.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadurl = await taskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  saveItemInfo(String downloadURL) {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productID).setData({
      'shortInfo': _shortInfoTextEditingController.text.trim(),
      'publishedDate': DateTime.now(),
      'stu': "available",
      'price': int.parse(
        _priceTextEditingController.text.trim(),
      ),
      'categ': selectedProdCateg,
      'sellerName': _sellerNameTextEditingController.text.trim(),
      'title': _titleTextEditingController.text.trim(),
      'thumbnailUrl': downloadURL,
      'longDescription': _descriptionTextEditingController.text.trim(),
    });
    setState(() {
      file = null;
      uploading = false;
      productID = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _titleTextEditingController.clear();
      _titleTextEditingController.clear();
      selectedProdCateg = null;
    });
  }
}
