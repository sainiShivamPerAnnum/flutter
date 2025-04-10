import 'dart:async';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DBModel extends ChangeNotifier {
  final Api _api = locator<Api>();
  final Log log = const Log("DBModel");
  final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  final CustomLogger? logger = locator<CustomLogger>();

  Future<String?> getUserDP(String? uid) async {
    try {
      logger!.i("CALLING: getFileFromDPBucketURL");
      return await _api.getFileFromDPBucketURL(uid, 'image');
    } catch (e) {
      log.error('Failed to fetch dp url');
      return null;
    }
  }
}
