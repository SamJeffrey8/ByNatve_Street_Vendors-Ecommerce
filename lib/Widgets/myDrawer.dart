import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/AR.dart';
import 'package:e_shop/Store/Community.dart';
import 'package:e_shop/Store/Donate.dart';
import 'package:e_shop/Store/Explore.dart';
import 'package:e_shop/Store/Map_page.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .799,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment(
                      0.8, 0.0), // 10% of the width, so there are ten blinds.
                  stops: [0.0, 1.0],
                  tileMode:
                      TileMode.clamp, // repeats the gradient over the canvas
                ),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: Image.asset("images/logo.jpg")),
                    height: 90.0,
                    width: 90.0,
                  ),
                  SizedBox(
                    height: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text(
                        "Kind Hearted " +
                            TeleMed.sharedPreferences.getString(TeleMed.name),
                        style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: Colors.white, letterSpacing: .5),
                        )),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.purple,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.explore,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    "Explore",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => Explore());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_basket,
                    color: Colors.brown,
                  ),
                  title: Text(
                    "My Sopping List",
                    style: TextStyle(color: Colors.brown),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Colors.yellow,
                  ),
                  title: Text(
                    "Adventure Map",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => MapPage());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.indigo,
                  ),
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.indigo),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_road,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Add a Vendor",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => UploadPage());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Augmented Reality",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => AR());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                    color: Colors.green,
                  ),
                  title: Text(
                    "Donate",
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(builder: (c) => Donate());
                    Navigator.push(context, route);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.people,
                    color: Colors.pinkAccent,
                  ),
                  title: Text(
                    "Community",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                  onTap: () {
                    TeleMed.auth.signOut().then((c) {
                      Route route =
                          MaterialPageRoute(builder: (c) => Community());
                      Navigator.push(context, route);
                    });
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  onTap: () {
                    TeleMed.auth.signOut().then((c) {
                      Route route =
                          MaterialPageRoute(builder: (c) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
