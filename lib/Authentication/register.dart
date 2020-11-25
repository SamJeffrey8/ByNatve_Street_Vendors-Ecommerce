import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImgUrl = "";
  File _imageFile;

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
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: _screenWidth * 0.09,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Text(
                                "Profile Picture",
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: Text(
                                "(Optional)",
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Register For Free!",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200.0,
                height: 45.0,
                child: RaisedButton(
                  onPressed: () {
                    uploadAndSave();
                  },
                  color: Colors.purpleAccent,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSave() async {
    if (_imageFile == null) {
      _passwordTextEditingController.text ==
              _cpasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty &&
                  _cpasswordTextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : diplayDialogue("Please Fill The Complete Form")
          : diplayDialogue("Passwords do Not Match ");
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

    _registerUser();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailTextEditingController.text,
            password: _passwordTextEditingController.text)
        .then(
      (auth) {
        firebaseUser = auth.user;
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
    if (firebaseUser != null) {
      saveUserInfiTOFIreStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfiTOFIreStore(FirebaseUser fUser) async {
    Firestore.instance.collection("users").document(fUser.uid).setData(
      {
        "uid": fUser.uid,
        "email": fUser.email,
        "name": _nameTextEditingController.text,
        "url": userImgUrl,
        TeleMed.userCartList: ["garbageValue"],
      },
    );
    await TeleMed.sharedPreferences.setString(TeleMed.userUID, fUser.uid);
    await TeleMed.sharedPreferences.setString(TeleMed.userEmail, fUser.email);
    await TeleMed.sharedPreferences
        .setString(TeleMed.name, _nameTextEditingController.text);
    await TeleMed.sharedPreferences.setString(TeleMed.userAvatarUrl, fUser.uid);
    await TeleMed.sharedPreferences
        .setStringList(TeleMed.userCartList, ["garbageValue"]);
  }
}
