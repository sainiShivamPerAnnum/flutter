import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TambolaLeaderBoard extends StatelessWidget {
  const TambolaLeaderBoard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  String? getWinnersCategory(int index) {
    MatchMap? data = model.winners[index].matchMap;
    List<String> temp = [];
    if ((data?.corners ?? 0) > 0) {
      temp.add('Corner');
    }
    if ((data?.fullHouse ?? 0) > 0) {
      temp.add('Full House');
    }
    if ((data?.oneRow ?? 0) > 0) {
      temp.add('One Row');
    }
    if ((data?.twoRows ?? 0) > 0) {
      temp.add('Two Rows');
    }

    return temp.length > 1
        ? temp.join(", ")
        : temp.isEmpty
            ? ""
            : temp[0];
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.pageHorizontalMargins + SizeConfig.padding12,
          ),
          Text(
            locale.lastWeekWinners,
            style: TextStyles.rajdhaniSB.body0,
          ),
          SizedBox(
            height: SizeConfig.pageHorizontalMargins,
          ),
          model.winners == null
              ? Center(
                  child: Column(
                    children: [
                      FullScreenLoader(size: SizeConfig.padding80),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Text(
                        locale.fetchWinners,
                        style: TextStyles.rajdhaniB.body2.colour(Colors.white),
                      ),
                    ],
                  ),
                )
              : (model.winners.isEmpty
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding24),
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth,
                      child: NoRecordDisplayWidget(
                        topPadding: false,
                        assetSvg: Assets.noWinnersAsset,
                        text: locale.leaderboardUpdateSoon,
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "#",
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            ),
                            SizedBox(width: SizeConfig.padding32),
                            Text(locale.names,
                                style: TextStyles.sourceSans.body3
                                    .colour(UiConstants.kTextColor2)),
                            Spacer(),
                            Text(
                              'Tickets Owned',
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                              maxLines: 2,
                            ),
                            SizedBox(width: SizeConfig.padding16),
                            Text(
                              'Rewards',
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            )
                          ],
                        ),
                        Column(
                          children: List.generate(
                            model.winners.length,
                            (i) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${i + 1}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        ),
                                        SizedBox(width: SizeConfig.padding24),
                                        FutureBuilder(
                                          future: model.getProfileDpWithUid(
                                              model.winners[i].userid),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.waiting ||
                                                !snapshot.hasData) {
                                              return DefaultAvatar();
                                            }

                                            String imageUrl =
                                                snapshot.data as String;

                                            return ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                fit: BoxFit.cover,
                                                width: SizeConfig.iconSize5,
                                                height: SizeConfig.iconSize5,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: SizeConfig.iconSize5,
                                                  height: SizeConfig.iconSize5,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                errorWidget: (a, b, c) {
                                                  return DefaultAvatar();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(width: SizeConfig.padding12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  //"avc",
                                                  model.winners[i].username!
                                                          .replaceAll(
                                                              '@', '.') ??
                                                      "username",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(Colors.white)),
                                              SizedBox(
                                                  height: SizeConfig.padding4),
                                              Text(
                                                getWinnersCategory(i) ?? "",
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(Colors.white
                                                        .withOpacity(0.5)),
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.padding64,
                                        ),
                                        SizedBox(
                                          // color: Colors.red,
                                          width: SizeConfig.padding54,
                                          child: Text(
                                            "${model.winners[i].ticketOwned ?? "00"}",
                                            style: TextStyles.sourceSans.body2
                                                .colour(Colors.white),
                                          ),
                                        ),
                                        // SizedBox(width: SizeConfig.padding16),
                                        SizedBox(
                                          width: SizeConfig.padding64,
                                          // color: Colors.blue,
                                          child: Text(
                                            "₹ ${model.winners[i].amount!.toInt() ?? "00"}",
                                            style: TextStyles.sourceSans.body2
                                                .colour(Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (i + 1 < model.winners.length)
                                    const Divider(
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
                      ],
                    )),
        ],
      ),
    );
  }
}
