import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/current_winnings_info.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/news_component.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/refer_and_earn_card.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/scratch_card_info_strip.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/win_helpers.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/dev_rel.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class Win extends StatelessWidget {
  const Win({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S locale = locator<S>();
    return BaseView<WinViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.clear(),
      builder: (ctx, model, child) {
        return Builder(builder: (context) {
          if (model.state == ViewState.Busy) {
            return SizedBox(
              width: SizeConfig.screenWidth,
              child: const FullScreenLoader(),
            );
          }
          return Scaffold(
            backgroundColor: UiConstants.kBackgroundColor,
            appBar: FAppBar(
              title: "My Account",
              showHelpButton: true,
              type: FaqsType.yourAccount,
              showCoinBar: false,
              showAvatar: false,
              leadingPadding: false,
              action: Row(children: [NotificationButton()]),
            ),
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                // const Salutation(),
                // AccountInfoTiles(
                //   title: 'App Walkthrough',
                //   uri: "",
                //   onTap: () {
                //     locator<AnalyticsService>()
                //         .track(eventName: 'App Walkthrough');
                //     SpotLightController.instance.startQuickTour();
                //   },
                // ),
                AccountInfoTiles(title: locale.abMyProfile, uri: "/profile"),
                const AccountInfoTiles(title: "KYC Details", uri: "/kycVerify"),

                AccountInfoTiles(
                    title: locale.bankAccDetails, uri: "/bankDetails"),
                AccountInfoTiles(
                  title: 'Last Week on Fello',
                  uri: "",
                  onTap: () => model.showLastWeekSummary(),
                ),
                AccountInfoTiles(
                  title: 'Rate Us',
                  uri: "",
                  onTap: () => model.showRatingSheet(),
                ),
                AccountInfoTiles(
                  title: 'Report bug',
                  uri: "",
                  onTap: () => model.showFoundBugSheet(),
                ),
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
                // const ReferralLeaderboard(),
                //Fello News
                FelloNewsComponent(model: model),
                // DEV PURPOSE ONLY
                const CacheClearWidget(),
                SizedBox(
                  height: SizeConfig.padding10,
                ),

                // LottieBuilder.network(
                //     "https://d37gtxigg82zaw.cloudfront.net/scroll-animation.json"),

                // SizedBox(height: SizeConfig.navBarHeight),
              ],
            ),
          );
        });
      },
    );
  }
}
