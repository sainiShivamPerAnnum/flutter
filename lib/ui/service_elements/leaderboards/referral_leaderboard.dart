import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/web_game_prize_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

// class ReferralLeaderboard extends StatelessWidget {
//   final int count;
//   ReferralLeaderboard({this.count});
//   getLength(int listLength) {
//     if (count != null) {
//       if (listLength < count)
//         return listLength;
//       else
//         return count;
//     } else
//       return listLength;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PropertyChangeConsumer<LeaderboardService,
//             LeaderBoardServiceProperties>(
//         properties: [LeaderBoardServiceProperties.ReferralLeaderboard],
//         builder: (context, model, properties) {
//           return Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   padding: EdgeInsets.only(top: SizeConfig.padding8),
//                   child: model.referralLeaderBoard == null
//                       ? Container(
//                           width: SizeConfig.screenWidth,
//                           color: Colors.white,
//                           alignment: Alignment.center,
//                           child: ListLoader())
//                       : (model.referralLeaderBoard.isEmpty
//                           ? Container(
//                               width: SizeConfig.screenWidth,
//                               height: SizeConfig.safeScreenHeight * 0.7,
//                               color: Colors.white,
//                               child: NoRecordDisplayWidget(
//                                 asset: "images/leaderboard.png",
//                                 text:
//                                     "Referral Leaderboard will be updated soon",
//                               ),
//                             )
//                           : Column(
//                               children: [
//                                 // Container(
//                                 //   margin: EdgeInsets.only(
//                                 //       bottom: SizeConfig.padding20),
//                                 //   width: SizeConfig.screenWidth,
//                                 //   padding: EdgeInsets.symmetric(
//                                 //       vertical: SizeConfig.padding4,
//                                 //       horizontal:
//                                 //           SizeConfig.pageHorizontalMargins),
//                                 //   color:
//                                 //       UiConstants.primaryLight.withOpacity(0.5),
//                                 //   child: FittedBox(
//                                 //     fit: BoxFit.scaleDown,
//                                 //     child: Text(
//                                 //       "You've to make atleast 100 referrals to win an iphone 13",
//                                 //       maxLines: 1,
//                                 //       style: TextStyles.body3
//                                 //           .colour(UiConstants.primaryColor),
//                                 //     ),
//                                 //   ),
//                                 // ),
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
//                                         'This months\'s top referrers:',
//                                         style: TextStyles.body4
//                                             .colour(Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Column(
//                                   children: List.generate(
//                                     getLength(model.referralLeaderBoard.length),
//                                     (i) {
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
//                                                       model
//                                                               .referralLeaderBoard[
//                                                                   i]
//                                                               .username
//                                                               .replaceAll(
//                                                                   '@', '.') ??
//                                                           "username",
//                                                       style: TextStyles.body3),
//                                                 ],
//                                               ),
//                                             ),
//                                             PrizeChip(
//                                               color: UiConstants.primaryColor,
//                                               svg: Assets.plane,
//                                               text: model.referralLeaderBoard[i]
//                                                       .refCount
//                                                       .toString() ??
//                                                   "00",
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )),
//                 ),
//                 SizedBox(
//                   height: model.referralLeaderBoard.length < 10
//                       ? (10 - model.referralLeaderBoard.length) *
//                           SizeConfig.padding54
//                       : SizeConfig.navBarHeight * 1.5,
//                 )
//               ],
//             ),
//           );
//         });
//   }
// }

class ReferralLeaderboard extends StatelessWidget {
  final int count;
  ReferralLeaderboard({this.count});
  getLength(int listLength) {
    if (count != null) {
      if (listLength < count)
        return listLength;
      else
        return count;
    } else
      return listLength;
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LeaderboardService,
            LeaderBoardServiceProperties>(
        properties: [LeaderBoardServiceProperties.ReferralLeaderboard],
        builder: (context, model, properties) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.padding20),
            margin: EdgeInsets.fromLTRB(
                SizeConfig.padding24, 0.0, SizeConfig.padding24, 0.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Top Referers",
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
                      "1K Referals\nweekly",
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
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        padding: EdgeInsets.only(top: SizeConfig.padding8),
                        child: model.referralLeaderBoard == null
                            ? Container(
                                width: SizeConfig.screenWidth,
                                color: Colors.transparent,
                                margin: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding24),
                                alignment: Alignment.center,
                                child: SpinKitWave(
                                  color: UiConstants.primaryColor,
                                ),
                              )
                            : (model.referralLeaderBoard.isEmpty
                                ? Container(
                                    width: SizeConfig.screenWidth,
                                    color: Colors.transparent,
                                    margin: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding24),
                                    child: NoRecordDisplayWidget(
                                      topPadding: false,
                                      asset: "images/leaderboard.png",
                                      text:
                                          "Referral Leaderboard will be updated soon",
                                    ),
                                  )
                                : Column(
                                    children: [
                                      // Container(
                                      //   margin: EdgeInsets.only(
                                      //       bottom: SizeConfig.padding20),
                                      //   width: SizeConfig.screenWidth,
                                      //   padding: EdgeInsets.symmetric(
                                      //       vertical: SizeConfig.padding4,
                                      //       horizontal:
                                      //           SizeConfig.pageHorizontalMargins),
                                      //   color:
                                      //       UiConstants.primaryLight.withOpacity(0.5),
                                      //   child: FittedBox(
                                      //     fit: BoxFit.scaleDown,
                                      //     child: Text(
                                      //       "You've to make atleast 100 referrals to win an iphone 13",
                                      //       maxLines: 1,
                                      //       style: TextStyles.body3
                                      //           .colour(UiConstants.primaryColor),
                                      //     ),
                                      //   ),
                                      // ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "#",
                                            style: TextStyles.sourceSans.body3
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          ),
                                          SizedBox(width: SizeConfig.padding12),
                                          SizedBox(width: SizeConfig.padding12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Names",
                                                    style: TextStyles
                                                        .sourceSans.body3
                                                        .colour(UiConstants
                                                            .kTextColor2)),
                                                SizedBox(
                                                    height:
                                                        SizeConfig.padding4),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "Referals",
                                            style: TextStyles.sourceSans.body3
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          )
                                        ],
                                      ),

                                      Column(
                                        children: List.generate(
                                          getLength(
                                              model.referralLeaderBoard.length),
                                          (i) {
                                            return Container(
                                              width: SizeConfig.screenWidth,
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      SizeConfig.padding12),
                                              margin: EdgeInsets.symmetric(
                                                vertical: SizeConfig.padding8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
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
                                                                model
                                                                    .referralLeaderBoard[
                                                                        i]
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
                                                                model
                                                                        .referralLeaderBoard[
                                                                            i]
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
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        model.referralLeaderBoard[i]
                                                                .refCount
                                                                .toString() ??
                                                            "00",
                                                        style: TextStyles
                                                            .sourceSans.body2
                                                            .colour(
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                  if (i + 1 <
                                                      getLength(model
                                                          .referralLeaderBoard
                                                          .length))
                                                    Divider(
                                                      color: Colors.white,
                                                      thickness: 0.2,
                                                    )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding16,
                                      ),
                                      if (model.referralLeaderBoard.length >
                                          getLength(
                                              model.referralLeaderBoard.length))
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
                                                      Assets.chevRonRightArrow,
                                                      height:
                                                          SizeConfig.padding24,
                                                      width:
                                                          SizeConfig.padding24,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
