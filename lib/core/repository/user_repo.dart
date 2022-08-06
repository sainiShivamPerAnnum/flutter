import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/fundbalance_model.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';

import 'base_repo.dart';

class UserRepository extends BaseRepo {
  final _appsFlyerService = locator<AppFlyerAnalytics>();
  final _cacheService = new CacheService();

  final _api = locator<Api>();
  final _apiPaths = locator<ApiPath>();
  final _internalOpsService = locator<InternalOpsService>();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://6w37rw51hj.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://7y9layzs7j.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<String>> getCustomUserToken(String mobileNo) async {
    try {
      final _body = {
        "mobileNumber": mobileNo,
      };
      final res = await APIService.instance.postData(_apiPaths.kCustomAuthToken,
          body: _body, isAuthTokenAvailable: false);
      return ApiResponse(model: res['token'], code: 200);
    } catch (e) {
      return ApiResponse.withError("Unable to signup using truecaller", 400);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> setNewUser(
      BaseUser baseUser, token, String state) async {
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
          BaseUser.fldUserPrefs: {"tn": 1, "al": 0},
          BaseUser.fldStateId: state,
          BaseUser.fldAppFlyerId: await _appsFlyerService.appFlyerId,
        }
      };

      final res = await APIService.instance.postData(_apiPaths.kAddNewUser,
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

  Future<ApiResponse<BaseUser>> getUserById({@required String id}) async {
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
            final _user = BaseUser.fromMap(res["data"], id);
            return ApiResponse<BaseUser>(model: _user, code: 200);
          } else
            return ApiResponse<BaseUser>(model: null, code: 200);
        } catch (e) {
          _internalOpsService.logFailure(
            id,
            FailType.UserDataCorrupted,
            {'message': "User data corrupted"},
          );
          return ApiResponse.withError("User data corrupted", 400);
        }
      });
    } catch (e) {
      logger.d(e.toString());
      return ApiResponse.withError("Unable to get user", 400);
    }
  }

  Future<ApiResponse> updateUserAppFlyer(BaseUser user, String token) async {
    try {
      final id = await _appsFlyerService.appFlyerId;

      if (user.appFlyerId == id) {
        return ApiResponse(code: 200);
      }

      final body = {
        'uid': user.uid,
        'appFlyerId': id,
      };

      final res = await APIService.instance.putData(
        _apiPaths.kUpdateUserAppflyer,
        body: body,
        token: 'Bearer $token',
      );

      // clear cache
      await _cacheService.invalidateByKey(CacheKeys.USER);

      return ApiResponse(code: 200);
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError("User not added to firestore", 400);
    }
  }

  Future<ApiResponse<UserFundWallet>> getFundBalance() async {
    try {
      final uid = userService.baseUser.uid;
      final token = await getBearerToken();

      final res = await APIService.instance.getData(
        ApiPath.getFundBalance(uid),
        token: token,
        cBaseUrl: _baseUrl,
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
      final uid = userService.baseUser.uid;
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
      logger.e('coin balance $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<UserTransaction>>> getWinningHistory(
      String userUid) async {
    List<UserTransaction> _userPrizeTransactions = [];
    try {
      final QuerySnapshot _querySnapshot =
          await _api.getUserPrizeTransactionDocuments(userUid);

      if (_querySnapshot.docs.length != 0) {
        _querySnapshot.docs.forEach((element) {
          _userPrizeTransactions.add(
            UserTransaction.fromMap(element.data(), element.id),
          );
        });
        logger.d(
            "User prize transaction successfully fetched: ${_userPrizeTransactions.first.toJson().toString()}");
      } else {
        logger.d("user prize transaction empty");
      }

      return ApiResponse(model: _userPrizeTransactions, code: 200);
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  Future<void> removeUserFCM(String userUid) async {
    try {
      await _api.deleteUserClientToken(userUid);
      logger.d("Token successfully removed from firestore, on user signout.");
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  Future<void> setNewDeviceId({
    String uid,
    String deviceId,
    String platform,
  }) async {
    try {
      final token = await getBearerToken();
      Map<String, dynamic> _body = {
        "uid": uid,
        "deviceId": deviceId,
        "platform": platform,
      };

      await APIService.instance.postData(
        ApiPath.kDeviceId,
        body: _body,
        cBaseUrl: _baseUrl,
        token: token,
      );

      logger.d("Device added");
    } catch (e) {
      logger.e(e);
    }
  }

  Future<ApiResponse<UserAugmontDetail>> getUserAugmontDetails() async {
    try {
      final token = await getBearerToken();
      final augmontRespone = await APIService.instance.getData(
        ApiPath.getAugmontDetail(
          this.userService.baseUser.uid,
        ),
        cBaseUrl: _baseUrl,
        token: token,
      );

      final augmont = UserAugmontDetail.fromMap(augmontRespone['data']);
      return ApiResponse<UserAugmontDetail>(model: augmont, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch augmont", 400);
    }
  }

  Future<ApiResponse<bool>> checkIfUserHasNewNotifications() async {
    try {
      final token = await getBearerToken();
      final latestNotificationsResponse = await APIService.instance.getData(
        ApiPath.getLatestNotification(this.userService.baseUser.uid),
        cBaseUrl: _baseUrl,
        token: token,
      );

      final List<AlertModel> notifications = AlertModel.helper.fromMapArray(
        latestNotificationsResponse["data"],
      );

      String latestNotifTime = await CacheManager.readCache(
          key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME);
      if (latestNotifTime != null) {
        int latestTimeInSeconds = int.tryParse(latestNotifTime);
        AlertModel latestAlert = notifications[0].createdTime.seconds >
                notifications[1].createdTime.seconds
            ? notifications[0]
            : notifications[1];
        if (latestAlert.createdTime.seconds > latestTimeInSeconds)
          return ApiResponse<bool>(model: true, code: 200);
        else
          return ApiResponse<bool>(model: false, code: 200);
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
    String lastDocId,
  ) async {
    try {
      final token = await getBearerToken();
      final userNotifications = await APIService.instance.getData(
        ApiPath.getNotifications(this.userService.baseUser.uid),
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
      logger.e(e);
      return ApiResponse.withError(
        "Unable to fetch user notifications",
        400,
      );
    }
  }

  Future<ApiResponse<bool>> updateUser({
    String uid,
    @required Map<String, dynamic> dMap,
  }) async {
    final token = await getBearerToken();
    try {
      await APIService.instance.putData(
        ApiPath.kGetUserById(uid),
        body: dMap,
        token: "Bearer $token",
        cBaseUrl: _baseUrl,
      );

      // clear cache
      await _cacheService.invalidateByKey(CacheKeys.USER);

      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(
        "Unable to update user",
        400,
      );
    }
  }

  Future<ApiResponse<bool>> updateFcmToken({
    @required String fcmToken,
  }) async {
    try {
      final token = await getBearerToken();
      await APIService.instance.putData(
        ApiPath.updateFcm,
        body: {
          "userId": userService.baseUser.uid,
          "token": fcmToken,
        },
        cBaseUrl: _baseUrl,
        token: "Bearer $token",
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

  Future<ApiResponse<bool>> updateUserWalkthroughCompletion() async {
    bool isGtRewarded = false;
    try {
      final String _bearer = await getBearerToken();
      final res = await APIService.instance.postData(
          ApiPath.kWalkthrough(userService.baseUser.uid),
          cBaseUrl: _baseUrl,
          token: _bearer);
      logger.d(res);
      final responseData = res['data'];
      logger.d(responseData);
      if (responseData["isGtRewarded"] != null && responseData["isGtRewarded"])
        isGtRewarded = true;
      if (responseData["gtId"] != null &&
          responseData["gtId"].toString().isNotEmpty)
        GoldenTicketService.goldenTicketId = responseData["gtId"];
      return ApiResponse(code: 200, model: isGtRewarded);
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(
          e.toString() ?? "Unable to create user account", 400);
    }
  }
}
