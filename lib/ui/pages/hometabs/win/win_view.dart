import 'package:felloapp/core/service/analytics/analytics_service.dart';
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
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
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
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const Salutation(),
              AccountInfoTiles(
                title: 'App Walkthrough',
                uri: "",
                onTap: () {
                  locator<AnalyticsService>()
                      .track(eventName: 'App Walkthrough');
                  SpotLightController.instance.startQuickTour();
                },
              ),
              AccountInfoTiles(title: locale.abMyProfile, uri: "/profile"),
              AccountInfoTiles(title: locale.kycTitle, uri: "/kycVerify"),

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
          );
        });
      },
    );
  }
}
