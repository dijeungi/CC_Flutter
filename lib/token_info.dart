import 'package:flutter/material.dart';

class TokenInfo extends ChangeNotifier{
  String? accessToken=null;

  void saveAccessToken(String? token){
    this.accessToken=token;
    notifyListeners();
  }
}