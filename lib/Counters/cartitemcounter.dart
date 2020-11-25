import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter =
      TeleMed.sharedPreferences.getStringList(TeleMed.userCartList).length - 1;
  int get count => _counter;

  Future<void> displayResult() async {
    int _counter =
        TeleMed.sharedPreferences.getStringList(TeleMed.userCartList).length -
            1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
