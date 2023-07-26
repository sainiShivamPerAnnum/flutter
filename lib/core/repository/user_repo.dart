import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/alert_model.dart';
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
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

import 'base_repo.dart';

class UserRepository extends BaseRepo {
  final AppFlyerAnalytics? _appsFlyerService = locator<AppFlyerAnalytics>();
  final _cacheService = CacheService();

  final Api? _api = locator<Api>();
  final ApiPath? _apiPaths = locator<ApiPath>();
  final InternalOpsService? _internalOpsService = locator<InternalOpsService>();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://6w37rw51hj.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://7y9layzs7j.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<String>> getCustomUserToken(String? mobileNo) async {
    try {
      final _body = {
        "mobileNumber": mobileNo,
      };
      final res = await APIService.instance.postData(
        _apiPaths!.kCustomAuthToken,
        body: _body,
        cBaseUrl: _baseUrl,
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
      BaseUser baseUser, token) async {
    try {
      final String _bearer = token;

      final _body = {
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
          BaseUser.fldAppFlyerId: await _appsFlyerService!.appFlyerId,
          BaseUser.fldReferralCode: BaseUtil.manualReferralCode ?? '',
        }
      };

      final res = await APIService.instance.postData(_apiPaths!.kAddNewUser,
          cBaseUrl: _baseUrl, body: _body, token: _bearer);
      logger.d(res);
      final responseData = res['data'];
      logger.d(responseData);
      return ApiResponse(
          code: 200,
          model: {"flag": responseData['flag'], "gtId": responseData['gtId']});
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(
          e.toString() ?? "Unable to create user account", 400);
    }
  }

  Future<ApiResponse<BaseUser>> getUserById({required String? id}) async {
    try {
      final token = await getBearerToken();

      return await _cacheService.cachedApi(
          CacheKeys.USER,
          TTL.ONE_DAY,
          () => APIService.instance.getData(
                ApiPath.kGetUserById(id),
                cBaseUrl: _baseUrl,
                token: token,
              ), (dynamic res) {
        try {
          if (res != null && res['data'] != null && res['data'].isNotEmpty) {
            final _user = BaseUser.fromMap(res['data'], id!);
            return ApiResponse<BaseUser>(model: _user, code: 200);
          } else {
            return ApiResponse<BaseUser>(model: null, code: 200);
          }
        } catch (e) {
          locator<InternalOpsService>().logFailure(
            id,
            FailType.UserDataCorrupted,
            {'message': "User data corrupted"},
          );
          return ApiResponse.withError("User data corrupted", 400);
        }
      });
    } catch (e) {
      logger!.d(e.toString());
      return ApiResponse.withError(e.toString() ?? "Unable to get user", 400);
    }
  }

  Future<ApiResponse> updateUserAppFlyer(BaseUser user, String token) async {
    try {
      logger!.i("CALLING: updateUserAppFlyer");
      final id = await _appsFlyerService!.appFlyerId;

      if (user.appFlyerId == id) {
        return ApiResponse(code: 200);
      }

      final body = {
        'uid': user.uid,
        'appFlyerId': id,
      };

      await APIService.instance.putData(
        _apiPaths!.kUpdateUserAppflyer,
        body: body,
        cBaseUrl: _baseUrl,
        token: token,
      );

      // clear cache
      await CacheService.invalidateByKey(CacheKeys.USER);

      return ApiResponse(code: 200);
    } catch (e) {
      logger!.d(e);
      return ApiResponse.withError("User not added to firestore", 400);
    }
  }

  Future<ApiResponse> sendOtp(String? mobile, String hash) async {
    try {
      final body = {
        'mobile': mobile,
        'hash': hash,
      };

      await APIService.instance
          .postData(ApiPath.sendOtp, body: body, cBaseUrl: _baseUrl);

      logger!.d("reached");
      return ApiResponse(code: 200);
    } catch (e) {
      logger!.d(e);
      locator<InternalOpsService>().logFailure(
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
        cBaseUrl: _baseUrl,
      );

      return ApiResponse(code: 200, model: res['data']['token']);
    } on UnauthorizedException catch (_) {
      return ApiResponse.withError("Invalid Otp", 400);
    } catch (e) {
      logger!.d("verifyOtp error $e");
      unawaited(locator<InternalOpsService>().logFailure(
        mobile,
        FailType.VerifyOtpFailed,
        {'message': "Verify Otp failed"},
      ));
      return ApiResponse.withError(e.toString() ?? "send OTP failed", 400);
    }
  }

