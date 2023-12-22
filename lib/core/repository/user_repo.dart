// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/model/app_environment.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_bootup_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'base_repo.dart';

class UserRepository extends BaseRepo {
  final AppFlyerAnalytics _appsFlyerService = locator<AppFlyerAnalytics>();
  final CustomLogger _logger = locator<CustomLogger>();
  final Api _api = locator<Api>();
  final ApiPath _apiPaths = locator<ApiPath>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();

  static const _userOps = 'userOps';

  Future<ApiResponse<String>> getCustomUserToken(String? mobileNo) async {
    try {
      final body = {
        "mobileNumber": mobileNo,
      };
      final res = await APIService.instance.postData(
        _apiPaths.kCustomAuthToken,
        body: body,
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/trucallerAuthToken',
        headers: {
          'authKey':
              '.c;a/>12-1-x[/2130x0821x/0-=0.-x02348x042n23x9023[4np0823wacxlonluco3q8',
        },
      );

      if (res['token'] == null) {
        return ApiResponse.withError("Unable to signup using truecaller", 400);
      }

      return ApiResponse(model: res['token'], code: 200);
    } catch (e) {
      return ApiResponse.withError("Unable to signup using truecaller", 400);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> setNewUser(
    BaseUser baseUser,
  ) async {
    try {
      final body = {
        'uid': baseUser.uid,
        'data': {
          BaseUser.fldMobile: baseUser.mobile,
          BaseUser.fldName: baseUser.name,
          BaseUser.fldEmail: baseUser.email,
          BaseUser.fldIsEmailVerified: baseUser.isEmailVerified ?? false,
          BaseUser.fldDob: baseUser.dob,
          BaseUser.fldGender: baseUser.gender,
          BaseUser.fldUsername: baseUser.username,
          BaseUser.fldAvatarId: baseUser.avatarId,
          BaseUser.fldUserPrefs: {"tn": 1, "al": 0},
          BaseUser.fldAppFlyerId: await _appsFlyerService.appFlyerId,
          BaseUser.fldReferralCode: BaseUtil.manualReferralCode ?? '',
        }
      };

      final res = await APIService.instance.postData(
        _apiPaths.kAddNewUser,
        cBaseUrl: AppEnvironment.instance.userOps,
        body: body,
        apiName: '$_userOps/setNewUser',
      );
      logger.d(res);
      final responseData = res['data'];
      logger.d(responseData);
      return ApiResponse(
          code: 200,
          model: {"flag": responseData['flag'], "gtId": responseData['gtId']});
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<BaseUser>> getUserById({required String? id}) async {
    try {
      final res = await APIService.instance.getData(
        ApiPath.kGetUserById(id),
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/getUser',
      );
      if (res != null && res['data'] != null && res['data'].isNotEmpty) {
        final user = BaseUser.fromMap(res['data'], id!);
        return ApiResponse<BaseUser>(model: user, code: 200);
      } else {
        return ApiResponse<BaseUser>(model: null, code: 200);
      }
    } catch (e) {
      logger.d(e.toString());
      await locator<InternalOpsService>().logFailure(
        id,
        FailType.UserDataCorrupted,
        {'message': "User data corrupted"},
      );
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse> sendOtp(String? mobile, String hash) async {
    try {
      final body = {
        'mobile': mobile,
        'hash': hash,
      };

      await APIService.instance.postData(
        ApiPath.sendOtp,
        body: body,
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/sendOTP',
      );

      logger.d("reached");
      return ApiResponse(code: 200);
    } catch (e) {
      logger.d(e);
      await locator<InternalOpsService>().logFailure(
        mobile,
        FailType.SendOtpFailed,
        {'message': "Send otp failed"},
      );
      return ApiResponse.withError("send OTP failed", 400);
    }
  }

  Future<ApiResponse<String>> verifyOtp(String? mobile, String otp) async {
    try {
      final query = {
        'mobile': mobile,
        'otp': otp,
      };

      final res = await APIService.instance.getData(
        ApiPath.verifyOtp,
        queryParams: query,
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/verifyOTP',
      );

      return ApiResponse(code: 200, model: res['data']['token']);
    } on UnauthorizedException catch (_) {
      return ApiResponse.withError("Invalid Otp", 400);
    } catch (e) {
      logger.d("verifyOtp error $e");
      unawaited(locator<InternalOpsService>().logFailure(
        mobile,
        FailType.VerifyOtpFailed,
        {'message': "Verify Otp failed"},
      ));
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<UserFundWallet>> getFundBalance() async {
    try {
      final uid = userService.baseUser!.uid;

      final res = await APIService.instance.getData(
        ApiPath.getFundBalance(uid),
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/getWalletFund',
      );
      logger.d('fund balance $res');

      return ApiResponse(
        model: UserFundWallet.fromMap(res['data']),
        code: 200,
      );
    } catch (e) {
      logger.e('fund balance $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FlcModel>> getCoinBalance() async {
    try {
      final uid = userService.baseUser?.uid;

      final res = await APIService.instance.getData(
        ApiPath.getCoinBalance(uid),
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/getWalletCoin',
      );

      return ApiResponse(
        model: FlcModel.fromMap(res['data']),
        code: 200,
      );
    } catch (e) {
      logger.e('coin balance $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<void> removeUserFCM(String? userUid) async {
    try {
      await _api.deleteUserClientToken(userUid);
      logger.d("Token successfully removed from firestore, on user signout.");
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  Future<void> setNewDeviceId(
      {required String? uid,
      required String? deviceId,
      required String? platform,
      required String? model,
      required String? brand,
      required String? version,
      required bool? isPhysicalDevice,
      String? integrity}) async {
    try {
      String? appInstanceId;
      try {
        appInstanceId = await FirebaseAnalytics.instance.appInstanceId;
      } catch (e) {}

      Map<String, dynamic> body = {
        "uid": uid ?? "",
        "deviceId": deviceId ?? "",
        "platform": platform ?? "",
        "model": model ?? "",
        "brand": brand ?? "",
        "version": version ?? "",
        "isPhysicalDevice": isPhysicalDevice ?? true,
        "integrity": integrity ?? "",
        'firebaseAppInstanceId': appInstanceId,
      };
      logger.d("Device info: $body");
      await APIService.instance.postData(
        ApiPath.kDeviceId,
        body: body,
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/setDeviceID',
      );

      logger.d("Device added: $body");
    } catch (e) {
      await locator<InternalOpsService>().logFailure(
        uid,
        FailType.DeviceIdUpdateFailed,
        {'message': "Sending Device Id failed"},
      );
      logger.e(e);
    }
  }

  Future<ApiResponse<UserAugmontDetail>> getUserAugmontDetails() async {
    try {
      logger.i("CALLING: getUserAugmontDetails");
      final augmontRespone = await APIService.instance.getData(
        ApiPath.getAugmontDetail(
          userService.baseUser!.uid,
        ),
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/getAugmontDetails',
      );

      final augmont = UserAugmontDetail.fromMap(augmontRespone['data']);
      return ApiResponse<UserAugmontDetail>(model: augmont, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch augmont", 400);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>>
      checkIfUserHasNewNotifications() async {
    try {
      final latestNotificationsResponse = await APIService.instance.getData(
        ApiPath.getLatestNotification(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/getNotifications',
      );

      final List<AlertModel> notifications = AlertModel.helper.fromMapArray(
        latestNotificationsResponse["data"],
      );

      String? latestNotifTime = await CacheManager.readCache(
          key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME);

      if ((notifications[0].isPersistent ?? false) &&
          notifications[0].createdTime != null) {
        var notifTime = notifications[0].createdTime!.seconds.toString();

        if (!PreferenceHelper.exists(
            PreferenceHelper.CACHE_REFERRAL_PERSISTENT_NOTIFACTION_ID)) {
          if (notifications[0].misc != null &&
              notifications[0].misc!.isSuperFello!) {
            await PreferenceHelper.setString(
              CacheManager.CACHE_REFERRAL_PERSISTENT_NOTIFACTION_ID,
              notifications[0].id!.toString(),
            );

            return ApiResponse(
                model: {"flag": true, "notification": notifications[0]},
                code: 200);
          }

          log('Referral Notification Valid');
          // notifications[0] is the latest notification
          // if the notification is persistent then we need to show the notification only once in 48 hours
          // so we are checking if the notification is created in last 48 hours
          int notifTimeInSeconds = int.tryParse(notifTime)!;
          int currentTimeInSeconds =
              DateTime.now().millisecondsSinceEpoch ~/ 1000;
          if (currentTimeInSeconds - notifTimeInSeconds < 172800) {
            await PreferenceHelper.setString(
              CacheManager.CACHE_REFERRAL_PERSISTENT_NOTIFACTION_ID,
              notifications[0].id!.toString(),
            );

            if (notifications[0].misc != null &&
                notifications[0].misc?.gtId != null) {
              ScratchCardService.scratchCardId = notifications[0].misc!.gtId!;
            }

            // userService.referralAlertDialog = notifications[0];
            return ApiResponse(
                model: {"flag": true, "notification": notifications[0]},
                code: 200);
          }
        }
      }

      if (latestNotifTime != null) {
        int latestTimeInSeconds = int.tryParse(latestNotifTime)!;
        AlertModel latestAlert = notifications[0].createdTime!.seconds >
                notifications[1].createdTime!.seconds
            ? notifications[0]
            : notifications[1];
        if (latestAlert.createdTime!.seconds > latestTimeInSeconds) {
          return ApiResponse(
              model: {"flag": true, "notification": null}, code: 200);
        } else {
          return ApiResponse(
              model: {"flag": false, "notification": null}, code: 200);
        }
      } else {
        logger.d("No past notification time found");
        return ApiResponse(
            model: {"flag": false, "notification": null}, code: 200);
      }
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(
        "Unable to fetch checkIfUserHasNewNotifications",
        400,
      );
    }
  }

  Future<ApiResponse<List<AlertModel>>> getUserNotifications(
    String? lastDocId,
  ) async {
    try {
      final userNotifications = await APIService.instance.getData(
        ApiPath.getNotifications(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.userOps,
        queryParams: {
          "lastDocId": lastDocId,
        },
        apiName: '$_userOps/getNotifications',
      );

      final responseData = userNotifications["data"];

      return ApiResponse<List<AlertModel>>(
        model: AlertModel.helper.fromMapArray(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(
        "Unable to fetch user notifications",
        400,
      );
    }
  }

  Future<ApiResponse<bool>> updateUser({
    required Map<String, dynamic> dMap,
    String? uid,
  }) async {
    try {
      final res = await APIService.instance.putData(
        ApiPath.kGetUserById(userService.baseUser!.uid),
        body: dMap,
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/updateUser',
      );
      logger.d("Update user data: ${res['data']}");
      final resData = res['data'];
      if (resData != null && resData['gtId'] != null) {
        ScratchCardService.scratchCardId = resData['gtId'];
      }
      // clear cache
      await CacheService.invalidateByKey(CacheKeys.USER);

      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      unawaited(locator<InternalOpsService>().logFailure(
        uid,
        FailType.UpdateUserFailed,
        {'message': "Update user failed"},
      ));
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<bool>> updateFcmToken({
    required String? fcmToken,
  }) async {
    try {
      await APIService.instance.putData(
        ApiPath.updateFcm,
        body: {
          "userId": userService.baseUser!.uid,
          "token": fcmToken,
        },
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/updateFCMToken',
      );

      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      await locator<InternalOpsService>().logFailure(
        userService.baseUser?.uid ?? "",
        FailType.UpdateUserFailed,
        {'message': "Update fcm token failed"},
      );
      return ApiResponse.withError(
        "Unable to update fcm",
        400,
      );
    }
  }

  Future<ApiResponse<bool>> completeOnboarding() async {
    try {
      log("completeOnboarding");

      await APIService.instance.postData(
        ApiPath.getCompleteOnboarding(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/walkThrough',
      );

      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(
        "Unable to update fcm",
        400,
      );
    }
  }

  Future<bool> logOut() async {
    try {
      Map<String, dynamic> response =
          await _internalOpsService.initDeviceInfo();
      final String? deviceId = response["deviceId"];
      final String? platform = response["platform"];
      final String? model = response["model"];
      final String? brand = response["brand"];
      final bool? isPhysicalDevice = response["isPhysicalDevice"];
      final String? version = response["version"];
      final String? integrity = response["integrity"];
      logger.d("Device Details: $response");
      final res = await APIService.instance.putData(
        ApiPath.logOut(userService.baseUser!.uid),
        cBaseUrl: AppEnvironment.instance.userOps,
        body: {
          "uid": userService.baseUser!.uid ?? "",
          "deviceId": deviceId ?? "",
          "platform": platform ?? "",
          "model": model ?? "",
          "brand": brand ?? "",
          "version": version ?? "",
          "isPhysicalDevice": isPhysicalDevice ?? true,
          "integrity": integrity ?? "",
        },
        apiName: '$_userOps/logout',
      );
      logger.d("LogOut response: ${res.toString()}");
      return true;
    } catch (e) {
      await locator<InternalOpsService>().logFailure(
        userService.baseUser?.uid ?? "",
        FailType.UserRepoLogoutFailed,
        {'message': "User Repo logout failed"},
      );
      logger.e(e);
      return false;
    }
  }

  //Method to fetch the user-boot-up-ee

  Future<ApiResponse<UserBootUpDetailsModel>> fetchUserBootUpRssponse(
      {required String? userId,
      required String? deviceId,
      required String? platform,
      required String appVersion,
      required String lastOpened,
      required int dayOpenCount}) async {
    UserBootUpDetailsModel userBootUp;

    String? appInstanceId;
    try {
      appInstanceId = await FirebaseAnalytics.instance.appInstanceId;
    } catch (e) {}

    // try {
    Map<String, dynamic> queryParameters = {
      'deviceId': deviceId,
      'platform': platform,
      'appVersion': appVersion,
      'lastOpened': lastOpened,
      'dayOpenCount': dayOpenCount.toString(),
      'firebaseAppInstanceId': appInstanceId,
    };

    final respone = await APIService.instance.getData(
      ApiPath.userBootUp(
        userService.baseUser?.uid,
      ),
      queryParams: queryParameters,
      cBaseUrl: AppEnvironment.instance.userOps,
      apiName: '$_userOps/bootupAlerts',
    );
    debugPrint("Bootup Response: $respone");
    userBootUp = UserBootUpDetailsModel.fromMap(respone);

    return ApiResponse<UserBootUpDetailsModel>(model: userBootUp, code: 200);
    // } catch (e) {
    //   logger!.d("Unable to fetch user boot up ee ${e.toString()}");
    //   locator<InternalOpsService>().logFailure(
    //     userService.baseUser?.uid ?? "",
    //     FailType.UserBootUpDetailsFetchFailed,
    //     {'message': "User Bootup details fetch failed"},
    //   );
    //   return ApiResponse.withError(
    //       e.toString() ?? "Unable to get user bootup details", 400);
    // }
  }

  Future<ApiResponse<bool>> isEmailRegistered(String email) async {
    try {
      final query = {
        'email': email,
      };
      final uid = userService.baseUser?.uid;
      final res = await APIService.instance.getData(
        ApiPath.isEmailRegistered(uid),
        queryParams: query,
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/emailRegistered',
      );

      return ApiResponse(code: 200, model: res['data']['isEmailRegistered']);
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError("send OTP failed", 400);
    }
  }

  Future<ApiResponse<bool>> isUsernameAvailable(String username) async {
    try {
      final query = {
        'username': username,
      };

      final res = await APIService.instance.getData(
        ApiPath.isUsernameAvailable,
        queryParams: query,
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/userNameAvailable',
      );
      return ApiResponse(code: 200, model: res['data']['isAvailable']);
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<Portfolio>> getPortfolioData() async {
    try {
      final uid = userService.baseUser!.uid;
      final res = await APIService.instance.getData(
        ApiPath.portfolio(uid!),
        cBaseUrl: AppEnvironment.instance.userOps,
        apiName: '$_userOps/portfolio',
      );
      _logger.i("Portfolio: ${res['data']}");
      final Portfolio portfolio = Portfolio.fromMap(res['data']);
      return ApiResponse(code: 200, model: portfolio);
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
