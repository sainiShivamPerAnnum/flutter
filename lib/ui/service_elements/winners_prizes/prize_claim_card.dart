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

  // final WinViewModel model;
  // PrizeClaimCard({this.model});

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    String minWithdrawPrize =
        AppConfig.getValue(AppConfigKey.min_withdrawable_prize).toString();
    String refUnlock =
        AppConfig.getValue(AppConfigKey.unlock_referral_amt).toString();
    int refUnlockAmt = BaseUtil.toInt(refUnlock);
    int minWithdrawPrizeAmt = BaseUtil.toInt(minWithdrawPrize);
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: const [UserServiceProperties.myUserFund],
        builder: (context, m, property) {
          return Column(
            children: [
              if (m?.userFundWallet?.isPrizeBalanceUnclaimed() ?? false)
                RewardBalanceWidget(
                    minWithdrawPrizeAmt: minWithdrawPrizeAmt,
                    minWithdrawPrize: minWithdrawPrize,
                    m: m)
              else
                SizedBox(height: SizeConfig.padding2),
            ],
          );
        });
  }
}

class RewardBalanceWidget extends StatelessWidget {
  const RewardBalanceWidget(
      {super.key,
      required this.minWithdrawPrizeAmt,
      required this.minWithdrawPrize,
      required this.m});

  final int minWithdrawPrizeAmt;
  final String minWithdrawPrize;
  final UserService? m;

  @override
  Widget build(BuildContext context) {
    String currentAsset = locator<ReferralService>()
        .getRedeemAsset(m?.userFundWallet?.unclaimedBalance.toDouble() ?? 0.0);
    bool isEnabled = (m?.userFundWallet?.unclaimedBalance.toInt() ?? 0) >=
        minWithdrawPrizeAmt;
    bool showBottomInfo = (m?.userFundWallet?.prizeLifetimeWin.toInt() ?? 0) >
        minWithdrawPrizeAmt;
    return Container(
      height: showBottomInfo ? SizeConfig.screenHeight! * 0.316 : null,
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
          Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(SizeConfig.roundness40),
                  bottomRight: Radius.circular(SizeConfig.roundness40)),
              color: UiConstants.kTambolaMidTextColor,
            ),
            padding: EdgeInsets.only(
              top: SizeConfig.padding20,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  // margin: EdgeInsets.symmetric(
                  //     vertical: SizeConfig.padding6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (m?.userFundWallet != null)
                        SvgPicture.asset(
                          currentAsset,
                          height: SizeConfig.padding90 + SizeConfig.padding40,
                          // width: SizeConfig.padding90 +
                          //     SizeConfig.padding24,
                        ),
                      SizedBox(width: SizeConfig.padding64),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: SizeConfig.padding10),
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
                                .copyWith(fontSize: SizeConfig.padding44),
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
                              isEnabled
                                  ? locator<ReferralService>()
                                      .showConfirmDialog(
                                          PrizeClaimChoice.GOLD_CREDIT)
                                  : null;
                            },
                            child: Text(
                              'REDEEM',
                              style: TextStyles.rajdhaniB.body3
                                  .colour(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.padding8),
                // if (m.userFundWallet.unclaimedBalance >=
                //         minWithdrawPrizeAmt &&
                //     m.userFundWallet.augGoldPrinciple >=
                //         refUnlockAmt)
                //   Container(
                //     padding: EdgeInsets.symmetric(
                //         horizontal: SizeConfig.padding16),
                //     margin: EdgeInsets.symmetric(
                //         vertical: SizeConfig.padding6),
                //     child: Row(
                //       children: [
                //         _isAmazonVoucherRedemptionAvailable()
                //             ? ClaimButton(
                //                 color: Color(0xff11192B),
                //                 image: Assets.amazonClaim,
                //                 onTap: () =>
                //                     model.showConfirmDialog(
                //                         PrizeClaimChoice
                //                             .AMZ_VOUCHER),
                //                 text:
                //                     "Redeem as Amazon Pay Gift Card",
                //               )
                //             : SizedBox(),
                //         _isAmazonVoucherRedemptionAvailable()
                //             ? SizedBox(width: SizeConfig.padding12)
                //             : SizedBox(),
                //         ClaimButton(
                //           color: UiConstants.tertiarySolid,
                //           image: Assets.augmontShare,
                //           onTap: () => model.showConfirmDialog(
                //               PrizeClaimChoice.GOLD_CREDIT),
                //           text: "Redeem as Digital Gold",
                //         )
                //       ],
                //     ),
                //   ),
                if ((m?.userFundWallet?.unclaimedBalance ?? 0) <
                    minWithdrawPrizeAmt)
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.padding6),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.padding54,
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(
                    //       SizeConfig.roundness16),
                    //   color: Colors.white.withOpacity(0.07),
                    // ),
                    child: FittedBox(
                      child: Text(
                        // locale.winningsRedeem(minWithdrawPrize),

                        "Reward Balance can be redeemed on reaching ₹${minWithdrawPrize}",
                        style: TextStyles.rajdhaniSB.body3
                            .colour(Colors.white.withOpacity(0.8)),
                      ),
                    ),
                  )
                else if ((m?.userFundWallet?.unclaimedBalance ?? 0) >=
                    minWithdrawPrizeAmt)
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.padding6),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.padding54,
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
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

                // SizedBox(height: SizeConfig.padding8),
              ],
            ),
          ),
          if (showBottomInfo)
            Container(
              margin: EdgeInsets.only(top: SizeConfig.padding16),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total rewards won on Fello -",
                    style: TextStyles.sourceSans.body3.colour(Colors.black),
                  ),
                  Text(
                    "₹${m?.userFundWallet?.prizeLifetimeWin.toInt()}",
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

class ClaimButton extends StatelessWidget {
  final Color color;
  final String image;
  final String text;
  final Function onTap;

  ClaimButton({
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
