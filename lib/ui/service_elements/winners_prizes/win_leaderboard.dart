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
          return DraggableScrollableSheet(
            initialChildSize: 0.2,
            maxChildSize: 0.92,
            minChildSize: 0.2,
            builder: (BuildContext context, myscrollController) {
              return SingleChildScrollView(
                controller: myscrollController,
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, 1),
                      child: SvgPicture.asset(
                        Assets.clip,
                        width: SizeConfig.screenWidth,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.padding16,
                                  left: SizeConfig.pageHorizontalMargins),
                              child: Text(
                                "Leaderboard",
                                style: TextStyles.title3.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          child: model.winners == null
                              ? Column(
                                  children: [
                                    Center(
                                      child: SpinKitWave(
                                        color: UiConstants.primaryColor,
                                      ),
                                    ),
                                    Container(
                                      height: SizeConfig.screenHeight * 0.7,
                                    )
                                  ],
                                )
                              : (model.winners.isEmpty
                                  ? Column(
                                      children: [
                                        NoRecordDisplayWidget(
                                          asset: "images/leaderboard.png",
                                          text:
                                              "Leaderboard will be upadated soon",
                                        ),
                                        Container(
                                          height: SizeConfig.screenHeight * 0.7,
                                        )
                                      ],
                                    )
                                  : WinnerboardView(
                                      winners: model.winners,
                                      controller: myscrollController,
                                      timeStamp: model.timeStamp,
                                    )),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
    return Column(
      children: [
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
        Column(
          children: List.generate(
            winners.length,
            (i) {
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
        ),
        SizedBox(
          height: SizeConfig.navBarHeight * 1.5,
        )
      ],
    );
  }
}



// class CustomDraggableLeaderboard extends StatefulWidget {
//   @override
//   State<CustomDraggableLeaderboard> createState() =>
//       _CustomDraggableLeaderboardState();
// }

// class _CustomDraggableLeaderboardState
//     extends State<CustomDraggableLeaderboard> {
//   double animatedHeight = SizeConfig.screenHeight * 0.24;

//   animate() {
//     setState(() {
//       animatedHeight = SizeConfig.screenHeight * 0.7;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
//         properties: [WinnerServiceProperties.winLeaderboard],
//         builder: (context, model, properties) {
//           return Container(
//               color: Colors.white,
//               // duration: Duration(seconds: 1),
//               // curve: Curves.easeIn,
//               height: SizeConfig.screenHeight * 0.5,
//               width: SizeConfig.screenWidth,
//               child: Column(
//                 children: [
//                   SvgPicture.asset(
//                     Assets.clip,
//                     width: SizeConfig.screenWidth,
//                   ),
//                   Text(
//                     "Leaderboard",
//                     style: TextStyles.title3.bold,
//                   ),
//                   model.winners == null
//                       ? Center(
//                           child: SpinKitWave(
//                             color: UiConstants.primaryColor,
//                           ),
//                         )
//                       : (model.winners.isEmpty
//                           ? Container(
//                               child: Center(
//                                 child: NoRecordDisplayWidget(
//                                   asset: "images/leaderboard.png",
//                                   text: "Leaderboard will be upadated soon",
//                                 ),
//                               ),
//                             )
//                           : Column(
//                               children: [
//                                 SizedBox(height: SizeConfig.padding80),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal:
//                                         SizeConfig.pageHorizontalMargins,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Previous week\'s prize winners:',
//                                         style: TextStyles.body4
//                                             .colour(Colors.grey),
//                                       ),
//                                       Text(
//                                         model.timeStamp != null
//                                             ? "Updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(model.timeStamp.toDate())}"
//                                             : "",
//                                         style: TextStyles.body4
//                                             .colour(Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: ListView.builder(
//                                     //controller: controller,
//                                     shrinkWrap: true,
//                                     itemCount: model.winners.length,
//                                     padding: EdgeInsets.only(
//                                         bottom: SizeConfig.navBarHeight),
//                                     itemBuilder: (ctx, i) {
//                                       return Container(
//                                         width: SizeConfig.screenWidth,
//                                         padding: EdgeInsets.all(
//                                             SizeConfig.padding12),
//                                         margin: EdgeInsets.symmetric(
//                                             vertical: SizeConfig.padding8,
//                                             horizontal: SizeConfig
//                                                 .pageHorizontalMargins),
//                                         decoration: BoxDecoration(
//                                           color: Color(0xfff6f6f6),
//                                           borderRadius: BorderRadius.circular(
//                                               SizeConfig.roundness16),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             CircleAvatar(
//                                               backgroundColor:
//                                                   UiConstants.primaryColor,
//                                               radius: SizeConfig.padding16,
//                                               child: Text(
//                                                 "${i + 1}",
//                                                 style: TextStyles.body4
//                                                     .colour(Colors.white),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                                 width: SizeConfig.padding12),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Text(
//                                                       //"avc",
//                                                       model.winners[i].username
//                                                               .replaceAll(
//                                                                   '@', '.') ??
//                                                           "username",
//                                                       style: TextStyles.body3),
//                                                   SizedBox(
//                                                       height:
//                                                           SizeConfig.padding4),
//                                                   Text(
//                                                     model.winners[i].gameType ==
//                                                             Constants
//                                                                 .GAME_TYPE_CRICKET
//                                                         ? "Cricket"
//                                                         : "Tambola",
//                                                     style: TextStyles.body4
//                                                         .colour(UiConstants
//                                                             .primaryColor),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             PrizeChip(
//                                               color: UiConstants.primaryColor,
//                                               png: Assets.moneyIcon,
//                                               text:
//                                                   "Rs ${model.winners[i].amount.toString() ?? "00"}",
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )),
//                 ],
//               ));
//         });
//   }
// }