import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
          title: Text("ByNative",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold),
              )),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: "Login"),
              Tab(
                  icon: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  text: "Sign up")
            ],
            indicatorColor: Colors.white24,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.purple],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft),
          ),
          child: TabBarView(
            children: [
              Login(),
              Register(),
            ],
          ),
        ),
      ),
    );
  }
}
