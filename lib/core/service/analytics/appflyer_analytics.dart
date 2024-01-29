import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

class AppFlyerAnalytics extends BaseAnalyticsService {
  final CustomLogger _logger = locator<CustomLogger>();
  final _cacheService = CacheService();

  late AppsflyerSdk _appsflyerSdk;
  Future<String?>? _appFlyerId;
  BaseUser? _baseUser;

  Future<String?>? get appFlyerId => _appFlyerId;

  @override
  Future<void> login({bool? isOnBoarded, BaseUser? baseUser}) async {
    _baseUser = baseUser;
    _appsflyerSdk.setCustomerUserId(baseUser!.uid!);
  }

  AppFlyerAnalytics() {
    _appFlyerId = init();
  }

  @override
  void signOut() {}

  @override
  void track({String? eventName, Map<String, dynamic>? properties}) {
    try {
      _appsflyerSdk.logEvent(eventName!, properties ?? {});
    } catch (e) {
      String error = e as String ?? "Unable to track event: $eventName";
      _logger.e(error);
    }
  }

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {
    try {
      _logger.d('analytics : $screen');
    } catch (e) {
      String error = e as String ?? "Unable to track screen event: $screen";
      _logger.e(error);
    }
  }

  Future<String?> init() async {
    String? id = '';

    try {
      AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
        afDevKey: AnalyticsService.appFlierKey,
        appId: Platform.isIOS ? '1558445254' : 'in.fello.felloapp',
        showDebug: FlavorConfig.isDevelopment(),
        disableAdvertisingIdentifier: false,
        timeToWaitForATTUserAuthorization: 0,
      );

      _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
      _appsflyerSdk.setAppInviteOneLinkID('uxu0', (res) {
        _logger.d("appsflyer setAppInviteOneLinkID callback:" + res.toString());
      });
      // _appsflyerSdk.setOneLinkCustomDomain([_brandedDomain]);

      _appsflyerSdk.onDeepLinking((DeepLinkResult result) {
        _logger.d('appflyer deeplink $result');
      });

      _appsflyerSdk.onInstallConversionData((res) {
        _logger.d('appflyer onInstallConversionData $res');
        if (res['status'] == 'success') {
          BaseUtil.referrerUserId = res['payload']['af_referrer_customer_id'];
        }
      });

      await _appsflyerSdk.initSdk(
        registerOnDeepLinkingCallback: true,
        registerConversionDataCallback: true,
      );

      id = await (_appsflyerSdk.getAppsFlyerUID());
      _logger.d('appflyer initialized');
    } catch (e) {
      _logger.e('appflyer $e');
    }

    return id;
  }

// TTL for link generated is 31 days, so we can cache this link for 31 days.
  Future<dynamic> inviteLink() async {
    _logger.d('appflyer get invite link');
    final cache = await _cacheService.getData(CacheKeys.APP_FLYER_LINK);
    if (cache != null) {
      _logger.d('cache $cache');
      return json.decode(cache.data!);
    }

    final inviteLinkParams = AppsFlyerInviteLinkParams(
      channel: 'User_invite',
      campaign: 'Referral',
      referrerName: _baseUser!.name,
      customerID: _baseUser!.uid,
      // brandDomain: _brandedDomain,
    );

    final Completer<dynamic> completer = Completer();
    _appsflyerSdk.generateInviteLink(inviteLinkParams, (success) async {
      _logger.d('appflyer invite link $success');
      await _cacheService.writeMap(
        CacheKeys.APP_FLYER_LINK,
        30 * 24 * 60,
        success,
      );
      completer.complete(success);
    }, (error) {
      _logger.d('appflyer invite link $error');
      completer.completeError(error);
    });

    return completer.future;
  }
}

// adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://fello.onelink.me/uxu0/g96992k5"
