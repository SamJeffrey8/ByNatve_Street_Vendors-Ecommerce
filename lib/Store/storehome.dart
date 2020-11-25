import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  //pushnoti
  final _firebaseMessaging = FirebaseMessaging();
  String _message = 'Generating Message...';
  String _token = 'Generating Token...';

  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _message = '$message';
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _message = '$message';
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _message = '$message';
        });
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = '$token';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.purple,
              brightness: Brightness.light,
              expandedHeight: 40.0,
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
            SliverPersistentHeader(
                pinned: false, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("items")
                  .orderBy(
                    "publishedDate",
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data.documents[index].data);
                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data.documents.length,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return Padding(
      padding: EdgeInsets.only(bottom: 8.0, left: 5.0, right: 5.0),
      child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          child: InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (c) => ProductPage(itemModel: model),
              );
              Navigator.push(context, route);
            },
            borderRadius: BorderRadius.circular(25.0),
            splashColor: Colors.purple[10],
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                height: 185.0,
                width: width,
                child: Row(
                  children: [
                    Column(children: [
                      Container(
                        height: 140,
                        width: 140,
                        child: GridTile(
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Image(
                                  image: new NetworkImage(model.thumbnailUrl),
                                ),
                              ]),
                          footer: ListTile(
                            trailing: IconButton(
                              splashRadius: 5,
                              splashColor: Colors.purpleAccent,
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.share),
                              ),
                              color: Colors.purple,
                              iconSize: 25,
                              onPressed: () {
//                                  share(model.title,
//                                      model.thumbnailUrl);
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Category: " + model.categ,
                          style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "By, " + model.sellerName,
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ]),
                    SizedBox(
                      width: 4.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    model.title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    model.shortInfo,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.purple,
                                ),
                                alignment: Alignment.topLeft,
                                width: 30.0,
                                height: 30.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "50",
                                        style: TextStyle(
                                            fontSize: 8.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "off",
                                        style: TextStyle(
                                            fontSize: 8.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 7.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 0.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "₹" +
                                              (model.price + model.price)
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.red,
                                              fontWeight: FontWeight.normal,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 2.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "₹" + (model.price).toString(),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: removeCartFunction == null
                                ? IconButton(
                                    icon: Icon(Icons.shopping_basket_rounded),
                                    color: Colors.purple,
                                    onPressed: () {
                                      checkItemInCart(model.shortInfo, context);
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.delete_rounded),
                                    color: Colors.purple,
                                    onPressed: () {
                                      removeCartFunction();
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )));
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200])
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}

void checkItemInCart(String shortInfoAsID, BuildContext context) {
  TeleMed.sharedPreferences
          .getStringList(TeleMed.userCartList)
          .contains(shortInfoAsID)
      ? Fluttertoast.showToast(msg: "Item Is Already In Cart")
      : addItemToCart(shortInfoAsID, context);
}

addItemToCart(String shortInfoAsID, BuildContext context) {
  List tempCartList =
      TeleMed.sharedPreferences.getStringList(TeleMed.userCartList);
  tempCartList.add(shortInfoAsID);

  TeleMed.firestore
      .collection(TeleMed.collectionUser)
      .document(TeleMed.sharedPreferences.getString(TeleMed.userUID))
      .updateData({TeleMed.userCartList: tempCartList}).then((v) {
    Fluttertoast.showToast(msg: "Item Added TO Shopping List Successfully!");
    TeleMed.sharedPreferences.setStringList(TeleMed.userCartList, tempCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}
