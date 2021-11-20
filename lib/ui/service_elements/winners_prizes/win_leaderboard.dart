import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnersLeaderBoardSE extends StatelessWidget {
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
        properties: [WinnerServiceProperties.winLeaderboard],
        builder: (context, model, properties) {
          return Container(
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              maxChildSize: 0.94,
              minChildSize: 0.2,
              builder: (BuildContext context, myscrollController) {
                return Stack(
                  children: [
                    // Positioned(
                    //   top: -SizeConfig.screenHeight * 0.19,
                    //   child: Container(
                    //     height: SizeConfig.screenHeight * 2,
                    //     // color: Colors.red,
                    //     width: SizeConfig.screenWidth,
                    //     child: Column(
                    //       children: [
                    //         Expanded(
                    //           child: Container(
                    //             width: SizeConfig.screenWidth,
                    //             child: CustomPaint(
                    //               painter: ModalCustomBackground(),
                    //             ),
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: Container(
                    //             color: Colors.white,
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Column(
                      children: [
                        Transform.translate(
                          offset: Offset(0, 1),
                          child: SvgPicture.asset(
                            Assets.clip,
                            width: SizeConfig.screenWidth,
                          ),
                        ),
                        Expanded(child: Container(color: Colors.white))
                      ],
                    ),
                    Positioned(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenWidth * 0.08,
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Text(
                          "Leaderboard",
                          style: TextStyles.title3.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: model.winners == null
                          ? Center(
                              child: SpinKitWave(
                                color: UiConstants.primaryColor,
                              ),
                            )
                          : (model.winners.isEmpty
                              ? Container(
                                  child: ListView(
                                    controller: myscrollController,
                                    children: [
                                      Center(
                                        child: NoRecordDisplayWidget(
                                          asset: "images/leaderboard.png",
                                          text:
                                              "Leaderboard will be upadated soon",
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : WinnerboardView(
                                  winners: model.winners,
                                  controller: myscrollController,
                                  timeStamp: model.timeStamp,
                                )),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}

class WinnerboardView extends StatelessWidget {
  final List<Winners> winners;
  final ScrollController controller;
  final Timestamp timeStamp;

  WinnerboardView({
    @required this.winners,
    @required this.controller,
    @required this.timeStamp,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      // physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.padding80),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Previous week\'s prize winners:',
                  style: TextStyles.body4.colour(Colors.grey),
                ),
                Text(
                  timeStamp != null
                      ? "Updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(timeStamp.toDate())}"
                      : "",
                  style: TextStyles.body4.colour(Colors.grey),
                ),
              ],
            ),
          ),
          ListView.builder(
            controller: controller,
            shrinkWrap: true,
            itemCount: winners.length,
            padding: EdgeInsets.only(bottom: SizeConfig.navBarHeight),
            itemBuilder: (ctx, i) {
              return Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.all(SizeConfig.padding12),
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding8,
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  color: Color(0xfff6f6f6),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: UiConstants.primaryColor,
                      radius: SizeConfig.padding16,
                      child: Text(
                        "${i + 1}",
                        style: TextStyles.body4.colour(Colors.white),
                      ),
                    ),
                    SizedBox(width: SizeConfig.padding12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              //"avc",
                              winners[i].username.replaceAll('@', '.') ??
                                  "username",
                              style: TextStyles.body3),
                          SizedBox(height: SizeConfig.padding4),
                          Text(
                            winners[i].gameType == Constants.GAME_TYPE_CRICKET
                                ? "Cricket"
                                : "Tambola",
                            style: TextStyles.body4
                                .colour(UiConstants.primaryColor),
                          )
                        ],
                      ),
                    ),
                    PrizeChip(
                      color: UiConstants.primaryColor,
                      png: Assets.moneyIcon,
                      text: "Rs ${winners[i].amount.toString() ?? "00"}",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
