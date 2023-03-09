import 'dart:developer';

import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CurrentWinningsInfo extends StatelessWidget {
  const CurrentWinningsInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log("BUILD: Current winnings main rebuilds");
    S locale = locator<S>();
    final referralService = locator<ReferralService>();
    return Consumer<UserService>(
      // properties: [UserServiceProperties.myUserFund],
      builder: (context, userservice, properties) {
        log("BUILD: Current winnings rebuilds");
        double currentWinning =
            userservice!.userFundWallet?.unclaimedBalance ?? 0;
        String currentAsset = referralService.getRedeemAsset(currentWinning);
        return GestureDetector(
          onTap: () => AppState.delegate!.parseRoute(Uri.parse('/myWinnings')),
          child: Container(
            padding: EdgeInsets.fromLTRB(SizeConfig.padding24,
                SizeConfig.padding12, SizeConfig.padding24, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.currentWinings,
                      style: TextStyles.rajdhaniSB
                          .copyWith(fontSize: SizeConfig.body0),
                      key: ValueKey(Constants.CURRENT_WINNINGS),
                    ),
                    Text(
                        '₹ ${(userservice.userFundWallet?.unclaimedBalance ?? 0).truncate()}',
                        style: TextStyles.title1.extraBold.colour(Colors.white),
                        key: ValueKey(Constants.CURRENT_WINNING_AMOUNT)),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    currentWinning >= referralService.minWithdrawPrizeAmt!
                        ? AppPositiveBtn(
                            height: SizeConfig.screenWidth! * 0.12,
                            btnText: locale.redeem,
                            onPressed: () {
                              referralService.showConfirmDialog(
                                  PrizeClaimChoice.GOLD_CREDIT);
                            },
                            width: SizeConfig.screenWidth! * 0.32)
                        : (userservice.userFundWallet?.unclaimedBalance ?? 0) >
                                0
                            ? Container(
                                width: SizeConfig.screenWidth! / 2.5,
                                child: RichText(
                                  maxLines: 3,
                                  softWrap: true,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: locale.winRedeemText,
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                      TextSpan(
                                        text: locale.digitalGoldText,
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                      TextSpan(
                                        text: locale.onReaching +
                                            " ₹${referralService.minWithdrawPrize}",
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor2),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                  ],
                ),
                if (userservice.userFundWallet != null)
                  Expanded(child: SvgPicture.asset(currentAsset)),
              ],
            ),
          ),
        );
      },
    );
  }
}
