import 'package:flutter/material.dart';

class Payee extends ChangeNotifier {
  String? upiId;
  String? payeeName;
  String? ammount;
  String? mobile;

  setUpiId(String pa) {
    upiId = pa;
    notifyListeners();
  }

  setPayeeName(String pn) {
    payeeName = pn;
    notifyListeners();
  }

  setAmmount(String am) {
    ammount = am;
    notifyListeners();
  }

  setMobile(String ph) {
    mobile = ph;
    notifyListeners();
  }
}
