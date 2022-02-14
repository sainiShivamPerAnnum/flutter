import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_milestones/golden_milestones_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timelines/timelines.dart';

class GoldenMilestonesView extends StatelessWidget {
  const GoldenMilestonesView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenMilestonesViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Golden Milstones",
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await model.fetchMilestones();
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.padding40),
                          topRight: Radius.circular(SizeConfig.padding40),
                        ),
                        color: Colors.white,
                      ),
                      child: model.state == ViewState.Busy
                          ? ListLoader()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: SizeConfig.pageHorizontalMargins),
                                Text("Your Upcoming Rewards",
                                    style: TextStyles.title4),
                                SizedBox(height: SizeConfig.padding2),
                                Text(
                                    "Keep on reaching milestones and win fun rewards!",
                                    style: TextStyles.body3),
                                //SizedBox(height: SizeConfig.padding12),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     shape: BoxShape.circle,
                                //     border: Border.all(
                                //         color: UiConstants.primaryColor,
                                //         width: SizeConfig.padding2),
                                //   ),
                                //   padding:
                                //       EdgeInsets.all(SizeConfig.padding4),
                                //   child: ProfileImageSE(
                                //       radius: SizeConfig.padding16),
                                // ),
                                model.milestones == null
                                    ? ListLoader()
                                    : (model.milestones.isEmpty
                                        ? NoRecordDisplayWidget()
                                        :
                                        // MilestonePath(
                                        //     data: model.milestones,
                                        //   )
                                        Expanded(
                                            child: ListView.builder(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        SizeConfig.padding20),
                                                itemCount:
                                                    model.milestones.length,
                                                itemBuilder: (ctx, index) {
                                                  var data = model.milestones;
                                                  return InkWell(
                                                    onTap: () => data[index]
                                                            .isCompleted
                                                        ? () {}
                                                        : model
                                                            .navigateMilestones(
                                                                data[index]
                                                                    .actionUri),
                                                    child: Card(
                                                      elevation: 0,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(SizeConfig
                                                                .roundness24),
                                                      ),
                                                      borderOnForeground: false,
                                                      shadowColor: data[index]
                                                              .isCompleted
                                                          ? UiConstants
                                                              .primaryLight
                                                          : Colors.white,
                                                      margin: EdgeInsets.only(
                                                          top: SizeConfig
                                                              .padding24),
                                                      child: Container(
                                                          // height: SizeConfig.padding64,

                                                          decoration:
                                                              BoxDecoration(
                                                            color: data[index]
                                                                    .isCompleted
                                                                ? UiConstants
                                                                    .primaryLight
                                                                    .withOpacity(
                                                                        0.5)
                                                                : Colors
                                                                    .grey[100],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    SizeConfig
                                                                        .roundness24),
                                                          ),
                                                          padding: EdgeInsets
                                                              .all(SizeConfig
                                                                  .pageHorizontalMargins),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Icon(
                                                              //     data[
                                                              //                 index]
                                                              //             .isCompleted
                                                              //         ? (data[index]
                                                              //                 .showPrize
                                                              //             ? Icons
                                                              //                 .card_giftcard_rounded
                                                              //             : Icons
                                                              //                 .lock_open_rounded)
                                                              //         : Icons
                                                              //             .lock_rounded,
                                                              // color: data[index]
                                                              //         .isCompleted
                                                              //     ? UiConstants
                                                              //         .primaryColor
                                                              //     : Colors
                                                              //         .grey[700]),
                                                              SvgPicture.asset(
                                                                  Assets
                                                                      .gold24K,
                                                                  color: data[
                                                                              index]
                                                                          .isCompleted
                                                                      ? UiConstants
                                                                          .primaryColor
                                                                      : Colors.grey[
                                                                          400]),
                                                              SizedBox(
                                                                  width: SizeConfig
                                                                      .padding8),
                                                              Expanded(
                                                                child: Text(
                                                                  data[index]
                                                                      .title,
                                                                  style: TextStyles.body2.colour(data[
                                                                              index]
                                                                          .isCompleted
                                                                      ? UiConstants
                                                                          .primaryColor
                                                                      : Colors.grey[
                                                                          500]),
                                                                ),
                                                              ),
                                                              if (data[index]
                                                                  .showPrize)
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    if (data[index]
                                                                            .flc !=
                                                                        0)
                                                                      PrizeChip(
                                                                        color: UiConstants
                                                                            .tertiarySolid,
                                                                        svg: Assets
                                                                            .tokens,
                                                                        text:
                                                                            "${data[index].flc}",
                                                                      ),
                                                                    SizedBox(
                                                                        width: SizeConfig
                                                                            .padding16),
                                                                    if (data[index]
                                                                            .amt !=
                                                                        0)
                                                                      PrizeChip(
                                                                        color: UiConstants
                                                                            .primaryColor,
                                                                        png: Assets
                                                                            .moneyIcon,
                                                                        text:
                                                                            "${data[index].amt}",
                                                                      )
                                                                  ],
                                                                ),
                                                            ],
                                                          )),
                                                    ),
                                                  );
                                                }),
                                          )),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
