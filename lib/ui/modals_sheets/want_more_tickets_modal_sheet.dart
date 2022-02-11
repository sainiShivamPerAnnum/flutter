import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WantMoreTicketsModalSheet extends StatelessWidget {
  WantMoreTicketsModalSheet({this.isInsufficientBalance = false});
  final isInsufficientBalance;
  final _analyticsService = locator<AnalyticsService>();

  final referralBonus =
      BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.REFERRAL_BONUS);
  final referralTicketBonus = BaseRemoteConfig.remoteConfig
      .getString(BaseRemoteConfig.REFERRAL_TICKET_BONUS);
  final referralFlcBonus = BaseRemoteConfig.remoteConfig
      .getString(BaseRemoteConfig.REFERRAL_FLC_BONUS);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AppState.backButtonDispatcher.didPopRoute();
        return Future.value(true);
      },
      child: Wrap(
        children: [
          Transform.translate(
            offset: Offset(0, 1),
            child: SvgPicture.asset(
              Assets.clip,
              width: SizeConfig.screenWidth,
            ),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.bottomCenter,
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.only(
              left: SizeConfig.pageHorizontalMargins,
              right: SizeConfig.pageHorizontalMargins,
            ),
            child: Column(
              children: [
                (isInsufficientBalance)
                    ? SizedBox(height: SizeConfig.padding16)
                    : SizedBox(),
                (isInsufficientBalance)
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(vertical: SizeConfig.padding6),
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.padding32,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding32),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12),
                          color: Colors.red.withOpacity(0.05),
                        ),
                        child: Center(
                          child: Text(
                            "You don't have enough Fello tokens",
                            style: TextStyles.body2.colour(Colors.redAccent),
                          ),
                        ),
                      )
                    : SizedBox(),
                (isInsufficientBalance)
                    ? SizedBox(height: SizeConfig.padding16)
                    : SizedBox(),
                FelloTile(
                  leadingAsset: Assets.wmtsaveMoney,
                  title: "Save More Money",
                  subtitle: "Get 1 token for every Rupee saved",
                  trailingIcon: Icons.arrow_forward_ios_rounded,
                  onTap: () {
                    _analyticsService.track(
                        eventName: AnalyticsEvents.earnMoreSaveMoney);
                    AppState.backButtonDispatcher.didPopRoute();
                    Future.delayed(Duration.zero, () {
                      AppState.delegate.appState.setCurrentTabIndex = 0;
                    });
                  },
                ),
                SizedBox(height: SizeConfig.padding16),
                FelloTile(
                  leadingAsset: Assets.wmtShare,
                  title: "Refer your friends",
                  subtitle: "Earn Golden Tickets for every referral",
                  trailingIcon: Icons.arrow_forward_ios_rounded,
                  onTap: () {
                    _analyticsService.track(
                        eventName: AnalyticsEvents.earnMoreRefer);
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.delegate.appState.currentAction = PageAction(
                        state: PageState.addPage,
                        page: ReferralDetailsPageConfig);
                  },
                ),
                SizedBox(height: SizeConfig.padding24),

                // FelloTile(
                //   leadingIcon: Icons.account_balance_wallet,
                //   title: "Set up SIP",
                //   subtitle: "Earn tickets on the go",
                //   trailingIcon: Icons.arrow_forward_ios_rounded,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
