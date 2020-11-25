import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;

  @override
  void initstate() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayResult(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                  textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
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
                                            .getStringList(TeleMed.userCartList)
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
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "Total Price: ${amountProvider.totalAmount.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: TeleMed.firestore
                .collection("items")
                .where("shortInfo",
                    whereIn: TeleMed.sharedPreferences
                        .getStringList(TeleMed.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginbuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.documents[index].data);
                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = model.price + totalAmount;
                              } else {
                                totalAmount = model.price + totalAmount;
                              }
                              if (snapshot.data.documents.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((c) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayResult(totalAmount);
                                });
                              }
                              return sourceInfo(model, context,
                                  removeCartFunction: () =>
                                      removeItemFromUserCart(model.shortInfo));
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.documents.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }

  beginbuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 200.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text("Shopping List Is Empty"),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                    "Start Adding Items here, so you don`t forget what you wanna buy!"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromUserCart(
    String shortInfoAsID,
  ) {
    List tempCartList =
        TeleMed.sharedPreferences.getStringList(TeleMed.userCartList);
    tempCartList.remove(shortInfoAsID);

    TeleMed.firestore
        .collection(TeleMed.collectionUser)
        .document(TeleMed.sharedPreferences.getString(TeleMed.userUID))
        .updateData({TeleMed.userCartList: tempCartList}).then((v) {
      Fluttertoast.showToast(msg: "Item Removed Successfully!");
      TeleMed.sharedPreferences
          .setStringList(TeleMed.userCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }
}
