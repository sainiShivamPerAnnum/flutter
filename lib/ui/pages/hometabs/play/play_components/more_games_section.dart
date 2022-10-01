import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class MoreGamesSection extends StatelessWidget {
  final PlayViewModel model;
  const MoreGamesSection({
    @required this.model,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSubtitleContainer(
            title: "Explore Arcade Games",
            subTitle:
                "Play using fello tokens. Money from savings will not be deducted"),
        Container(
          margin:
              EdgeInsets.symmetric(vertical: SizeConfig.pageHorizontalMargins),
          child: Column(
            children: List.generate(
              model.isGamesListDataLoading ? 3 : model.moreGamesListData.length,
              (index) {
                return (model.isGamesListDataLoading)
                    ? MoreGamesShimmer()
                    : MoreGames(
                        game: model.moreGamesListData[index],
                        showDivider: index != model.moreGamesListData.length - 1
                            ? true
                            : false,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MoreGames extends StatelessWidget {
  final GameModel game;
  final bool showDivider;

  const MoreGames({
    this.game,
    this.showDivider,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        AppState.delegate.parseRoute(
          Uri.parse(game.route),
        );
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.roundness24)),
                    color: game.shadowColor,
                  ),
                  height: SizeConfig.screenWidth * 0.38,
                  width: SizeConfig.screenWidth * 0.291,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.roundness24)),
                    child: SvgPicture.network(
                      game.icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.gameName,
                          style: TextStyles.rajdhaniSB.bold.body1
                              .colour(Colors.white),
                        ),
                        SizedBox(
                          height: SizeConfig.padding8,
                        ),
                        Text(
                          "Win upto ₹${game.prizeAmount.toString()}",
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor2),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.token,
                                  height: SizeConfig.padding20,
                                ),
                                SizedBox(width: SizeConfig.padding6),
                                Text(
                                  game.playCost.toString(),
                                  style: TextStyles.sourceSans.body2
                                      .colour(Colors.white),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Haptic.vibrate();
                                AppState.delegate.parseRoute(
                                  Uri.parse(game.route),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: UiConstants.playButtonColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.roundness8),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding28,
                                    vertical: SizeConfig.padding12),
                                child: Text(
                                  "PLAY",
                                  style: TextStyles.rajdhaniSB.body1
                                      .colour(Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (showDivider)
              Container(
                width: double.infinity,
                height: 0.4,
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding16,
                    horizontal: SizeConfig.padding34),
                decoration:
                    BoxDecoration(color: UiConstants.kLastUpdatedTextColor),
              )
          ],
        ),
      ),
    );
  }
}

class MoreGamesShimmer extends StatelessWidget {
  const MoreGamesShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.padding16,
      ),
      child: Shimmer.fromColors(
        baseColor: UiConstants.kUserRankBackgroundColor,
        highlightColor: UiConstants.kBackgroundColor,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.roundness24)),
                color: Colors.grey.shade600,
              ),
              height: SizeConfig.screenWidth * 0.36,
              width: SizeConfig.screenWidth * 0.291,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.roundness24)),
              ),
            ),
            SizedBox(
              width: SizeConfig.padding16,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      height: SizeConfig.padding14,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(
                      height: SizeConfig.padding8,
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: SizeConfig.padding10,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeConfig.padding70,
                          height: SizeConfig.padding14,
                          color: Colors.grey.shade600,
                        ),
                        Container(
                          width: SizeConfig.screenWidth * 0.2,
                          height: SizeConfig.screenWidth * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(SizeConfig.roundness12))),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding28,
                              vertical: SizeConfig.padding12),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class MoreGamesShimmer extends StatelessWidget {
//   const MoreGamesShimmer({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: SizeConfig.padding24,
//         right: SizeConfig.padding24,
//         bottom: SizeConfig.padding12,
//       ),
//       height: SizeConfig.screenWidth * 0.218,
//       width: SizeConfig.screenWidth * 0.901,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         border: Border.all(color: Colors.white30),
//         borderRadius: BorderRadius.circular(SizeConfig.roundness8),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(SizeConfig.roundness5),
//         child: Shimmer.fromColors(
//           baseColor: UiConstants.kUserRankBackgroundColor,
//           highlightColor: UiConstants.kBackgroundColor,
//           child: Row(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
//                 child: Container(
//                   width: SizeConfig.screenWidth * 0.16,
//                   height: SizeConfig.screenWidth * 0.16,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade600,
//                     borderRadius: BorderRadius.circular(SizeConfig.roundness5),
//                   ),
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade600,
//                       borderRadius:
//                           BorderRadius.circular(SizeConfig.roundness5),
//                     ),
//                     width: SizeConfig.screenWidth * 0.213,
//                     height: SizeConfig.screenWidth * 0.053,
//                   ),
//                   Container(
//                     width: SizeConfig.screenWidth * 0.266,
//                     height: SizeConfig.screenWidth * 0.026,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade600,
//                       borderRadius:
//                           BorderRadius.circular(SizeConfig.roundness5),
//                     ),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
//                 child: Container(
//                   width: SizeConfig.screenWidth * 0.106,
//                   height: SizeConfig.screenWidth * 0.08,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade600,
//                     borderRadius: BorderRadius.circular(SizeConfig.roundness5),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
