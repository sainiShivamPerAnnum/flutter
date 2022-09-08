import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

// class WinnerboardView extends StatelessWidget {
//   final int count;
//   WinnerboardView({this.count});

//   getLength(int listLength) {
//     if (count != null) {
//       if (listLength < count)
//         return listLength;
//       else
//         return count;
//     } else
//       return listLength;
//   }

//   getGameName(String gamename) {
//     switch (gamename) {
//       case Constants.GAME_TYPE_TAMBOLA:
//         return "Tambola";
//       case Constants.GAME_TYPE_CRICKET:
//         return "Cricket";
//       case Constants.GAME_TYPE_POOLCLUB:
//         return "Pool Club";
//       case Constants.GAME_TYPE_FOOTBALL:
//         return "Foot Ball";
//       case Constants.GAME_TYPE_CANDYFIESTA:
//         return "Candy Fiesta";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
//         properties: [WinnerServiceProperties.winLeaderboard],
//         builder: (context, model, properties) {
//           return Container(
//             color: Colors.white,
//             padding: EdgeInsets.only(top: SizeConfig.padding8),
//             child: model.winners == null
//                 ? Container(
//                     color: Colors.white,
//                     alignment: Alignment.center,
//                     width: SizeConfig.screenWidth,
//                     child: SpinKitWave(
//                       color: UiConstants.primaryColor,
//                     ),
//                   )
//                 : (model.winners.isEmpty
//                     ? Container(
//                         color: Colors.white,
//                         height: SizeConfig.safeScreenHeight * 0.88,
//                         alignment: Alignment.center,
//                         width: SizeConfig.screenWidth,
//                         child: NoRecordDisplayWidget(
//                           asset: "images/leaderboard.png",
//                           text: "Leaderboard will be updated soon",
//                         ),
//                       )
//                     : Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: SizeConfig.pageHorizontalMargins,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Previous week\'s prize winners:',
//                                   style: TextStyles.body4.colour(Colors.grey),
//                                 ),
//                                 Text(
//                                   model.timeStamp != null
//                                       ? "Updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(model.timeStamp.toDate())}"
//                                       : "",
//                                   style: TextStyles.body4.colour(Colors.grey),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             children: List.generate(
//                               getLength(model.winners.length),
//                               (i) {
//                                 return Container(
//                                   width: SizeConfig.screenWidth,
//                                   padding: EdgeInsets.all(SizeConfig.padding12),
//                                   margin: EdgeInsets.symmetric(
//                                       vertical: SizeConfig.padding8,
//                                       horizontal:
//                                           SizeConfig.pageHorizontalMargins),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xfff6f6f6),
//                                     borderRadius: BorderRadius.circular(
//                                         SizeConfig.roundness16),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       CircleAvatar(
//                                         backgroundColor:
//                                             UiConstants.primaryColor,
//                                         radius: SizeConfig.padding16,
//                                         child: Text(
//                                           "${i + 1}",
//                                           style: TextStyles.body4
//                                               .colour(Colors.white),
//                                         ),
//                                       ),
//                                       SizedBox(width: SizeConfig.padding12),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                                 //"avc",
//                                                 model.winners[i].username
//                                                         .replaceAll('@', '.') ??
//                                                     "username",
//                                                 style: TextStyles.body3),
//                                             SizedBox(
//                                                 height: SizeConfig.padding4),
//                                             Text(
//                                               getGameName(
//                                                   model.winners[i].gameType),
//                                               style: TextStyles.body4.colour(
//                                                   UiConstants.primaryColor),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       PrizeChip(
//                                         color: UiConstants.primaryColor,
//                                         png: Assets.moneyIcon,
//                                         text:
//                                             "₹ ${model.winners[i].amount.toInt() ?? "00"}",
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: model.winners.length < 10
//                                 ? (10 - model.winners.length) *
//                                     SizeConfig.padding54
//                                 : SizeConfig.navBarHeight * 1.5,
//                           )
//                         ],
//                       )),
//           );
//         });
//   }
// }

class WinnerboardView extends StatelessWidget {
  final int count;
  WinnerboardView({this.count});

  getLength(int listLength) {
    if (count != null) {
      if (listLength < count)
        return listLength;
      else
        return count;
    } else
      return listLength;
  }

