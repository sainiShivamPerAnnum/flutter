import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SharePriceScreen extends StatelessWidget {
  SharePriceScreen({
    Key key,
    @required this.imageKey,
    @required this.dpUrl,
    @required this.choice,
    @required this.prizeAmount,
    @required this.onShareButtonPressed,
  }) : super(key: key);

  Key imageKey;
  String dpUrl;
  PrizeClaimChoice choice;
  double prizeAmount;
  ValueChanged onShareButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            //Main content
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Share the news with\nyour fellows",
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSans.semiBold.body2
                        .colour(Colors.white),
                  ),
                  Expanded(
                    child: RepaintBoundary(
                      key: imageKey,
                      child: ShareCard(
                        dpUrl: dpUrl,
                        claimChoice: choice,
                        prizeAmount: prizeAmount,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     width: double.infinity,
                  //     margin: EdgeInsets.only(
                  //         left: SizeConfig.pageHorizontalMargins,
                  //         right: SizeConfig.pageHorizontalMargins,
                  //         top: SizeConfig.padding40,
                  //         bottom: SizeConfig.padding80),
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.all(
                  //             Radius.circular(SizeConfig.roundness16))),
                  //   ),
                  // ),
                  AppPositiveBtn(
                      btnText: "SHARE",
                      onPressed: () {
                        if (onShareButtonPressed != null)
                          onShareButtonPressed(true);
                      },
                      width: SizeConfig.screenWidth * 0.5)
                ],
              ),
            ),
            //Cross button
            SizedBox(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
