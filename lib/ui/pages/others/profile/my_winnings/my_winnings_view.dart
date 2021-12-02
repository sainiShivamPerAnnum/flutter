import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/tambola_winners_details.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/share-card.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MyWinningsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) {
        model.getWinningHistory();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Winnings",
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(
                          top: SizeConfig.pageHorizontalMargins),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: "myWinnings",
                            child: WinningsContainer(
                              shadow: false,
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding24),
                          PrizeClaimCard(
                            model: model,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
                            child: Text(
                              "Winning History",
                              style: TextStyles.title3.bold,
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding16),
                          model.isWinningHistoryLoading
                              ? ListLoader()
                              : (model.winningHistory != null &&
                                      model.winningHistory.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.pageHorizontalMargins /
                                                  4),
                                      child: Column(
                                        children: List.generate(
                                          model.winningHistory.length,
                                          (i) => Theme(
                                            data: ThemeData().copyWith(
                                                dividerColor: Colors.grey[50]),
                                            child: ExpansionTile(
                                              expandedCrossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              expandedAlignment:
                                                  Alignment.centerLeft,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom:
                                                          SizeConfig.padding8),
                                                  padding: EdgeInsets.only(
                                                    left: SizeConfig
                                                            .pageHorizontalMargins +
                                                        SizeConfig.padding20 *
                                                            2 +
                                                        SizeConfig.padding8,
                                                    right: SizeConfig
                                                            .pageHorizontalMargins /
                                                        2,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text("Type: "),
                                                              Text((model.winningHistory[i].redeemType !=
                                                                          null &&
                                                                      model.winningHistory[i]
                                                                              .redeemType !=
                                                                          "")
                                                                  ? "REDEMPTION"
                                                                  : "CREDIT"),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: SizeConfig
                                                                  .padding4),
                                                          Row(
                                                            children: [
                                                              Text("Status: "),
                                                              Text(model
                                                                      .winningHistory[
                                                                          i]
                                                                      .tranStatus ??
                                                                  "COMPLETED"),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      if (model
                                                                  .winningHistory[
                                                                      i]
                                                                  .redeemType !=
                                                              null &&
                                                          model.winningHistory[i]
                                                                  .redeemType !=
                                                              "")
                                                        InkWell(
                                                          onTap: () => model.showPrizeDetailsDialog(
                                                              model
                                                                      .winningHistory[
                                                                          i]
                                                                      .redeemType ??
                                                                  "",
                                                              model.winningHistory[i]
                                                                      .amount
                                                                      .abs() ??
                                                                  0.0),
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    SizeConfig
                                                                        .padding12,
                                                                vertical:
                                                                    SizeConfig
                                                                        .padding8),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color: UiConstants
                                                                  .primaryColor,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  Assets.plane,
                                                                  color: Colors
                                                                      .white,
                                                                  width: SizeConfig
                                                                      .padding12,
                                                                ),
                                                                SizedBox(
                                                                    width: SizeConfig
                                                                        .padding8),
                                                                Text(
                                                                  "Share",
                                                                  style: TextStyles
                                                                      .body3
                                                                      .colour(Colors
                                                                          .white),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                              textColor: Colors.black,
                                              leading: CircleAvatar(
                                                radius: SizeConfig.padding24,
                                                backgroundColor: model
                                                    .getWinningHistoryLeadingBg(
                                                        model.winningHistory[i]
                                                                .redeemType ??
                                                            ""),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      SizeConfig.padding12),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 2,
                                                            offset:
                                                                Offset(4, 4),
                                                            spreadRadius: 2,
                                                          )
                                                        ]),
                                                    child: Image.asset(model
                                                        .getWinningHistoryLeadingImage(
                                                            model.winningHistory[i]
                                                                    .redeemType ??
                                                                "")),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                model.getWinningHistoryTitle(
                                                    model.winningHistory[i]),
                                                style: TextStyles.body2.bold,
                                              ),
                                              subtitle: Row(
                                                children: [
                                                  Text(
                                                    DateFormat("dd MMM, yyyy")
                                                        .format(model
                                                            .winningHistory[i]
                                                            .timestamp
                                                            .toDate()),
                                                    style: TextStyles.body3
                                                        .colour(Colors.grey),
                                                  ),
                                                  SizedBox(width: 10),
                                                  if (model.winningHistory[i]
                                                          .tranStatus ==
                                                      "PROCESSING")
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.yellow,
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2),
                                                      child: Text(
                                                        model.winningHistory[i]
                                                            .tranStatus,
                                                        style: TextStyles
                                                            .body4.bold
                                                            .colour(
                                                                Colors.white),
                                                      ),
                                                    )
                                                ],
                                              ),
                                              trailing: Text(
                                                (model.winningHistory[i]
                                                                .amount >
                                                            0
                                                        ? ""
                                                        : "-") +
                                                    " ₹ " +
                                                    "${model.winningHistory[i].amount.abs()}",
                                                style: TextStyles.body2.bold
                                                    .colour(
                                                        model.winningHistory[i]
                                                                    .amount >
                                                                0
                                                            ? UiConstants
                                                                .primaryColor
                                                            : Colors.blue[700]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: NoRecordDisplayWidget(
                                        asset: Assets.noTransaction,
                                        text: "No Winning History yet",
                                      ),
                                    ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
