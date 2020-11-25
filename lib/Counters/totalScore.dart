import 'package:flutter/cupertino.dart';

class TotalScore extends ChangeNotifier {
  double _totalScore = 0;

  double get totalAmount => _totalScore;
  displayResult(double no) async {
    _totalScore = no;
    await Future.delayed(
      const Duration(milliseconds: 100),
      () {
        notifyListeners();
      },
    );
  }
}
