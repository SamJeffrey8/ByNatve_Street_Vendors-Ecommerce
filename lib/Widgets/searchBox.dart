import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Store/Search.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      InkWell(
        onTap: () {
          Route route = MaterialPageRoute(builder: (c) => SearchProduct());
          Navigator.push(context, route);
        },
        child: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment(
                  0.8, 0.0), // 10% of the width, so there are ten blinds.
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror, // repeats the gradient over the canvas
            ),
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Search Location Here",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
