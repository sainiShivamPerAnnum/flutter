import 'dart:math' as math;

import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderBoards extends StatefulWidget {
  const LeaderBoards(
      {required this.winners,
      required this.showMyRankings,
      required this.showSeeAllButton,
      required this.backgroundTransparent,
      super.key});
  final List<Winners> winners;
  final bool showSeeAllButton;
  final bool showMyRankings;
  final bool backgroundTransparent;

  @override
  State<LeaderBoards> createState() => _LeaderBoardsState();
}

class _LeaderBoardsState extends State<LeaderBoards> {
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
    final locale = locator<S>();
    return widget.winners.isEmpty
        ? Container(
            margin: EdgeInsets.symmetric(vertical: SizeConfig.padding24),
            color: Colors.transparent,
            alignment: Alignment.center,
            width: SizeConfig.screenWidth,
            child: NoRecordDisplayWidget(
              topPadding: false,
              assetSvg: Assets.noWinnersAsset,
              text: locale.leaderBoardswillUpdate,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: widget.backgroundTransparent
                  ? Colors.transparent
                  : UiConstants.kTambolaMidTextColor,
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.padding16, bottom: SizeConfig.padding10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (widget.winners.indexWhere((winner) =>
                                winner.userid ==
                                locator<UserService>().baseUser!.uid) !=
                            -1 &&
                        widget.showMyRankings)
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding10,
                            vertical: SizeConfig.padding10),
                        color: Colors.white30,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: SizeConfig.padding8),
                              Text(
                                "${widget.winners.indexWhere((winner) => winner.userid == locator<UserService>().baseUser!.uid) + 1}",
                                style: TextStyles.sourceSans.body2
                                    .colour(Colors.white),
                              ),
                              SizedBox(width: SizeConfig.padding8),
                              const DefaultAvatar(),
                              SizedBox(width: SizeConfig.padding12),
                              Expanded(
                                child: Text(
                                    //"avc",
                                    widget
                                        .winners[widget.winners.indexWhere(
                                            (winner) =>
                                                winner.userid ==
                                                locator<UserService>()
                                                    .baseUser!
                                                    .uid)]
                                        .username!
                                        .replaceAll('@', '.'),
                                    style: TextStyles.sourceSans.body2
                                        .colour(Colors.white)),
                              ),
                              SizedBox(width: SizeConfig.padding4),
                              Text(
                                "₹${widget.winners[widget.winners.indexWhere((winner) => winner.userid == locator<UserService>().baseUser!.uid)].amount?.toInt() ?? "00"}",
                                style: TextStyles.sourceSansSB.body2
                                    .colour(UiConstants.kGoldProPrimary),
                              ),
                              SizedBox(width: SizeConfig.padding20),
                            ],
                          ),
                        ),
                      ),
                    ...List.generate(
                      _seeAll
                          ? widget.winners.length
                          : widget.winners.length > 10
                              ? 10
                              : widget.winners.length,
                      (i) {
                        String countSumString =
                            '${widget.winners[i].totalTickets} Tickets';
                        return Column(
                          children: [
                            Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding12),
                              margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: SizeConfig.padding24),
                                  Text(
                                    "${i + 1}",
                                    style: TextStyles.sourceSans.body2
                                        .colour(Colors.white),
                                  ),
                                  SizedBox(width: SizeConfig.padding12),
                                  const DefaultAvatar(),
                                  SizedBox(width: SizeConfig.padding12),
                                  Expanded(
                                    child: Text(
                                        //"avc",
                                        widget.winners[i].username!
                                            .replaceAll('@', '.'),
                                        style: TextStyles.sourceSans.body3
                                            .colour(Colors.white)),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding4,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding100,
                                    // color: Colors.blue,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text.rich(TextSpan(
                                          text:
                                              "₹${widget.winners[i].amount?.toInt() ?? "00"}",
                                          style: TextStyles.sourceSansSB.body2
                                              .colour(
                                                  UiConstants.kGoldProPrimary),
                                        )),
                                        Text(
                                          countSumString,
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants.kTextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.padding20),
                                ],
                              ),
                            ),
                            if (i + 1 < widget.winners.length)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding20),
                                child: const Divider(
                                  color: Colors.white,
                                  thickness: 0.2,
                                ),
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
                if (widget.showSeeAllButton)
                  !_seeAll
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _seeAll = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                locale.btnSeeAll,
                                style: TextStyles.sourceSansSB.body2
                                    .colour(Colors.white),
                              ),
                              SizedBox(
                                width: SizeConfig.padding8,
                              ),
                              Transform.rotate(
                                  angle: math.pi / 2,
                                  child: SvgPicture.asset(
                                    Assets.chevRonRightArrow,
                                    color: UiConstants.primaryColor,
                                  ))
                            ],
                          ),
                        )
                      : const SizedBox()
              ],
            ),
          );
  }
}
