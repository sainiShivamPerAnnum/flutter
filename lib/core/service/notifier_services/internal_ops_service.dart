import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/internal_ops_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class InternalOpsService extends ChangeNotifier {
  String? phoneModel;
  String? _deviceId;
  String? softwareVersion;
  String? osVersion;
  String? integrity;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isDeviceInfoInitiated = false;
  final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  final logger = locator<CustomLogger>();
  final _internalOps = locator<InternalOpsRepository>();
  final Log log = const Log("DBModel");

  Future<bool> checkIfDeviceIsReal() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      logger.d("Device info: ${iosDeviceInfo.isPhysicalDevice}");
      return iosDeviceInfo.isPhysicalDevice ?? true;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      logger.d("Device info: ${androidDeviceInfo.isPhysicalDevice}");
      return androidDeviceInfo.isPhysicalDevice ?? true;
    }
  }

  Future<Map<String, dynamic>> initDeviceInfo() async {
    String? _platform;
    String? brand;
    bool? isPhysicalDevice;
    const BASE_CHANNEL = 'methodChannel/deviceData';
    const platform = MethodChannel(BASE_CHANNEL);

    if (!isDeviceInfoInitiated) {
      try {
        if (Platform.isIOS) {
          IosDeviceInfo iosDeviceInfo;
          iosDeviceInfo = await deviceInfo.iosInfo;
          phoneModel = iosDeviceInfo.name;
          softwareVersion = iosDeviceInfo.systemVersion;
          _deviceId = iosDeviceInfo.identifierForVendor;
          osVersion = iosDeviceInfo.systemVersion;
          brand = "apple";
          _platform = "ios";
          integrity = 'UNAVAILABLE';
          logger.d(
              "Device Information - $phoneModel \n $softwareVersion \n $_deviceId");
        } else if (Platform.isAndroid) {
          AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
          phoneModel = androidDeviceInfo.model;
          softwareVersion = androidDeviceInfo.version.sdkInt.toString();
          _deviceId = androidDeviceInfo.id;
          brand = androidDeviceInfo.brand;
          osVersion = androidDeviceInfo.version.sdkInt.toString();
          isPhysicalDevice = androidDeviceInfo.isPhysicalDevice;
          _platform = "android";

          //try to check if the device is rooted or not
          final bool isDeviceRooted =
              await platform.invokeMethod('isDeviceRooted');
          integrity = (isDeviceRooted) ? 'ROOTED' : 'NOT_ROOTED';
          logger.d(
              "Device Information - phoneModel: $phoneModel \nSoftware version: $softwareVersion \nDeviceId $_deviceId");
        }
        if ((_deviceId ?? '').isEmpty) {
          _deviceId = await getDeviceId();
        }
        if ((_deviceId ?? '').isNotEmpty) isDeviceInfoInitiated = true;
        return {
          "deviceId": _deviceId ?? "",
          "platform": _platform ?? "",
          "version": softwareVersion ?? 0,
          "model": phoneModel ?? "",
          "brand": brand ?? "",
          "isPhysicalDevice": isPhysicalDevice ?? false,
          "osVersion": osVersion ?? "",
          "integrity": integrity ?? ""
        };
      } catch (e) {
        logFailure(
          locator<UserService>().baseUser?.uid ?? '',
          FailType.GetDeviceInfoFailed,
          {'message': "Get Device info failed"},
        );
        log.error('Initiating Device Info failed');
      }
    }
    return {};
  }

  Future<bool> logFailure(
    String? userId,
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
        '${BaseUtil.packageInfo?.version ?? ''}+${BaseUtil.packageInfo?.buildNumber ?? ''}';
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

Future<String> getDeviceId() async {
  String deviceId = "";
  try {
    const platform = MethodChannel("methodChannel/deviceData");

    final String result = await platform.invokeMethod('getDeviceId');
    deviceId = result;
  } catch (e) {
    debugPrint(e.toString());
    deviceId = "";
  }
  return deviceId;
}
