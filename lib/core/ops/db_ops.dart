import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/User.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class DBModel extends ChangeNotifier {
  Api _api = locator<Api>();
  final Log log = new Log("DBModel");

  Future<bool> updateClientToken(User user, String token) async {
    try {
      //String id = user.mobile;
      String id = user.uid;
      var dMap = {'token': token, 'timestamp': FieldValue.serverTimestamp()};
      await _api.updateUserClientToken(id, dMap);
      return true;
    } catch (e) {
      log.error("Failed to update User Client Token: " + e.toString());
      return false;
    }
  }

  Future<User> getUser(String id) async {
    try {
      var doc = await _api.getUserById(id);
      return User.fromMap(doc.data, id);
    } catch (e) {
      log.error("Error fetch User details: " + e.toString());
      return null;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      //String id = user.mobile;
      String id = user.uid;
      await _api.updateUserDocument(id, user.toJson());
      return true;
    } catch (e) {
      log.error("Failed to update user object: " + e.toString());
      return false;
    }
  }

  Future<bool> pushTicketRequest(User user, int count) async {
    try {
      String _uid = user.uid;
      var rMap = {
        'user_id': _uid,
        'manual': false,
        'count': count,
        'timestamp': FieldValue.serverTimestamp()
      };
      await _api.createTicketRequest(rMap);
      return true;
    } catch (e) {
      log.error('Failed to push new request: ' + e.toString());
      return false;
    }
  }
}
