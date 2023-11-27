import 'dart:math' as math;

import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TambolaLeaderboardView extends StatefulWidget {
  const TambolaLeaderboardView({
    Key? key,
  }) : super(key: key);

  @override
  State<TambolaLeaderboardView> createState() => _TambolaLeaderboardViewState();
}

class _TambolaLeaderboardViewState extends State<TambolaLeaderboardView> {
  bool _seeAll = false;

  void seeAllClicked() {
    setState(() {
      _seeAll = true;
    });
  }

  @override
  void dispose() {
    _seeAll = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Selector<TambolaService, List<Winners>?>(
        selector: (_, tambolaService) => tambolaService.pastWeekWinners,
        builder: (context, winners, child) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      SizeConfig.pageHorizontalMargins - SizeConfig.padding16,
                ),
                Text(
                  "Weekly Leaderboard",
                  style: TextStyles.sourceSansSB.title3,
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                winners == null
                    ? Center(
                        child: Column(
                          children: [
                            FullScreenLoader(size: SizeConfig.padding80),
                            SizedBox(
                              height: SizeConfig.padding16,
                            ),
                            Text(
                              "Fetching last week winners..",
                              style: TextStyles.rajdhaniB.body2
                                  .colour(Colors.white),
                            ),
                          ],
                        ),
                      )
                    : (winners.isEmpty
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding24),
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            width: SizeConfig.screenWidth,
                            child: const NoRecordDisplayWidget(
                              topPadding: false,
                              assetSvg: Assets.noWinnersAsset,
                              text: "Leaderboard will be updated soon",
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: UiConstants.kTambolaMidTextColor,
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness16),
                            ),
                            // margin: EdgeInsets.symmetric(
                            //     horizontal: SizeConfig.pageHorizontalMargins),
                            // padding: EdgeInsets.all(SizeConfig.padding10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.padding16,
                                      bottom: SizeConfig.padding10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: SizeConfig.padding24),
                                      Text(
                                        "#",
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                      SizedBox(width: SizeConfig.padding54),
                                      Text("Name",
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants.kTextColor2)),
                                      const Spacer(),
                                      Text(
                                        'Earned',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                      SizedBox(width: SizeConfig.padding20),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    if (winners.indexWhere((winner) =>
                                            winner.userid ==
                                            locator<UserService>()
                                                .baseUser!
                                                .uid) !=
                                        -1)
                                      Card(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.padding10,
                                            vertical: SizeConfig.padding10),
                                        color: Colors.white30,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.roundness12),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: SizeConfig.padding14),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: SizeConfig.padding8),
                                              Text(
                                                "${winners.indexWhere((winner) => winner.userid == locator<UserService>().baseUser!.uid) + 1}",
                                                style: TextStyles
                                                    .sourceSans.body2
                                                    .colour(Colors.white),
                                              ),
                                              SizedBox(
                                                  width: SizeConfig.padding8),
                                              DefaultAvatar(),
                                              SizedBox(
                                                  width: SizeConfig.padding12),
                                              Expanded(
                                                child: Text(
                                                    //"avc",
                                                    winners[winners.indexWhere(
                                                            (winner) =>
                                                                winner.userid ==
                                                                locator<UserService>()
                                                                    .baseUser!
                                                                    .uid)]
                                                        .username!
                                                        .replaceAll('@', '.'),
                                                    style: TextStyles
                                                        .sourceSans.body2
                                                        .colour(Colors.white)),
                                              ),
                                              SizedBox(
                                                  width: SizeConfig.padding4),
                                              Text(
                                                "₹${winners[winners.indexWhere((winner) => winner.userid == locator<UserService>().baseUser!.uid)].amount?.toInt() ?? "00"}",
                                                style: TextStyles
                                                    .sourceSansSB.body2
                                                    .colour(UiConstants
                                                        .kGoldProPrimary),
                                              ),
                                              SizedBox(
                                                  width: SizeConfig.padding12),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ...List.generate(
                                      _seeAll
                                          ? winners.length
                                          : winners.length > 10
                                              ? 10
                                              : winners.length,
                                      (i) {
                                        return Column(
                                          children: [
                                            Container(
                                              width: SizeConfig.screenWidth,
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      SizeConfig.padding12),
                                              margin: EdgeInsets.symmetric(
                                                vertical: SizeConfig.padding4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        SizeConfig.roundness16),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          SizeConfig.padding24),
                                                  Text(
                                                    "${i + 1}",
                                                    style: TextStyles
                                                        .sourceSans.body2
                                                        .colour(Colors.white),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          SizeConfig.padding12),
                                                  DefaultAvatar(),
                                                  SizedBox(
                                                      width:
                                                          SizeConfig.padding12),
                                                  Expanded(
                                                    child: Text(
                                                        //"avc",
                                                        winners[i]
                                                            .username!
                                                            .replaceAll(
                                                                '@', '.'),
                                                        style: TextStyles
                                                            .sourceSans.body2
                                                            .colour(
                                                                Colors.white)),
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.padding4,
                                                  ),
                                                  SizedBox(
                                                    width: SizeConfig.padding64,
                                                    // color: Colors.blue,
                                                    child: Text(
                                                      "₹${winners[i].amount?.toInt() ?? "00"}",
                                                      style: TextStyles
                                                          .sourceSansSB.body2
                                                          .colour(UiConstants
                                                              .kGoldProPrimary),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (i + 1 < winners.length)
                                              const Divider(
                                                color: Colors.white,
                                                thickness: 0.2,
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.padding16,
                                ),
                                !_seeAll
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _seeAll = true;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "See all",
                                              style: TextStyles
                                                  .sourceSansSB.body2
                                                  .colour(Colors.white),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding8,
                                            ),
                                            Transform.rotate(
                                                angle: math.pi / 2,
                                                child: SvgPicture.asset(
                                                  Assets.chevRonRightArrow,
                                                  color:
                                                      UiConstants.primaryColor,
                                                ))
                                          ],
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          )),
              ],
            ),
          );
        });
  }
}
