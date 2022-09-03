import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/internal_ops_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class InternalOpsService extends ChangeNotifier {
  String phoneModel;
  String softwareVersion;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isDeviceInfoInitiated = false;
  final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  final logger = locator<CustomLogger>();
  final _internalOps = locator<InternalOpsRepository>();
  final Log log = new Log("DBModel");

  Future<Map<String, dynamic>> initDeviceInfo() async {
    String _deviceId;
    String _platform;
    String brand;
    bool isPhysicalDevice;
    if (!isDeviceInfoInitiated) {
      try {
        if (Platform.isIOS) {
          IosDeviceInfo iosDeviceInfo;
          iosDeviceInfo = await deviceInfo.iosInfo;
          phoneModel = iosDeviceInfo.name;
          softwareVersion = iosDeviceInfo.systemVersion;
          _deviceId = iosDeviceInfo.identifierForVendor;
          isPhysicalDevice = iosDeviceInfo.isPhysicalDevice;
          brand = "apple";
          _platform = "ios";
          logger.d(
              "Device Information - \n $phoneModel \n $softwareVersion \n $_deviceId");
        } else if (Platform.isAndroid) {
          AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
          phoneModel = androidDeviceInfo.model;
          softwareVersion = androidDeviceInfo.version.sdkInt.toString();
          _deviceId = androidDeviceInfo.androidId;
          brand = androidDeviceInfo.brand;
          isPhysicalDevice = androidDeviceInfo.isPhysicalDevice;
          _platform = "android";
          logger.d(
              "Device Information - \n phoneModel: $phoneModel \nSoftware version: $softwareVersion \nDeviceId $_deviceId");
        }
        isDeviceInfoInitiated = true;
        return {
          "deviceId": _deviceId,
          "platform": _platform,
          "version": softwareVersion,
          "model": phoneModel,
          "brand": brand,
          "isPhysicalDevice": isPhysicalDevice
        };
      } catch (e) {
        log.error('Initiating Device Info failed');
      }
    }
    return {};
  }

  Future<bool> logFailure(
    String userId,
    FailType failType,
    Map<String, dynamic> data,
  ) async {
    ApiResponse<bool> logResponse;
    Map<String, dynamic> dMap = (data == null) ? {} : data;
    if (!isDeviceInfoInitiated) {
      await initDeviceInfo();
    }
    dMap['user_id'] = userId;
    dMap['fail_type'] = failType.value();
    dMap['manually_resolved'] = false;
    dMap['app_version'] =
        '${BaseUtil?.packageInfo?.version ?? ''}+${BaseUtil?.packageInfo?.buildNumber ?? ''}';
    if (phoneModel != null) {
      dMap['phone_model'] = phoneModel;
    }
    if (softwareVersion != null) {
      dMap['phone_version'] = softwareVersion;
    }
    dMap['timestamp'] = Timestamp.now().millisecondsSinceEpoch;
    await logOnCrashLytics(failType, dMap);
    if (failType == FailType.UserAugmontSellFailed ||
        failType == FailType.UserPaymentCompleteTxnFailed ||
        failType == FailType.UserDataCorrupted ||
        failType == FailType.Splash) {
      logger.i("CALLING: addPriorityFailedReport");
      logResponse = await _internalOps.logFailure(userId, 'priority', dMap);
    } else if (failType == FailType.TambolaTicketGenerationFailed) {
      logger.i("CALLING: addGameFailedReport");
      logResponse = await _internalOps.logFailure(userId, 'game', dMap);
    } else {
      logger.i("CALLING: addFailedReportDocument");
      logResponse = await _internalOps.logFailure(userId, 'default', dMap);
    }
    return logResponse.code == 200 ? true : false;
  }

  Future logOnCrashLytics(FailType failType, Map<String, dynamic> dMap) async {
    try {
      await firebaseCrashlytics.recordError(
        failType.toString(),
        StackTrace.fromString(failType.value().toUpperCase()),
        reason: dMap,
      );
    } catch (e) {
      log.error('Crashlytics record error fail : $e');
    }
  }
}
