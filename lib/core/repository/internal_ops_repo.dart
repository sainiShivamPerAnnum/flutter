import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'base_repo.dart';

class InternalOpsRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qdp0idzhjc.execute-api.ap-south-1.amazonaws.com/dev'
      : '';
  String phoneModel;
  String softwareVersion;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isDeviceInfoInitiated = false;
  final FirebaseCrashlytics firebaseCrashlytics = FirebaseCrashlytics.instance;
  final Log log = new Log("DBModel");

  Future<Map<String, dynamic>> initDeviceInfo() async {
    String _deviceId;
    String _platform;
    if (!isDeviceInfoInitiated) {
      try {
        if (Platform.isIOS) {
          IosDeviceInfo iosDeviceInfo;
          iosDeviceInfo = await deviceInfo.iosInfo;
          phoneModel = iosDeviceInfo.model;
          softwareVersion = iosDeviceInfo.systemVersion;
          _deviceId = iosDeviceInfo.identifierForVendor;
          _platform = "ios";
          logger.d(
              "Device Information - \n $phoneModel \n $softwareVersion \n $_deviceId");
        } else if (Platform.isAndroid) {
          AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
          phoneModel = androidDeviceInfo.model;
          softwareVersion = androidDeviceInfo.version.release;
          _deviceId = androidDeviceInfo.androidId;
          _platform = "android";
          logger.d(
              "Device Information - \n $phoneModel \n $softwareVersion \n $_deviceId");
        }
        isDeviceInfoInitiated = true;
        return {"deviceId": _deviceId, "platform": _platform};
      } catch (e) {
        log.error('Initiating Device Info failed');
      }
    }
    return {};
  }

  Future<ApiResponse<bool>> logFailure(
    String userId,
    FailType failType,
    Map<String, dynamic> data,
  ) async {
    try {
      Map<String, dynamic> dMap = (data == null) ? {} : data;
      if (!isDeviceInfoInitiated) {
        await initDeviceInfo();
      }
      dMap['user_id'] = userId;
      dMap['fail_type'] = failType.value();
      dMap['manually_resolved'] = false;
      dMap['app_version'] =
          '${BaseUtil.packageInfo.version}+${BaseUtil.packageInfo.buildNumber}';
      if (phoneModel != null) {
        dMap['phone_model'] = phoneModel;
      }
      if (softwareVersion != null) {
        dMap['phone_version'] = softwareVersion;
      }
      dMap['timestamp'] = Timestamp.now();
      try {
        await firebaseCrashlytics.recordError(failType.toString(),
            StackTrace.fromString(failType.value().toUpperCase()),
            reason: dMap);
      } catch (e) {
        log.error('Crashlytics record error fail : $e');
      }
      if (failType == FailType.UserAugmontSellFailed ||
          failType == FailType.UserPaymentCompleteTxnFailed ||
          failType == FailType.UserDataCorrupted) {
        logger.i("CALLING: addPriorityFailedReport");
        await APIService.instance.postData(
          ApiPath.failureReport,
          body: {
            'type': 'priority',
            'report': dMap,
          },
          cBaseUrl: _baseUrl,
        );
      } else if (failType == FailType.TambolaTicketGenerationFailed) {
        logger.i("CALLING: addGameFailedReport");
        await APIService.instance.postData(
          ApiPath.failureReport,
          body: {
            'type': 'game',
            'report': dMap,
          },
          cBaseUrl: _baseUrl,
        );
      } else {
        logger.i("CALLING: addFailedReportDocument");
        await APIService.instance.postData(
          ApiPath.failureReport,
          body: {
            'type': 'default',
            'report': dMap,
          },
          cBaseUrl: _baseUrl,
        );
      }
      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      log.error(e.toString());
      return ApiResponse.withError("Logging failure", 400);
    }
  }
}
