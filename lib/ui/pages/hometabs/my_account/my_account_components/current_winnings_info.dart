import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentWinningsInfo extends StatelessWidget {
  const CurrentWinningsInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minWithdrawPrize = locator<UserService>().baseUser!.minRedemptionAmt;
    return Consumer<UserService>(
      builder: (context, userservice, properties) {
        return GestureDetector(
          onTap: () => AppState.delegate!.parseRoute(Uri.parse('/myWinnings')),
          child: RewardRedeemWidget(
            m: userservice,
            minWithdrawPrize: minWithdrawPrize,
            isWinView: true,
          ),
        );
      },
    );
  }
}

// Container(
//             padding: EdgeInsets.fromLTRB(SizeConfig.padding24,
//                 SizeConfig.padding12, SizeConfig.padding24, 0.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Fello Rewards",
//                       style: TextStyles.rajdhaniSB
//                           .copyWith(fontSize: SizeConfig.body0),
//                       key: const ValueKey(Constants.CURRENT_WINNINGS),
//                     ),
//                     Text(
//                         '₹ ${(userservice.userFundWallet?.unclaimedBalance ?? 0).truncate()}',
//                         style: TextStyles.title1.extraBold.colour(Colors.white),
//                         key: const ValueKey(Constants.CURRENT_WINNING_AMOUNT)),
//                     SizedBox(
//                       height: SizeConfig.padding16,
//                     ),
//                     currentWinning >=
//                             (referralService.minWithdrawPrizeAmt ?? 200)
//                         ? AppPositiveBtn(
//                             height: SizeConfig.screenWidth! * 0.12,
//                             btnText: locale.redeem,
//                             onPressed: () {
//                               referralService.showConfirmDialog(
//                                   PrizeClaimChoice.GOLD_CREDIT);
//                             },
//                             width: SizeConfig.screenWidth! * 0.32)
//                         : (userservice.userFundWallet?.unclaimedBalance ?? 0) >
//                                 0
//                             ? SizedBox(
//                                 width: SizeConfig.screenWidth! / 2.5,
//                                 child: RichText(
//                                   maxLines: 3,
//                                   softWrap: true,
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: locale.winRedeemText,
//                                         style: TextStyles.sourceSans.body3
//                                             .colour(UiConstants.kTextColor2),
//                                       ),
//                                       TextSpan(
//                                         text: locale.digitalGoldText,
//                                         style: TextStyles.sourceSans.body3
//                                             .colour(UiConstants.kTextColor2),
//                                       ),
//                                       TextSpan(
//                                         text: locale.onReaching +
//                                             " ₹${referralService.minWithdrawPrize}",
//                                         style: TextStyles.sourceSans.body3
//                                             .colour(UiConstants.kTextColor2),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             : const SizedBox(),
//                   ],
//                 ),
//                 if (userservice.userFundWallet != null)
//                   Expanded(child: SvgPicture.asset(currentAsset)),
//               ],
//             ),
//           ),
