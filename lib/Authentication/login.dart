import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Admin/adminauthenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
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
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 30),
            child: Container(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.asset("images/logo.jpg")),
              height: 140.0,
              width: 140.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Login To Your Account",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SizedBox(
              width: 200.0,
              height: 45.0,
              child: RaisedButton(
                color: Colors.purpleAccent,
                onPressed: () {
                  _emailTextEditingController.text.isNotEmpty &&
                          _passwordTextEditingController.text.isNotEmpty
                      ? loginUser()
                      : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: "Please write email and password",
                            );
                          });
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
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
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating please wait ",
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
            email: _emailTextEditingController.text.trim(),
            password: _passwordTextEditingController.text.trim())
        .then((authUser) {
      firebaseUser = authUser.user;
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
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("users")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await TeleMed.sharedPreferences
          .setString(TeleMed.userUID, dataSnapshot.data[TeleMed.userUID]);

      await TeleMed.sharedPreferences
          .setString(TeleMed.userEmail, dataSnapshot.data[TeleMed.userEmail]);
      await TeleMed.sharedPreferences
          .setString(TeleMed.name, dataSnapshot.data[TeleMed.name]);
      await TeleMed.sharedPreferences.setString(
          TeleMed.userAvatarUrl, dataSnapshot.data[TeleMed.userAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data[TeleMed.userCartList].cast<String>();
      await TeleMed.sharedPreferences
          .setStringList(TeleMed.userCartList, cartList);
//      List<String> gdeedList =
//          dataSnapshot.data[TeleMed.userGoodDeeds].cast<String>();
//      await TeleMed.sharedPreferences
//          .setStringList(TeleMed.userGoodDeeds, gdeedList);
    });
  }
}
