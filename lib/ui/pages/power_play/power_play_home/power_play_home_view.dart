import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/power_play_matches.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/power_play_bg.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../util/locator.dart';

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
            await model.getAllMatched();
          },
          child: PowerPlayBackgroundUi(
            child: Stack(
              children: [
                Column(
                  children: [
                    FAppBar(
                      showAvatar: false,
                      showCoinBar: false,
                      showHelpButton: false,
                      backgroundColor: Colors.transparent,
                      type: FaqsType.onboarding,
                      action: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              locator<PowerPlayService>().referFriend();
                            },
                            child: Container(
                                key: const ValueKey(Constants.HELP_FAB),
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding12,
                                    vertical: SizeConfig.padding6),
                                height: SizeConfig.avatarRadius * 2,
                                decoration: BoxDecoration(
                                  color: UiConstants.kTextFieldColor
                                      .withOpacity(0.4),
                                  border: Border.all(color: Colors.white10),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Invite Friends',
                                      style: TextStyles.body4
                                          .colour(UiConstants.kTextColor),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: model.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: SvgPicture.network(
                                'https://d37gtxigg82zaw.cloudfront.net/powerplay/logo.svg',
                                height: 95,
                              ),
                            ),
                            Center(
                                child: Text(
                              'Invest your Predictions',
                              style: TextStyles.sourceSansSB.body2,
                            )),
                            const SizedBox(
                              height: 10,
                            ),

                            if (model.powerPlayReward > 0) ...[
                              Center(
                                child: Container(
                                  // height: 43,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding16,
                                      vertical: SizeConfig.padding8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Text(
                                    'Total Won From PowerPlay : ₹${model.powerPlayReward}',
                                    style: TextStyles.sourceSansSB.body3,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                            ],

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
                                      Haptic.vibrate();
                                      AppState.delegate!.parseRoute(Uri.parse(
                                          model
                                                  .cardCarousel?[index]
                                                      ["onTapLink"]
                                                  .isEmpty
                                              ? getRoute(index)
                                              : model.cardCarousel?[index]
                                                  ["onTapLink"]));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: SizeConfig.padding12),
                                      // height: SizeConfig.screenHeight! * 0.35,
                                      // width: 275,
                                      child: SvgPicture.network(
                                        model.cardCarousel?[index]['imgUrl'] ??
                                            '',
                                        fit: BoxFit.fill,
                                      ),
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
                  ],
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

  String getRoute(int index) {
    switch (index) {
      case 0:
        return 'powerPlayWelcome';
      case 1:
        return 'powerPlayPrizes';
      case 2:
        return "seasonLeaderboard";
      default:
        return 'powerPlayPrizes';
    }
  }
}
