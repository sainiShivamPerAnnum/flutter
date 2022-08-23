import 'dart:convert';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';

import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timelines/timelines.dart';

class SellAssetsConfirmationView extends StatelessWidget {
  const SellAssetsConfirmationView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UiConstants.kBackgroundColor,
        body: BaseView<SaveViewModel>(
          onModelReady: (model) => model.init(),
          builder: (context, model, child) => Scaffold(
            backgroundColor: UiConstants.kDarkBackgroundColor,
            body: Stack(
              children: [
                NewSquareBackground(),
                Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.padding54,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding24),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              AppState.backButtonDispatcher.didPopRoute();
                              AppState.backButtonDispatcher.didPopRoute();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    Image.asset(Assets.saleSuccessVector),
                    Text(
                      'Sell Completed',
                      style: TextStyles.rajdhaniB.title2,
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    Text(
                      'Your balance will be credited to your registered bank\naccount within 1-2 business working days',
                      style: TextStyles.rajdhani.body3,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    Container(
                        height: SizeConfig.screenWidth * 0.16,
                        width: SizeConfig.screenWidth * 0.87,
                        decoration: BoxDecoration(
                            color: UiConstants.kModalSheetBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding34),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tokens Deducted',
                                style: TextStyles.rajdhaniM.body1,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(Assets.aFelloToken),
                                  Text(
                                    '100',
                                    style: TextStyles.rajdhaniM.body1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: SizeConfig.padding10,
                    ),
                    Container(
                      height: SizeConfig.screenWidth * 0.395,
                      width: SizeConfig.screenWidth * 0.87,
                      decoration: BoxDecoration(
                          color: UiConstants.kModalSheetBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding34,
                                vertical: SizeConfig.padding24),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Sold',
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants.kTextColor2)),
                                      SizedBox(
                                        height: SizeConfig.padding10,
                                      ),
                                      Text('1.04g',
                                          style: TextStyles.rajdhaniSB.title4)
                                    ],
                                  ),
                                  DashedLineConnector(
                                    dash: 4,
                                    color: UiConstants.kTextColor2,
                                    direction: Axis.vertical,
                                    endIndent: 2,
                                    indent: 2,
                                    space: 1,
                                    thickness: 1,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Received',
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants.kTextColor2)),
                                      SizedBox(
                                        height: SizeConfig.padding10,
                                      ),
                                      Text('\u20b9 100',
                                          style: TextStyles.rajdhaniSB.title4)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: SizeConfig.screenWidth * 0.12,
                              width: SizeConfig.screenWidth * 0.87,
                              decoration: BoxDecoration(
                                  color: UiConstants
                                      .kModalSheetSecondaryBackgroundColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          SizeConfig.roundness12),
                                      bottomRight: Radius.circular(
                                          SizeConfig.roundness12))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding34),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: TextStyles.sourceSans.body3
                                          .colour(UiConstants.kTextColor),
                                    ),
                                    Text(
                                      '0.24gm',
                                      style: TextStyles.sourceSans.body2
                                          .colour(UiConstants.kTextColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class SellingGoldAmountBottomSheet extends StatelessWidget {
  const SellingGoldAmountBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SaleConfirmationDialog extends StatelessWidget {
  const SaleConfirmationDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SellConfirmationDialog extends StatelessWidget {
  const SellConfirmationDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
