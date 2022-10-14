import 'package:flutter/cupertino.dart';

class CheckState extends ChangeNotifier{
  bool _isChanged = false;
  bool get isChanged => _isChanged;

  setValue(bool value){
    _isChanged = value;
    notifyListeners();
  }

  updateValue(value){
    print("updated");
    _isChanged = value;
    notifyListeners();
  }
}