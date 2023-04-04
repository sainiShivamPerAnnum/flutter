import 'dart:developer';

import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/prediction_leaderboard_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/power_play_matches.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerPlayHome extends StatefulWidget {
  const PowerPlayHome({Key? key}) : super(key: key);

  @override
  State<PowerPlayHome> createState() => _PowerPlayHomeState();
}

class _PowerPlayHomeState extends State<PowerPlayHome> {
  @override
  Widget build(BuildContext context) {
    return BaseView<PowerPlayHomeViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 4), () {});
          },
          child: PowerPlayBackgroundUi(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: model.scrollController,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FAppBar(
                          showAvatar: false,
                          showCoinBar: false,
                          showHelpButton: false,
                          backgroundColor: Colors.transparent,
                          action: Row(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 0.5),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                                ),
                                onPressed: () {},
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    "Invite Friends",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.body5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.padding12,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // color: UiConstants.kArrowButtonBackgroundColor,
                                      border: Border.all(
                                          color:
                                          Colors.white.withOpacity(0.5))),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.question_mark,
                                    color: Colors.white,
                                    size: SizeConfig.padding20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: SvgPicture.network(
                            'https://d37gtxigg82zaw.cloudfront.net/powerplay/logo.svg',
                            height: 95,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                            child: Text(
                              'Predict. Save. Win.',
                              style: TextStyles.sourceSansSB.body2,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PredictionLeaderboard(
                                  matchData: MatchData(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 43,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Text(
                              'Total Won From PowerPlay : ₹100',
                              style: TextStyles.sourceSansSB.body2,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.pageHorizontalMargins),
                          height: SizeConfig.screenWidth! * 0.35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: model.cardCarousel?.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  log('tapped');
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: SizeConfig.padding12),
                                  height: 105,
                                  width: 275,
                                  child: SvgPicture.network(
                                      model.cardCarousel?[index]['imgUrl'] ??
                                          ''),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PowerPlayMatches(
                          model: model,
                        ),
                      ],
                    ),
                  ),
                ),
                if (model.isLoadingMoreCompletedMatches)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: UiConstants.kPowerPlaySecondary,
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.all(SizeConfig.padding12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SpinKitWave(
                            color: Colors.white,
                            size: SizeConfig.padding16,
                          ),
                          SizedBox(height: SizeConfig.padding4),
                          Text(
                            "Fetching more matches, please wait",
                            style: TextStyles.body4.colour(Colors.white),
                          )
                        ],
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
