import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
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
    String minWithdrawPrize =
        AppConfig.getValue(AppConfigKey.min_withdrawable_prize).toString();
    int minWithdrawPrizeAmt = BaseUtil.toInt(minWithdrawPrize);
    bool showBottomInfo =
        (userService?.userFundWallet?.prizeLifetimeWin.toInt() ?? 0) >
                minWithdrawPrizeAmt &&
            userService?.userFundWallet?.processingRedemptionBalance == 0;
    return Container(
      // height: showBottomInfo ? SizeConfig.screenHeight! * 0.32 : null,
      decoration: BoxDecoration(
        borderRadius: showBottomInfo
            ? null
            : BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.roundness40),
                bottomRight: Radius.circular(SizeConfig.roundness40)),
        color: showBottomInfo ? const Color(0xffF4EDD9) : null,
      ),
      child: Column(
        children: [
          RewardRedeemWidget(
              m: userService, minWithdrawPrize: minWithdrawPrize),
          if (showBottomInfo)
            Container(
              // margin: EdgeInsets.only(top: SizeConfig.padding16),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  vertical: SizeConfig.padding12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total rewards won on Fello",
                    style: TextStyles.sourceSansSB.body3.colour(Colors.black),
                  ),
                  Text(
                    "₹${userService?.userFundWallet?.prizeLifetimeWin.toInt()}",
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  )
                ],
              ),
            ),
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
  final String minWithdrawPrize;
  final bool isWinView;

  @override
  Widget build(BuildContext context) {
    var referralService = locator<ReferralService>();
    int minWithdrawPrizeAmt = BaseUtil.toInt(minWithdrawPrize);
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
          else if ((m?.userFundWallet?.unclaimedBalance ?? 0) <
              minWithdrawPrizeAmt)
            Container(
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: FittedBox(
                child: Text(
                  "Reward Balance can be redeemed on reaching ₹$minWithdrawPrize",
                  style: TextStyles.rajdhaniSB.body3
                      .colour(Colors.white.withOpacity(0.6)),
                ),
              ),
            )
          else if ((m?.userFundWallet?.unclaimedBalance ?? 0) >=
              minWithdrawPrizeAmt)
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
