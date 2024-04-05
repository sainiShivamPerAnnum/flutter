import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/api_response.dart';
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

//------------------------------------------------REALTIME----------------------------

  Future<bool> checkIfUsernameIsAvailable(String username) async {
    logger!.i("CALLING: checkUserNameAvailability");
    return await _api.checkUserNameAvailability(username);
  }

  Future<bool> sendEmailToVerifyEmail(String email, String otp) async {
    logger!.i("CALLING: createEmailVerificationDocument");
    return await _api.createEmailVerificationDocument(email, otp);
  }

  Future fetchCategorySpecificFAQ(String category) async {
    try {
      logger!.i("CALLING: fetchFaqs");
      final DocumentSnapshot response =
          (await _api.fetchFaqs(category)) as DocumentSnapshot<Object?>;
      logger!.d(response.data().toString());
      return ApiResponse(
        model: FAQModel.fromMap(response.data() as Map<String, dynamic>),
        code: 200,
      );
    } catch (e) {
      logger!.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
