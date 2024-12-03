import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/rewards/rewardsUseHistory/rewards_transactions.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class PrizeClaimCard extends StatelessWidget {
  const PrizeClaimCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [UserServiceProperties.myUserFund],
      builder: (context, m, property) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
          ),
          child: RewardBalanceWidget(userService: m),
        );
      },
    );
  }
}

class RewardBalanceWidget extends StatelessWidget {
  const RewardBalanceWidget({required this.userService, super.key});

  final UserService? userService;

  @override
  Widget build(BuildContext context) {
    final minWithdrawPrize = locator<UserService>().baseUser!.minRedemptionAmt;
    return RewardRedeemWidget(
      m: userService,
      minWithdrawPrize: minWithdrawPrize,
    );
  }
}

class RewardRedeemWidget extends StatelessWidget {
  const RewardRedeemWidget({
    required this.m,
    required this.minWithdrawPrize,
    super.key,
    this.isWinView = false,
  });

  final UserService? m;
  final num minWithdrawPrize;
  final bool isWinView;

  @override
  Widget build(BuildContext context) {
    bool isEnabled =
        (m?.userFundWallet?.unclaimedBalance.toInt() ?? 0) >= minWithdrawPrize;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: UiConstants.gameCardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.roundness8),
              topRight: Radius.circular(SizeConfig.roundness8),
            ),
          ),
          padding: EdgeInsets.all(
            SizeConfig.padding14,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.padding6),
                      Row(
                        children: [
                          Text(
                            "Reward Balance",
                            style: TextStyles.sourceSans.body4,
                          ),
                        ],
                      ),
                      Text(
                        "${m?.userFundWallet?.unclaimedBalance.toInt() ?? '-'} coins",
                        style: TextStyles.rajdhaniB
                            .colour(UiConstants.kcashBackAmountTextColor)
                            .copyWith(fontSize: SizeConfig.title4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: isEnabled
                        ? () {
                            AppState.delegate!.parseRoute(Uri.parse("experts"));
                          }
                        : () => BaseUtil.showNegativeAlert(
                            "Not enough winnings",
                            "Winnings can only be redeemed after reaching ${minWithdrawPrize} coins"),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding8,
                        vertical: SizeConfig.padding6,
                      ),
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? UiConstants.kTextColor
                            : UiConstants.kTextColor.withOpacity(.4),
                        borderRadius: BorderRadius.circular(
                          SizeConfig.roundness5,
                        ),
                      ),
                      child: Text(
                        'Redeem Now',
                        style: TextStyles.sourceSansSB.body4.colour(
                          UiConstants.kTextColor4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.padding10),
              Divider(
                color: UiConstants.kTextColor5.withOpacity(.3),
              ),
              SizedBox(height: SizeConfig.padding10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total rewards won till date',
                        style: TextStyles.sourceSans.body4,
                      ),
                      Text(
                        "${m?.userFundWallet?.prizeLifetimeWin.toInt()} coins",
                        style: TextStyles.rajdhaniSB.body4.colour(
                          UiConstants.kcashBackAmountTextColor,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      AppState.delegate!.appState.currentAction = PageAction(
                        page: RewardsHistoryPageConfig,
                        state: PageState.addWidget,
                        widget: const RewardsTransactionsView(),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'View Balance',
                          style: TextStyles.sourceSansSB.body4,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: SizeConfig.body4,
                          color: UiConstants.kTextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding14,
            vertical: SizeConfig.padding12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeConfig.roundness8),
              bottomRight: Radius.circular(SizeConfig.roundness8),
            ),
            color:
                UiConstants.kModalSheetSecondaryBackgroundColor.withOpacity(.4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info,
                size: SizeConfig.body4,
                color: UiConstants.kTextColor,
              ),
              SizedBox(width: SizeConfig.padding8),
              Expanded(
                child: Text(
                  '1 coin is equivalent to 1 INR.',
                  maxLines: 2,
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor.withOpacity(.75)),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
