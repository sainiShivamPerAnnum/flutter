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
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.myUserFund],
      builder: (context, m, property) => m.userFundWallet.unclaimedBalance == 0
          ? Container()
          : Container(
              margin: EdgeInsets.only(
                  bottom: SizeConfig.padding24,
                  left: SizeConfig.pageHorizontalMargins,
                  right: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                color: UiConstants.scaffoldColor,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding20,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: SizeConfig.padding6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("Unclaimed Balance:",
                                style: TextStyles.body1.light),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "₹ ${m.userFundWallet.unclaimedBalance} ",
                                style: TextStyles.body1.bold
                                    .colour(UiConstants.primaryColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: SizeConfig.padding6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("Locked Balance:",
                                style: TextStyles.body1.light),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "₹ ${m.userFundWallet.lockedPrizeBalance} ",
                                style: TextStyles.body1.bold
                                    .colour(UiConstants.primaryColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: SizeConfig.padding6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text("Unlocked Balance:",
                                style: TextStyles.body1.light),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "₹ ${m.userFundWallet.prizeBalance} ",
                                style: TextStyles.body1.bold
                                    .colour(UiConstants.primaryColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  if (m.userFundWallet.unclaimedBalance >= 100)
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding6),
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
                      margin:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding6),
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
                          "Winnings can be redeemed after reaching ₹100",
                          style: TextStyles.body3
                              .colour(UiConstants.tertiarySolid),
                        ),
                      ),
                    ),
                ],
              ),
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
