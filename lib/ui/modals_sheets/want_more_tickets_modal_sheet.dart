import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/service_elements/user_coin_service/coin_balance_text.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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
    if (isInsufficientBalance)
      _analyticsService.track(eventName: AnalyticsEvents.flcTokensExhasuted);

    return WillPopScope(
      onWillPop: () {
        AppState.backButtonDispatcher.didPopRoute();
        return Future.value(true);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.padding24,
                  bottom: SizeConfig.padding12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  color: UiConstants.kBackgroundColor3,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  vertical: SizeConfig.padding12,
                ),
                child: Row(children: [
                  Text("Current Tokens:", style: TextStyles.rajdhani.body1),
                  Spacer(),
                  SvgPicture.asset(
                    'assets/temp/Tokens.svg',
                    width: SizeConfig.padding26,
                    height: SizeConfig.padding26,
                  ),
                  SizedBox(
                    width: SizeConfig.padding6,
                  ),
                  CoinBalanceTextSE(
                    style: TextStyles.rajdhaniB.title3,
                  )
                ]),
              ),
              isInsufficientBalance
                  ? Container(
                      margin: EdgeInsets.only(
                        // top: SizeConfig.padding6,
                        bottom: SizeConfig.padding12,
                      ),
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding12,
                          horizontal: SizeConfig.padding32),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                        // color: Colors.red.withOpacity(0.05),
                      ),
                      child: Text(
                        "You ran out of Fello tokens, here are some ways to get back on the track:",
                        style: TextStyles.body2.colour(Colors.redAccent).italic,
                        textAlign: TextAlign.start,
                      ),
                    )
                  : SizedBox(height: SizeConfig.padding12),
              FelloTile(
                leadingAsset: Assets.wmtsaveMoney,
                title: "Save More Money",
                subtitle: "Get 1 token for every Rupee saved",
                trailingIcon: Icons.arrow_forward_ios_rounded,
                onTap: () {
                  _analyticsService.track(
                      eventName: AnalyticsEvents.earnMoreSaveMoney);
                  while (AppState.screenStack.length > 1)
                    AppState.backButtonDispatcher.didPopRoute();
                  AppState.delegate.appState.setCurrentTabIndex = 2;
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
              SizedBox(height: SizeConfig.padding16),
              FelloTile(
                leadingAsset: Assets.repeat,
                title: "Set up Auto SIP",
                subtitle: "Set up Auto SIP & Earn 100 tokens ",
                trailingIcon: Icons.arrow_forward_ios_rounded,
                onTap: () {
                  _analyticsService.track(
                      eventName: AnalyticsEvents.earnMoreRefer);
                  AppState.backButtonDispatcher.didPopRoute();
                  AppState.delegate.parseRoute(Uri.parse("save"));
                },
              ),
              SizedBox(height: SizeConfig.padding24),
            ]),
          ),

          // FelloTile(
          //   leadingIcon: Icons.account_balance_wallet,
          //   title: "Set up SIP",
          //   subtitle: "Earn tickets on the go",
          //   trailingIcon: Icons.arrow_forward_ios_rounded,
          // ),
        ],
      ),
    );
  }
}