  Future<ApiResponse<UserFundWallet>> getFundBalance() async {
    try {
      final uid = userService!.baseUser!.uid;
      final token = await getBearerToken();

      final res = await APIService.instance.getData(
        ApiPath.getFundBalance(uid),
        token: token,
        cBaseUrl: _baseUrl,
      );
      logger!.d('fund balance $res');

      return ApiResponse(
        model: UserFundWallet.fromMap(res['data']),
        code: 200,
      );
    } catch (e) {
      logger!.e('fund balance $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FlcModel>> getCoinBalance() async {
    try {
      final uid = userService?.baseUser?.uid;
      final token = await getBearerToken();

      final res = await APIService.instance.getData(
        ApiPath.getCoinBalance(uid),
        token: token,
        cBaseUrl: _baseUrl,
      );

      return ApiResponse(
        model: FlcModel.fromMap(res['data']),
        code: 200,
      );
    } catch (e) {
      logger!.e('coin balance $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<void> removeUserFCM(String? userUid) async {
    try {
      await _api!.deleteUserClientToken(userUid);
      logger!.d("Token successfully removed from firestore, on user signout.");
    } catch (e) {
      logger!.e(e);
      throw e;
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
      final token = await getBearerToken();
      Map<String, dynamic> _body = {
        "uid": uid ?? "",
        "deviceId": deviceId ?? "",
        "platform": platform ?? "",
        "model": model ?? "",
        "brand": brand ?? "",
        "version": version ?? "",
        "isPhysicalDevice": isPhysicalDevice ?? true,
        "integrity": integrity ?? "",
      };
      logger!.d("Device info: $_body");
      await APIService.instance.postData(
        ApiPath.kDeviceId,
        body: _body,
        cBaseUrl: _baseUrl,
        token: token,
      );

      logger!.d("Device added: $_body");
    } catch (e) {
      locator<InternalOpsService>().logFailure(
        uid,
        FailType.DeviceIdUpdateFailed,
        {'message': "Sending Device Id failed"},
      );
      logger!.e(e);
    }
  }

  Future<ApiResponse<UserAugmontDetail>> getUserAugmontDetails() async {
    try {
      logger!.i("CALLING: getUserAugmontDetails");
      final token = await getBearerToken();
      final augmontRespone = await APIService.instance.getData(
        ApiPath.getAugmontDetail(
          userService!.baseUser!.uid,
        ),
        cBaseUrl: _baseUrl,
        token: token,
      );

      final augmont = UserAugmontDetail.fromMap(augmontRespone['data']);
      return ApiResponse<UserAugmontDetail>(model: augmont, code: 200);
    } catch (e) {
      logger!.e(e.toString());
      return ApiResponse.withError("Unable to fetch augmont", 400);
    }
  }

  Future<ApiResponse<bool>> checkIfUserHasNewNotifications() async {
    try {
      final token = await getBearerToken();
      final latestNotificationsResponse = await APIService.instance.getData(
        ApiPath.getLatestNotification(userService!.baseUser!.uid),
        cBaseUrl: _baseUrl,
        token: token,
      );

      final List<AlertModel> notifications = AlertModel.helper.fromMapArray(
        latestNotificationsResponse["data"],
      );

      String? latestNotifTime = await CacheManager.readCache(
          key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME);

      if ((notifications[0].isPersistent ?? false) &&
          notifications[0].createdTime != null) {
        var notifTime = notifications[0].createdTime!.seconds.toString();

        // notifications[0] is the latest notification
        // if the notification is persistent then we need to show the notification only once in 48 hours
        // so we are checking if the notification is created in last 48 hours

        if (!await CacheManager.exits(
            CacheManager.CACHE_REFERRAL_PERSISTENT_NOTIFACTION_ID)) {
          int notifTimeInSeconds = int.tryParse(notifTime)!;
          int currentTimeInSeconds =
              DateTime.now().millisecondsSinceEpoch ~/ 1000;
          if (currentTimeInSeconds - notifTimeInSeconds < 172800) {
            CacheManager.writeCache(
                key: CacheManager.CACHE_REFERRAL_PERSISTENT_NOTIFACTION_ID,
                value: notifications[0].id!.toString(),
                type: CacheType.string);

            if (notifications[0].misc != null &&
                notifications[0].misc?.gtId != null) {
              userService.fcmHandlerReferralGT(notifications[0].misc!.gtId!);
            }

            userService.referralAlertDialog = notifications[0];
            return ApiResponse<bool>(model: true, code: 200);
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
          return ApiResponse<bool>(model: true, code: 200);
        } else {
          return ApiResponse<bool>(model: false, code: 200);
        }
      } else {
        logger.d("No past notification time found");
        return ApiResponse<bool>(model: false, code: 200);
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
      final token = await getBearerToken();
      final userNotifications = await APIService.instance.getData(
        ApiPath.getNotifications(userService!.baseUser!.uid),
        cBaseUrl: _baseUrl,
        queryParams: {
          "lastDocId": lastDocId,
        },
        token: token,
      );

      final responseData = userNotifications["data"];

      return ApiResponse<List<AlertModel>>(
        model: AlertModel.helper.fromMapArray(responseData),
        code: 200,
      );
    } catch (e) {
      logger!.e(e);
      return ApiResponse.withError(
        "Unable to fetch user notifications",
        400,
      );
    }
  }

  Future<ApiResponse<bool>> updateUser({
    String? uid,
    required Map<String, dynamic> dMap,
  }) async {
    final token = await getBearerToken();
    try {
      final res = await APIService.instance.putData(
        ApiPath.kGetUserById(userService!.baseUser!.uid),
        body: dMap,
        token: token,
        cBaseUrl: _baseUrl,
      );
      logger!.d("Update user data: ${res['data']}");
      final resData = res['data'];
      if (resData != null && resData['gtId'] != null) {
        ScratchCardService.scratchCardId = resData['gtId'];
      }
      // clear cache
      await CacheService.invalidateByKey(CacheKeys.USER);

      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      logger!.e(e);
      locator<InternalOpsService>().logFailure(
        uid,
        FailType.UpdateUserFailed,
        {'message': "Update user failed"},
      );
      return ApiResponse.withError(
        e.toString() ?? "Unable to update user",
        400,
      );
    }
  }

  Future<ApiResponse<bool>> updateFcmToken({
    required String? fcmToken,
  }) async {
    try {
      final token = await getBearerToken();
      await APIService.instance.putData(
        ApiPath.updateFcm,
        body: {
          "userId": userService!.baseUser!.uid,
          "token": fcmToken,
        },
        cBaseUrl: _baseUrl,
        token: token,
      );

      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      logger!.e(e);
      locator<InternalOpsService>().logFailure(
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
      final token = await getBearerToken();
      await APIService.instance.postData(
        ApiPath.getCompleteOnboarding(userService!.baseUser!.uid),
        cBaseUrl: _baseUrl,
        token: token,
      );

      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      logger!.e(e);
      return ApiResponse.withError(
        "Unable to update fcm",
        400,
      );
    }
  }

  Future<bool> logOut() async {
    try {
      final token = await getBearerToken();
      Map<String, dynamic> response =
          await _internalOpsService!.initDeviceInfo();
      if (response != null) {
        final String? deviceId = response["deviceId"];
        final String? platform = response["platform"];
        final String? model = response["model"];
        final String? brand = response["brand"];
        final bool? isPhysicalDevice = response["isPhysicalDevice"];
        final String? version = response["version"];
        final String? integrity = response["integrity"];
        logger!.d("Device Details: $response");
        final res = await APIService.instance.putData(
            ApiPath.logOut(userService!.baseUser!.uid),
            cBaseUrl: _baseUrl,
            token: token,
            body: {
              "uid": userService!.baseUser!.uid ?? "",
              "deviceId": deviceId ?? "",
              "platform": platform ?? "",
              "model": model ?? "",
              "brand": brand ?? "",
              "version": version ?? "",
              "isPhysicalDevice": isPhysicalDevice ?? true,
              "integrity": integrity ?? "",
            });
        logger!.d("LogOut response: ${res.toString()}");
      }
      return true;
    } catch (e) {
      locator<InternalOpsService>().logFailure(
        userService.baseUser?.uid ?? "",
        FailType.UserRepoLogoutFailed,
        {'message': "User Repo logout failed"},
      );
      logger!.e(e);
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

    // try {
    Map<String, dynamic> queryParameters = {
      'deviceId': deviceId,
      'platform': platform,
      'appVersion': appVersion,
      'lastOpened': lastOpened,
      'dayOpenCount': dayOpenCount.toString(),
    };

    final token = await getBearerToken();

    final respone = await APIService.instance.getData(
      ApiPath.userBootUp(
        userService.baseUser?.uid,
      ),
      token: token,
      queryParams: queryParameters,
      cBaseUrl: _baseUrl,
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
      final token = await getBearerToken();
      final uid = userService?.baseUser?.uid;
      final res = await APIService.instance.getData(
          ApiPath.isEmailRegistered(uid),
          queryParams: query,
          cBaseUrl: _baseUrl,
          token: token);

      return ApiResponse(code: 200, model: res['data']['isEmailRegistered']);
    } catch (e) {
      logger!.d(e);
      return ApiResponse.withError("send OTP failed", 400);
    }
  }

  Future<ApiResponse<bool>> isUsernameAvailable(String username) async {
    try {
      final query = {
        'username': username,
      };
      final token = await getBearerToken();
      final res = await APIService.instance.getData(ApiPath.isUsernameAvailable,
          queryParams: query, cBaseUrl: _baseUrl, token: token);
      return ApiResponse(code: 200, model: res['data']['isAvailable']);
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<Portfolio>> getPortfolioData() async {
    try {
      final uid = userService.baseUser!.uid;
      final token = await getBearerToken();
      final res = await APIService.instance
          .getData(ApiPath.portfolio(uid!), cBaseUrl: _baseUrl, token: token);
      final Portfolio portfolio = Portfolio.fromMap(res['data']);
      return ApiResponse(code: 200, model: portfolio);
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
