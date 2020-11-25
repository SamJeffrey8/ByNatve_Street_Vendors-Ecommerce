import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Admin/adminauthenication.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _aemailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset("images/admin.png"),
            height: 240.0,
            width: 240.0,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Login To Your Account",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _aemailTextEditingController,
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
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              _aemailTextEditingController.text.isNotEmpty &&
                      _passwordTextEditingController.text.isNotEmpty
                  ? loginAdmin()
                  : showDialog(
                      context: context,
                      builder: (c) {
                        return ErrorAlertDialog(
                          message: "Please write email and password",
                        );
                      });
            },
            child: Text("Login"),
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
          FlatButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthenticScreen()),
            ),
            icon: Icon(
              Icons.nature_people,
              color: Colors.purple,
            ),
            label: Text(
              "I`m not Admin",
              style:
                  TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  FirebaseAuth _adminauth = FirebaseAuth.instance;

  void loginAdmin() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating please wait ",
          );
        });
    FirebaseUser firebaseAdmin;
    await _adminauth
        .signInWithEmailAndPassword(
            email: _aemailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseAdmin = authUser.user;
    }).catchError(
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
      readData(firebaseAdmin).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => UploadPage());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fAdmin) async {
    Firestore.instance
        .collection("admin")
        .document(fAdmin.uid)
        .get()
        .then((dataSnapshot) async {
      await TeleMed.sharedPreferences
          .setString(TeleMed.adminUID, dataSnapshot.data[TeleMed.adminUID]);

      await TeleMed.sharedPreferences
          .setString(TeleMed.adminEmail, dataSnapshot.data[TeleMed.adminEmail]);
      await TeleMed.sharedPreferences
          .setString(TeleMed.adminName, dataSnapshot.data[TeleMed.adminName]);
      await TeleMed.sharedPreferences.setString(
          TeleMed.adminAvatarUrl, dataSnapshot.data[TeleMed.adminAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data[TeleMed.userCartList].cast<String>();
      await TeleMed.sharedPreferences
          .setStringList(TeleMed.userCartList, cartList);
      List<String> gdeedList =
          dataSnapshot.data[TeleMed.userGoodDeeds].cast<String>();
      await TeleMed.sharedPreferences
          .setStringList(TeleMed.userGoodDeeds, gdeedList);
    });
  }
}
