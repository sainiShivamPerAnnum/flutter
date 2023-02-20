import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/current_winnings_info.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/news_component.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/refer_and_earn_card.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/scratch_card_info_strip.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/win_helpers.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/dev_rel.dart';
import 'package:felloapp/ui/service_elements/leaderboards/referral_leaderboard.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();
    return BaseView<WinViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.clear(),
      builder: (ctx, model, child) {
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
                          title: locale.abMyProfile, uri: "/profile"),
                      AccountInfoTiles(
                          title: locale.kycTitle, uri: "/kycVerify"),
                      AccountInfoTiles(
                          title: locale.bankAccDetails, uri: "/bankDetails"),
                      //Scratch Cards count and navigation
                      const ScratchCardsInfoStrip(),
                      //Current Winnings Information
                      const CurrentWinningsInfo(),
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
      },
    );
  }
}
