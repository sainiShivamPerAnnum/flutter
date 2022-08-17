import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class PrizeClaimCard extends StatelessWidget {
  final MyWinningsViewModel model;

  PrizeClaimCard({this.model});

  @override
  Widget build(BuildContext context) {
    String minWithdrawPrize = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.MIN_WITHDRAWABLE_PRIZE);
    String refUnlock = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT);
    int refUnlockAmt = BaseUtil.toInt(refUnlock);
    int minWithdrawPrizeAmt = BaseUtil.toInt(minWithdrawPrize);
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [UserServiceProperties.myUserFund],
        builder: (context, m, property) => Column(
              children: [
                (m.userFundWallet.isPrizeBalanceUnclaimed())
                    ? Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.padding24,
                            left: SizeConfig.pageHorizontalMargins,
                            right: SizeConfig.pageHorizontalMargins),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness16),
                          color: UiConstants.kAutopayAmountDeactiveTabColor,
                        ),
                        padding: EdgeInsets.only(
                          top: SizeConfig.padding16,
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total Cashback",
                                    style:
                                        TextStyles.body1.colour(Colors.white),
                                  ),
                                  Text(
                                    "₹ ${m.userFundWallet.unclaimedBalance ?? '-'}",
                                    style: TextStyles.rajdhaniB.bold
                                        .colour(UiConstants
                                            .kcashBackAmountTextColor)
                                        .copyWith(
                                            fontSize: SizeConfig.padding54),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding8),
                            if (m.userFundWallet.unclaimedBalance >=
                                    minWithdrawPrizeAmt &&
                                m.userFundWallet.augGoldPrinciple >=
                                    refUnlockAmt)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding16),
                                margin: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding6),
                                child: Row(
                                  children: [
                                    _isAmazonVoucherRedemptionAvailable()
                                        ? ClaimButton(
                                            color: Color(0xff11192B),
                                            image: Assets.amazonClaim,
                                            onTap: () =>
                                                model.showConfirmDialog(
                                                    PrizeClaimChoice
                                                        .AMZ_VOUCHER),
                                            text:
                                                "Redeem as Amazon Pay Gift Card",
                                          )
                                        : SizedBox(),
                                    _isAmazonVoucherRedemptionAvailable()
                                        ? SizedBox(width: SizeConfig.padding12)
                                        : SizedBox(),
                                    ClaimButton(
                                      color: UiConstants.tertiarySolid,
                                      image: Assets.augmontShare,
                                      onTap: () => model.showConfirmDialog(
                                          PrizeClaimChoice.GOLD_CREDIT),
                                      text: "Redeem as Digital Gold",
                                    )
                                  ],
                                ),
                              ),
                            if (m.userFundWallet.unclaimedBalance <
                                minWithdrawPrizeAmt)
                              Container(
                                margin:
                                    EdgeInsets.only(top: SizeConfig.padding6),
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.padding54,
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding32),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness16),
                                  color: Colors.white.withOpacity(0.07),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    "Winnings can be redeemed on reaching ₹$minWithdrawPrize",
                                    style:
                                        TextStyles.body3.colour(Colors.white),
                                  ),
                                ),
                              )
                            else if (m.userFundWallet.augGoldPrinciple <
                                refUnlockAmt)
                              Container(
                                margin:
                                    EdgeInsets.only(top: SizeConfig.padding6),
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.padding54,
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding32),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness16),
                                  color: Colors.white.withOpacity(0.07),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    "Savings of ₹$refUnlock required to redeem your winnings.",
                                    style:
                                        TextStyles.body3.colour(Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : SizedBox(height: SizeConfig.padding2),
              ],
            ));
  }

  bool _isAmazonVoucherRedemptionAvailable() {
    String option = BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.AMZ_VOUCHER_REDEMPTION) ??
        '1';
    int op = int.tryParse(option);
    return (op == null || op == 1);
  }
}

class ClaimButton extends StatelessWidget {
  final Color color;
  final String image;
  final String text;
  final Function onTap;

  ClaimButton({
    @required this.color,
    @required this.image,
    @required this.onTap,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPositiveBtn(
        onPressed: onTap,
        btnText: text ?? "Redeem for amazon pay",
        width: double.maxFinite,
      ),
    );
  }
}
