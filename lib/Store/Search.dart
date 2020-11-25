import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Widgets/customAppBar.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> doclist;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              bottom: PreferredSize(
                child: searchWidget(),
                preferredSize: Size(56.0, 56.0),
              ),
              floating: true,
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
                    textStyle:
                        TextStyle(color: Colors.white, letterSpacing: .5),
                  )),
              centerTitle: true,
              actions: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_basket,
                          color: Colors.yellowAccent,
                        ),
                        onPressed: () {
                          Route route =
                              MaterialPageRoute(builder: (c) => CartPage());
                          Navigator.push(context, route);
                        },
                      ),
                    ),
                    Positioned(
                      child: Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Colors.yellow,
                          ),
                          Positioned(
                            top: 3.0,
                            left: 6.0,
                            bottom: 4.0,
                            child: Consumer<CartItemCounter>(
                              builder: (context, counter, _) {
                                return Text(
                                  (TeleMed.sharedPreferences
                                              .getStringList(
                                                  TeleMed.userCartList)
                                              .length -
                                          1)
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<QuerySnapshot>(
                    future: doclist,
                    builder: (context, snap) {
                      return snap.hasData
                          ? ListView.builder(
                              itemCount: snap.data.documents.length,
                              itemBuilder: (context, index) {
                                ItemModel model = ItemModel.fromJson(
                                    snap.data.documents[index].data);
                                return sourceInfo(model, context);
                              },
                            )
                          : Container(
                              child: Text("Nothing found"),
                            );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      decoration: new BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.blue],
          begin: Alignment.topLeft,
          end:
              Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp, // repeats the gradient over the canvas
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 20.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.purpleAccent,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: TextField(
                  onChanged: (value) {
                    startSearching(value);
                  },
                  decoration: InputDecoration.collapsed(
                      hintText: "Search Location Here"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    doclist = Firestore.instance
        .collection("items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .getDocuments();
  }
}
