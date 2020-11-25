import 'package:flutter/material.dart';
import '../Admin/adminLogin.dart';
import '../Authentication/register.dart';
import 'package:e_shop/Config/config.dart';
import '../Admin/adminRegister.dart';

class AdminAuthenticScreen extends StatefulWidget {
  @override
  _AdminAuthenticScreenState createState() => _AdminAuthenticScreenState();
}

class _AdminAuthenticScreenState extends State<AdminAuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment(
                    0.8, 0.0), // 10% of the width, so there are ten blinds.
                stops: [0.0, 1.0],
                tileMode:
                    TileMode.clamp, // repeats the gradient over the canvas
              ),
            ),
          ),
          title: Text(
            "TeleMed",
            style: TextStyle(
              fontSize: 55.0,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: "Pharmacy Login"),
              Tab(
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  text: "Pharmacy Sign up")
            ],
            indicatorColor: Colors.white24,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.blue],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
          ),
          child: TabBarView(
            children: [
              AdminLogin(),
              AdminRegister(),
            ],
          ),
        ),
      ),
    );
  }
}
