import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class FcmHandler extends ChangeNotifier {
  Log log = new Log("FcmHandler");

  FcmHandler() {}

  Future<bool> handleMessage(Map data) async{
    return true;
  }
}