import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:app_set_id/app_set_id.dart';
import 'package:felloapp/core/repository/analytics_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/current_winnings_info.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/news_component.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/refer_and_earn_card.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/scratch_card_info_strip.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/win_helpers.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/dev_rel.dart';
import 'package:felloapp/ui/service_elements/leaderboards/referral_leaderboard.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:showcaseview/showcaseview.dart';

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();
    return BaseView<WinViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.clear(),
      builder: (ctx, model, child) {
        return Builder(builder: (context) {
          return Container(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.fToolBarHeight),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Salutation(),
                        AccountInfoTiles(
                          title: 'App Walkthrough',
                          uri: "",
                          onTap: () {
                            sendInstallInformation();
                            locator<AnalyticsService>()
                                .track(eventName: 'App Walkthrough');
                            // SpotLightController.instance.startQuickTour();
                          },
                        ),
                        AccountInfoTiles(
                            title: locale.abMyProfile, uri: "/profile"),
                        AccountInfoTiles(
                            title: locale.kycTitle, uri: "/kycVerify"),

                        AccountInfoTiles(
                            title: locale.bankAccDetails, uri: "/bankDetails"),
                        //Scratch Cards count and navigation
                        const ScratchCardsInfoStrip(),
                        //Current Winnings Information
                        Showcase(
                          key: ShowCaseKeys.CurrentWinnings,
                          description:
                              'Your winnings from scratch cards and coupons show here. Redeem your winnings as Digital Gold when you reach ₹200',
                          child: const CurrentWinningsInfo(),
                        ),
                        //Refer and Earn
                        const ReferEarnCard(),
                        // Referral Leaderboard
                        const ReferralLeaderboard(),
                        //Fello News
                        FelloNewsComponent(model: model),
                        // DEV PURPOSE ONLY
                        const CacheClearWidget(),
                        SizedBox(
                          height: SizeConfig.padding10,
                        ),

                        LottieBuilder.network(
                            "https://d37gtxigg82zaw.cloudfront.net/scroll-animation.json"),

                        SizedBox(height: SizeConfig.navBarHeight),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void sendInstallInformation() async {
    final _internalOpsService = locator<InternalOpsService>();
    final AnalyticsRepository? _analyticsRepo = locator<AnalyticsRepository>();
    final UserService userService = locator<UserService>();
    String? _appSetId;
    String? _androidId;
    String? _advertisingId;
    String? _osVersion;
    String? installReferrerData;
    const BASE_CHANNEL = 'methodChannel/deviceData';
    final platform = MethodChannel(BASE_CHANNEL);
    try {
      _appSetId = await AppSetId().getIdentifier();
      print('AppSetId: Package found an appropriate ID value: $_appSetId');
    } catch (e) {
      print('AppSetId: Package failed to set an appropriate ID value');
    }

    if (Platform.isAndroid) {
      try {
        _androidId = await platform.invokeMethod('getAndroidId');
        print('AndroidId: Service found an Android Id: $_androidId');
      } catch (e) {
        print('AndroidId: Service failed to find a Android Id');
      }
    }

    try {
      _advertisingId = await AdvertisingId.id(true);
      print('AdvertisingId: Service found an Advertising Id: $_advertisingId');
    } catch (e) {
      print('AdvertisingId: Service failed to find a Advertising Id');
    }

    try {
      if (!_internalOpsService!.isDeviceInfoInitiated)
        await _internalOpsService!.initDeviceInfo();
      _osVersion = _internalOpsService!.osVersion;
    } catch (e) {
      print('DeviceData: Service failed to find a Device Data');
    }

    try {
      const _channel = MethodChannel('my_plugin');
      installReferrerData = await _channel.invokeMethod('getInstallReferrer');

      //cleanup data
      RegExp nullPattern = RegExp(r'null');
      installReferrerData = installReferrerData!.replaceAll(nullPattern, '');
    } catch (e) {
      print('InstallReferrer: Service failed to find a Install Referrer Data');
    }

    print('Received the following information: {InstallReferrerData: $installReferrerData,' +
        'AppSetId: $_appSetId, AndroidId: $_androidId, AdvertisingId: $_advertisingId, OSVersion: $_osVersion}');

    final ApiResponse response = await _analyticsRepo!.setInstallInfo(
        userService.baseUser!,
        installReferrerData,
        _appSetId,
        _androidId,
        _osVersion,
        _advertisingId);
    print('Data sent to API with the following response: ${response.model}');
  }
}
