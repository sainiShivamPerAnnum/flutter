import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_history/referral_history_view.dart';
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
    String minWithdrawPrize = BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.MIN_WITHDRAWABLE_PRIZE);
    String refUnlock = BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT);
    int refUnlockAmt = BaseUtil.toInt(refUnlock);
    int minWithdrawPrizeAmt = BaseUtil.toInt(minWithdrawPrize);
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [UserServiceProperties.myUserFund],
        builder: (context, m, property) => Column(
              children: [
                if (m.userFundWallet.lockedPrizeBalance > 0)
                  InkWell(
                    onTap: () {
                      AppState.delegate.appState.currentAction = PageAction(
                        state: PageState.addWidget,
                        page: ReferralHistoryPageConfig,
                        widget: ReferralHistoryView(
                          onlyLocked: true,
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.pageHorizontalMargins,
                        right: SizeConfig.pageHorizontalMargins,
                        bottom: SizeConfig.padding24,
                      ),
                      //height: SizeConfig.screenWidth * 0.28,
                      decoration: BoxDecoration(
                        color: UiConstants.tertiaryLight,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness16),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding16,
                        vertical: SizeConfig.padding20,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                UiConstants.tertiarySolid.withOpacity(0.2),
                            radius: SizeConfig.screenWidth * 0.067,
                            child: Icon(
                              Icons.lock_outline,
                              size: SizeConfig.padding32,
                              color: UiConstants.tertiarySolid,
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
                                    "Locked Balance",
                                    style: TextStyles.body1.bold,
                                  ),
                                ),
                                SizedBox(height: SizeConfig.padding4),
                                Text(
                                  "Unlock these rewards once your friends make their first savings of atleast ₹$refUnlock",
                                  maxLines: 3,
                                  style: TextStyles.body3.colour(Colors.grey),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: SizeConfig.padding12),
                          Text(
                            "₹${m.userFundWallet.lockedPrizeBalance ?? '-'}",
                            style: TextStyles.body1.bold
                                .colour(UiConstants.tertiarySolid),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (m.userFundWallet.isPrizeBalanceUnclaimed())
                  Container(
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.padding24,
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
                                radius: SizeConfig.screenWidth * 0.067,
                                child: Icon(
                                  Icons.lock_open_sharp,
                                  size: SizeConfig.padding32,
                                  color: UiConstants.primaryColor,
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
                                        "Available Balance",
                                        style: TextStyles.body1.bold,
                                      ),
                                    ),
                                    SizedBox(height: SizeConfig.padding4),
                                    (m.userFundWallet.unclaimedBalance >= refUnlockAmt &&
                                        m.userFundWallet.augGoldPrinciple >= refUnlockAmt)?Text(
                                      "Redeem your rewards using any of the following options",
                                      maxLines: 2,
                                      style:
                                          TextStyles.body3.colour(Colors.grey),
                                    ):Container()
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
                                ClaimButton(
                                  color: Color(0xff11192B),
                                  image: Assets.amazonClaim,
                                  onTap: () => model.showConfirmDialog(
                                      PrizeClaimChoice.AMZ_VOUCHER),
                                  text: "Redeem as Amazon Pay Gift Card",
                                ),
                                SizedBox(width: SizeConfig.padding12),
                                ClaimButton(
                                  color: UiConstants.tertiarySolid,
                                  image: Assets.goldClaim,
                                  onTap: () => model.showConfirmDialog(
                                      PrizeClaimChoice.GOLD_CREDIT),
                                  text: "Redeem as Digital Gold",
                                ),
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
                        else if (m.userFundWallet.augGoldPrinciple < refUnlockAmt)
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
            children: [
              CircleAvatar(
                radius: SizeConfig.padding24,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Image.asset(
                  image ?? Assets.amazonClaim,
                ),
              ),
              SizedBox(width: SizeConfig.padding6),
              Expanded(
                child: Text(
                  text ?? "Redeem for amazon pay",
                  style: TextStyles.body3.colour(Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
