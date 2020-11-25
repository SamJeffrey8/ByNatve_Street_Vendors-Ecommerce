import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String adminImgUrl = "";
  File _adminImageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _adminImageFile == null ? null : FileImage(_adminImageFile),
                child: _adminImageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Pharmacy Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.security,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cpasswordTextEditingController,
                    data: Icons.security,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadAndSave();
              },
              color: Colors.purpleAccent,
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.5,
              color: Colors.purple,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _adminImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSave() async {
    if (_adminImageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please select image",
            );
          });
    } else {
      _passwordTextEditingController.text ==
              _cpasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cpasswordTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : diplayDialogue("Please Fill The Complete Form")
          : diplayDialogue("Passwords do Not Match ");
    }
  }

  diplayDialogue(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Registering Please Wait",
          );
        });
    String adminImageFileName = DateTime.now().millisecond.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(adminImageFileName);
    StorageUploadTask storageUploadTask =
        storageReference.putFile(_adminImageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((aurlimg) {
      adminImgUrl = aurlimg;

      _registerAdmin();
    });
  }

  FirebaseAuth _adminauth = FirebaseAuth.instance;
  void _registerAdmin() async {
    FirebaseUser firebaseAdmin;
    await _adminauth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text,
            password: _passwordTextEditingController.text)
        .then(
      (adminauth) {
        firebaseAdmin = adminauth.user;
      },
    ).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: error.message.toString(),
              );
            });
      },
    );
    if (firebaseAdmin != null) {
      saveAdminInfoToFIreStore(firebaseAdmin).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => UploadPage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveAdminInfoToFIreStore(FirebaseUser fAdmin) async {
    Firestore.instance.collection("admin").document(fAdmin.uid).setData(
      {
        "uid": fAdmin.uid,
        "email": fAdmin.email,
        "name": _nameTextEditingController.text,
        "url": adminImgUrl,
        TeleMed.userCartList: ["garbageValue"]
      },
    );
    await TeleMed.sharedPreferences.setString(TeleMed.adminUID, fAdmin.uid);
    await TeleMed.sharedPreferences.setString(TeleMed.adminEmail, fAdmin.email);
    await TeleMed.sharedPreferences
        .setString(TeleMed.adminName, _nameTextEditingController.text);
    await TeleMed.sharedPreferences
        .setString(TeleMed.adminAvatarUrl, fAdmin.uid);
    await TeleMed.sharedPreferences
        .setStringList(TeleMed.userCartList, ["garbageValue"]);
  }
}
