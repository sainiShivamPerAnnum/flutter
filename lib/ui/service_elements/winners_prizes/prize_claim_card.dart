import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class PrizeClaimCard extends StatelessWidget {
  const PrizeClaimCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [UserServiceProperties.myUserFund],
      builder: (context, m, property) {
        return RewardBalanceWidget(userService: m);
      },
    );
  }
}

class RewardBalanceWidget extends StatelessWidget {
  const RewardBalanceWidget({required this.userService, super.key});

  final UserService? userService;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    final minWithdrawPrize = locator<UserService>().baseUser!.minRedemptionAmt;
    final allScratchCards = locator<ScratchCardService>().allScratchCards;
    bool showBottomInfo = allScratchCards.isNotEmpty;
    return Container(
      decoration: const BoxDecoration(
        color: UiConstants.kSnackBarBgColor,
      ),
      child: Column(
        children: [
          RewardRedeemWidget(
              m: userService, minWithdrawPrize: minWithdrawPrize),
          if (showBottomInfo) ...[
            Container(
              // margin: EdgeInsets.only(top: SizeConfig.padding16),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  vertical: SizeConfig.padding12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.totalRewardsTilldate,
                    style: TextStyles.sourceSansSB.body3.colour(Colors.black),
                  ),
                  Text(
                    "₹${userService?.userFundWallet?.prizeLifetimeWin.toInt()}",
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  )
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  vertical: SizeConfig.padding12),
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.cvtar6,
                        width: SizeConfig.iconSize5,
                        height: SizeConfig.iconSize5,
                      ),
                      SizedBox(
                        width: SizeConfig.padding10,
                      ),
                      Text(
                        'Manvendra S. Rathore',
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kTextColor4),
                      )
                    ],
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text.rich(TextSpan(
                          text: locale.earned,
                          style: TextStyles.sourceSans.body2
                              .colour(UiConstants.kTextColor4),
                          children: [
                            TextSpan(
                              text: "₹27,821",
                              style: TextStyles.sourceSansSB.body2
                                  .colour(UiConstants.kGoldProPrimaryDark2),
                            )
                          ])),
                      Text(
                        locale.rewardsWithFello,
                        style: TextStyles.sourceSans.body2
                            .colour(UiConstants.kTextColor4),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
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
    var referralService = locator<ReferralService>();
    int minWithdrawPrizeAmt = minWithdrawPrize.toInt();
    String currentAsset = referralService
        .getRedeemAsset(m?.userFundWallet?.unclaimedBalance.toDouble() ?? 0.0);
    bool isEnabled = (m?.userFundWallet?.unclaimedBalance.toInt() ?? 0) >=
        minWithdrawPrizeAmt;

    return Container(
      width: SizeConfig.screenWidth,
      decoration: isWinView
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(SizeConfig.roundness40),
                  bottomRight: Radius.circular(SizeConfig.roundness40)),
              color: UiConstants.kTambolaMidTextColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  // Adjust shadow color and opacity
                  offset: const Offset(0, 4),
                  // Adjust shadow offset
                  blurRadius: 6, // Adjust shadow blur radius
                ),
              ],
            ),
      padding: EdgeInsets.only(
        top: SizeConfig.padding20,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (m?.userFundWallet != null)
                  SvgPicture.asset(
                    currentAsset,
                    height: SizeConfig.padding90 + SizeConfig.padding46,
                  ),
                SizedBox(width: SizeConfig.padding32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.padding6),
                    Row(
                      children: [
                        Text(
                          "Reward Balance",
                          style: TextStyles.sourceSans.body2,
                        ),
                        SizedBox(width: SizeConfig.padding4),
                        if (!isEnabled)
                          const Icon(
                            Icons.lock,
                            size: 16,
                            weight: 700,
                            grade: 200,
                            opticalSize: 48,
                            color: Colors.white,
                          )
                      ],
                    ),
                    Text(
                      "₹ ${m?.userFundWallet?.unclaimedBalance.toInt() ?? '-'}",
                      style: TextStyles.rajdhaniB
                          .colour(UiConstants.kcashBackAmountTextColor)
                          .copyWith(fontSize: SizeConfig.padding40),
                      textAlign: TextAlign.center,
                    ),
                    MaterialButton(
                      height: SizeConfig.padding34,
                      minWidth: SizeConfig.padding90,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.roundness5,
                        ),
                      ),
                      color: isEnabled
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      onPressed: () {
                        if (isEnabled) {
                          referralService
                              .showConfirmDialog(PrizeClaimChoice.GOLD_CREDIT);
                        } else {
                          BaseUtil.showNegativeAlert("Not enough winnings",
                              "Winnings can only be redeemed after reaching ₹${referralService.minWithdrawPrizeAmt}");
                        }
                      },
                      child: Text(
                        'REDEEM',
                        style: TextStyles.rajdhaniB.body3.colour(Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding10),
          if (m?.userFundWallet?.processingRedemptionBalance != 0)
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.padding54,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: Center(
                child: Text(
                  "Processing ₹${m?.userFundWallet?.processingRedemptionBalance} to Digital Gold...",
                  style: TextStyles.rajdhaniSB.body3
                      .colour(Colors.white.withOpacity(0.8)),
                ),
              ),
            )
          else
            Container(
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Redeem your rewards to ",
                    style: TextStyles.rajdhaniSB.body3
                        .colour(Colors.white.withOpacity(0.8)),
                  ),
                  SvgPicture.asset('assets/svg/digital_gold.svg',
                      height: SizeConfig.padding40,
                      width: SizeConfig.padding40),
                  Text(
                    "Digital Gold",
                    style: TextStyles.rajdhaniB.body3
                        .colour(Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          SizedBox(height: SizeConfig.padding24),
        ],
      ),
    );
  }
}

class ClaimButton extends StatelessWidget {
  final Color color;
  final String image;
  final String text;
  final Function onTap;

  const ClaimButton({
    required this.color,
    required this.image,
    required this.onTap,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.padding16),
        child: AppPositiveBtn(
          onPressed: onTap as void Function(),
          btnText: text ?? locale.reedomAmznPay,
          width: double.maxFinite,
        ),
      ),
    );
  }
}
