import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';

class GoodDeedCounter extends ChangeNotifier {
  int _gdcounter =
      TeleMed.sharedPreferences.getStringList(TeleMed.userGoodDeeds).length - 1;
  int get count => _gdcounter;

  Future<void> displayResult() async {
    int _counter =
        TeleMed.sharedPreferences.getStringList(TeleMed.userGoodDeeds).length -
            1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
