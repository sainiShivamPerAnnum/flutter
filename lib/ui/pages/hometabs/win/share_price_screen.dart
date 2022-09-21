import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SharePriceScreen extends StatelessWidget {
  SharePriceScreen({
    Key key,
    @required this.dpUrl,
    @required this.choice,
    @required this.prizeAmount,
  }) : super(key: key);

  String dpUrl;
  PrizeClaimChoice choice;
  double prizeAmount;

  @override
  Widget build(BuildContext context) {
    return BaseView<WinViewModel>(
      onModelReady: (model) {
        model.init();
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (ctx, model, child) => Scaffold(
        backgroundColor:
            UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              //Main content
              Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(top: kToolbarHeight),
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
                        key: model.imageKey,
                        child: ShareCard(
                          dpUrl: dpUrl,
                          claimChoice: choice,
                          prizeAmount: prizeAmount,
                        ),
                      ),
                    ),
                    model.isShareLoading
                        ? Container(
                            height: SizeConfig.screenWidth * 0.1556,
                            width: SizeConfig.screenWidth * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.buttonBorderRadius,
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff12BC9D),
                                  Color(0xff249680),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Center(
                              child: SpinKitThreeBounce(
                                size: SizeConfig.padding20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : AppPositiveBtn(
                            btnText: "SHARE",
                            onPressed: () {
                              model.sharePrizeDetails();
                            },
                            width: SizeConfig.screenWidth * 0.5),
                    SizedBox(height: SizeConfig.padding24)
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