  getGameName(String gamename) {
    switch (gamename) {
      case Constants.GAME_TYPE_TAMBOLA:
        return "Tambola";
      case Constants.GAME_TYPE_CRICKET:
        return "Cricket";
      case Constants.GAME_TYPE_POOLCLUB:
        return "Pool Club";
      case Constants.GAME_TYPE_FOOTBALL:
        return "Foot Ball";
      case Constants.GAME_TYPE_CANDYFIESTA:
        return "Candy Fiesta";
    }
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
        properties: [WinnerServiceProperties.winLeaderboard],
        builder: (context, model, properties) {
          return Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                //1
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.padding32),
                  width: SizeConfig.screenWidth * 0.5,
                  height: SizeConfig.screenWidth * 0.5,
                  decoration: BoxDecoration(
                    color: UiConstants.kSecondaryBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
                //2
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
                  margin: EdgeInsets.fromLTRB(
                      0.0,
                      SizeConfig.screenWidth * 0.15 + SizeConfig.padding32,
                      0.0,
                      0.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: UiConstants.kSecondaryBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.padding64,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Highest Scorers",
                                style: TextStyles.rajdhaniSB.body0.colour(
                                    UiConstants.kSecondaryLeaderBoardTextColor),
                              ),
                              Text(
                                model.getDateRange(),
                                style: TextStyles.sourceSans.body4
                                    .colour(UiConstants.kTextFieldTextColor),
                              )
                            ],
                          ),
                          Text(
                            "5K Players\nweekly",
                            style: TextStyles.sourceSans.body4
                                .colour(UiConstants.kTextFieldTextColor),
                            textAlign: TextAlign.end,
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding32,
                      ),
                      //Old code to refactor starts here
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(top: SizeConfig.padding8),
                        child: model.winners == null
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding24),
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                width: SizeConfig.screenWidth,
                                child: SpinKitWave(
                                  color: UiConstants.primaryColor,
                                ),
                              )
                            : (model.winners.isEmpty
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding24),
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    width: SizeConfig.screenWidth,
                                    child: NoRecordDisplayWidget(
                                      topPadding: false,
                                      asset: "images/leaderboard.png",
                                      text: "Leaderboard will be updated soon",
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Column(
                                        children: List.generate(
                                          getLength(model.winners.length),
                                          (i) {
                                            return Column(
                                              children: [
                                                Container(
                                                  width: SizeConfig.screenWidth,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          SizeConfig.padding12),
                                                  margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        SizeConfig.padding4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            SizeConfig
                                                                .roundness16),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${i + 1}",
                                                        style: TextStyles
                                                            .sourceSans.body2
                                                            .colour(
                                                                Colors.white),
                                                      ),
                                                      SizedBox(
                                                          width: SizeConfig
                                                              .padding12),
                                                      FutureBuilder(
                                                        future: model
                                                            .getProfileDpWithUid(
                                                                model.winners[i]
                                                                    .userid),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Image.asset(
                                                              Assets
                                                                  .defaultProfilePlaceholder,
                                                              width: SizeConfig
                                                                  .iconSize5,
                                                              height: SizeConfig
                                                                  .iconSize5,
                                                            );
                                                          }

                                                          String imageUrl =
                                                              snapshot.data
                                                                  as String;

                                                          return ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  imageUrl,
                                                              fit: BoxFit.cover,
                                                              width: SizeConfig
                                                                  .iconSize5,
                                                              height: SizeConfig
                                                                  .iconSize5,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                width: SizeConfig
                                                                    .iconSize5,
                                                                height: SizeConfig
                                                                    .iconSize5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                              errorWidget:
                                                                  (a, b, c) {
                                                                return Image
                                                                    .asset(
                                                                  Assets
                                                                      .defaultProfilePlaceholder,
                                                                  width: SizeConfig
                                                                      .iconSize5,
                                                                  height: SizeConfig
                                                                      .iconSize5,
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      SizedBox(
                                                          width: SizeConfig
                                                              .padding12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                                //"avc",
                                                                model.winners[i]
                                                                        .username
                                                                        .replaceAll(
                                                                            '@',
                                                                            '.') ??
                                                                    "username",
                                                                style: TextStyles
                                                                    .sourceSans
                                                                    .body2
                                                                    .colour(Colors
                                                                        .white)),
                                                            SizedBox(
                                                                height: SizeConfig
                                                                    .padding4),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        "₹ ${model.winners[i].amount.toInt() ?? "00"}",
                                                        style: TextStyles
                                                            .sourceSans.body2
                                                            .colour(
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                if (i + 1 <
                                                    getLength(
                                                        model.winners.length))
                                                  Divider(
                                                    color: Colors.white,
                                                    thickness: 0.2,
                                                  )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding16,
                                      ),
                                      if (model.winners.length >
                                          getLength(model.winners.length))
                                        TextButton(
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        SizeConfig.padding12),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top:
                                                            SizeConfig.padding2,
                                                      ),
                                                      child: Text('See All',
                                                          style: TextStyles
                                                              .rajdhaniSB
                                                              .body2),
                                                    ),
                                                    SvgPicture.asset(
                                                        Assets
                                                            .chevRonRightArrow,
                                                        height: SizeConfig
                                                            .padding24,
                                                        width: SizeConfig
                                                            .padding24,
                                                        color: Colors.white)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  )),
                      )
                    ],
                  ),
                ),
                //3
                Container(
                  margin: EdgeInsets.only(right: SizeConfig.padding14),
                  child: SvgPicture.asset(
                    Assets.winScreenHighestScorers,
                    width: SizeConfig.screenWidth * 0.3,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
