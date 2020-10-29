import 'package:flutter/material.dart';

class BusinessLogicProvider extends ChangeNotifier {
  bool _logged = false;

  get getLogged => _logged;

  void setLogged() {
    _logged = _logged == false ? true : false;
    notifyListeners();
  }
}
