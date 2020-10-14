import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/User.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  final Log log = new Log("DBModel");

  Future<bool> updateClientToken(User user, String token) async{
    try{
      //String id = user.mobile;
      String id = user.uid;
      var dMap = {
        'token': token,
        'timestamp': FieldValue.serverTimestamp()
      };
      await _api.updateUserClientToken(id, dMap);
      return true;
    }catch(e) {
      log.error("Failed to update User Client Token: " + e.toString());
      return false;
    }
  }
}