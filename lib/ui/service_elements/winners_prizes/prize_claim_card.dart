import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
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
                if (m.userFundWallet.isPrizeBalanceUnclaimed())
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.padding24,
                        left: SizeConfig.pageHorizontalMargins,
                        right: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                      color: UiConstants.scaffoldColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding16,
                      vertical: SizeConfig.padding20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding6),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    UiConstants.primaryColor.withOpacity(0.2),
                                child: Image.asset(
                                  Assets.moneyIcon,
                                  width: SizeConfig.iconSize1,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.padding12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "My Active Winnings: ",
                                        style: TextStyles.body1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: SizeConfig.padding12),
                              Text(
                                "₹${m.userFundWallet.unclaimedBalance ?? '-'}",
                                style: TextStyles.body1.bold
                                    .colour(UiConstants.primaryColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding8),
                        if (m.userFundWallet.unclaimedBalance >= refUnlockAmt &&
                            m.userFundWallet.augGoldPrinciple >= refUnlockAmt)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding6),
                            child: Row(
                              children: [
                                _isAmazonVoucherRedemptionAvailable()
                                    ? ClaimButton(
                                        color: Color(0xff11192B),
                                        image: Assets.amazonClaim,
                                        onTap: () => model.showConfirmDialog(
                                            PrizeClaimChoice.AMZ_VOUCHER),
                                        text: "Redeem as Amazon Pay Gift Card",
                                      )
                                    : SizedBox(),
                                _isAmazonVoucherRedemptionAvailable()
                                    ? SizedBox(width: SizeConfig.padding12)
                                    : SizedBox(),
                                ClaimButton(
                                  color: UiConstants.tertiarySolid,
                                  image: Assets.goldClaim,
                                  onTap: () => model.showConfirmDialog(
                                      PrizeClaimChoice.GOLD_CREDIT),
                                  text: "Redeem as Digital Gold",
                                )
                              ],
                            ),
                          ),
                        if (m.userFundWallet.unclaimedBalance < 100)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding6),
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.padding54,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding32),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness16),
                              color: Colors.red.withOpacity(0.05),
                            ),
                            child: FittedBox(
                              child: Text(
                                "Winnings can be redeemed on reaching ₹$minWithdrawPrize",
                                style:
                                    TextStyles.body3.colour(Colors.redAccent),
                              ),
                            ),
                          )
                        else if (m.userFundWallet.augGoldPrinciple <
                            refUnlockAmt)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding6),
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.padding54,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding32),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness16),
                              color: UiConstants.tertiaryLight.withOpacity(0.5),
                            ),
                            child: FittedBox(
                              child: Text(
                                "You need to save a minimum of ₹$refUnlock to redeem your winnings.",
                                style:
                                    TextStyles.body3.colour(Colors.redAccent),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
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
      child: FelloButton(
        onPressed: onTap,
        activeButtonUI: Container(
          height: SizeConfig.screenWidth * 0.2,
          width: SizeConfig.screenWidth * 0.422,
          decoration: BoxDecoration(
            color: color ?? UiConstants.primaryColor,
            borderRadius: BorderRadius.circular(SizeConfig.padding20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding12,
            vertical: SizeConfig.padding16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: SizeConfig.padding24,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Image.asset(
                  image ?? Assets.amazonClaim,
                ),
              ),
              SizedBox(width: SizeConfig.padding12),
              Container(
                width: SizeConfig.screenWidth * 0.5,
                child: Text(
                  text ?? "Redeem for amazon pay",
                  style: TextStyles.body1.colour(Colors.white).bold,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
