import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purpleAccent[100],
        appBar: AppBar(
          centerTitle: true,
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
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => StoreHome()))
            },
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 1.0, 0.0),
              child: Text(
                widget.itemModel.title,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[600]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15.0, 3.0, 1.0, 0.0),
              child: Text(
                "By, " + widget.itemModel.sellerName,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
            ),
            Container(
              height: 300,
              child: GridTile(
                child:
                    Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                  Image(
                    image: new NetworkImage(widget.itemModel.thumbnailUrl),
                  ),
                ]),
                footer: Container(
                  color: Colors.transparent,
                  child: ListTile(
                    trailing: IconButton(
                      splashRadius: 35,
                      splashColor: Colors.purpleAccent,
                      icon: Icon(Icons.share),
                      color: Colors.purple,
                      iconSize: 45,
                      onPressed: () {
                        share(widget.itemModel.title,
                            widget.itemModel.thumbnailUrl);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15),
              child: Text("₹" + widget.itemModel.price.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.greenAccent)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 15),
              child: Text(
                "Old Price: ₹" +
                    (widget.itemModel.price + widget.itemModel.price)
                        .toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15, bottom: 8.0),
              child: Text("Category: " + widget.itemModel.categ,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.deepPurple)),
            ),
            ListTile(
              title: Text(
                "Product Details: ",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              subtitle: Text(
                widget.itemModel.longDescription,
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            ),
            ListTile(
              title: Text(
                "Location: ",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              subtitle: Text(
                widget.itemModel.shortInfo,
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                15.0,
                15.0,
                15.0,
                3.0,
              ),
              child: Container(
                width: width,
                height: 50.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.deepPurple],
                      begin: Alignment.topLeft,
                      end: Alignment(0.8,
                          0.0), // 10% of the width, so there are ten blinds.
                      stops: [0.0, 1.0],
                      tileMode: TileMode
                          .clamp, // repeats the gradient over the canvas
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(0.0, 1.5),
                        blurRadius: 1.5,
                      ),
                    ]),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      splashColor: Colors.purpleAccent,
                      onTap: () =>
                          checkItemInCart(widget.itemModel.shortInfo, context),
                      child: Center(
                        child: Text(
                          "Add To Basket",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> share(dynamic link, String title) async {
    await FlutterShare.share(
        title: "Share" + widget.itemModel.title,
        text: '''Product Name: ${widget.itemModel.title}
Sold By, ${widget.itemModel.sellerName}
Location: ${widget.itemModel.shortInfo}
Description: ${widget.itemModel.longDescription}
Category: ${widget.itemModel.categ}
Discounted Price: ${widget.itemModel.price}
Old Price: ${widget.itemModel.price + widget.itemModel.price * 0.3}
Product Image:${widget.itemModel.thumbnailUrl}''',
        chooserTitle: "Where you wnat to share?");
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
