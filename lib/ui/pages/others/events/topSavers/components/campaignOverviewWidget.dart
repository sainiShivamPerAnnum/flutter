import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CampaignOverviewWidget extends StatelessWidget {
  final TopSaverViewModel model;
  CampaignOverviewWidget({required this.model});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DAY ${model.weekDay.toString().padLeft(2, '0')}",
                style: TextStyles.rajdhaniB.title5.colour(Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    height: SizeConfig.boxWidthLarge,
                    width: SizeConfig.boxWidthLarge,
                    padding: EdgeInsets.fromLTRB(
                        SizeConfig.padding24, 0, SizeConfig.padding34, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.roundness12),
                      ),
                      color: UiConstants.kDarkBoxColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProfileImageSE(
                          radius: SizeConfig.profileDPSize,
                          reactive: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Your Savings",
                          style: TextStyles.body3.colour(Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Text(
                            model.userDisplayAmount ?? '-',
                            style: TextStyles.body1.bold.colour(Colors.white),
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: SizeConfig.boxWidthLarge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.roundness12),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  SizeConfig.boxDividerMargins,
                                  0,
                                  0,
                                  (SizeConfig.boxDividerMargins) / 2),
                              padding: EdgeInsets.all(SizeConfig.padding16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SizeConfig.roundness12),
                                ),
                                color: UiConstants.kDarkBoxColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Highest\nSaving",
                                    style:
                                        TextStyles.body3.colour(Colors.white),
                                  ),
                                  Flexible(
                                    child: Text(
                                      model.highestSavings ?? '-',
                                      style: TextStyles.body2.bold
                                          .colour(Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //RANK
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  SizeConfig.boxDividerMargins,
                                  (SizeConfig.boxDividerMargins) / 2,
                                  0,
                                  0),
                              padding: EdgeInsets.all(SizeConfig.padding16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SizeConfig.roundness12),
                                ),
                                color: UiConstants.kDarkBoxColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.rewardGameAsset,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Rank",
                                        style: TextStyles.body3
                                            .colour(Colors.white),
                                      ),
                                    ],
                                  )),
                                  Flexible(
                                    child: Text(
                                      model.userRank == 0
                                          ? 'N/A'
                                          : model.userRank
                                              .toString()
                                              .padLeft(2, '0'),
                                      style: TextStyles.body2.bold
                                          .colour(Colors.white),
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
