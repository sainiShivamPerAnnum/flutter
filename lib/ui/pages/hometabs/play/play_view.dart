import 'dart:developer';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/navigator/app_state.dart';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gow_card.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/safety_widget.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/trendingGames.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import '../../../widgets/appbar/appbar.dart';
import 'play_components/more_games_section.dart';

class Play extends StatelessWidget {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    log("ROOT: Play view build called");

    return BaseView<PlayViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        log("ROOT: Play view baseview build called");
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: FAppBar(
            type: FaqsType.play,
          ),
          body: SingleChildScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    BaseUtil().openTambolaGame();
                  },
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth * 0.5,
                    decoration: BoxDecoration(
                      color: UiConstants.darkPrimaryColor,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    alignment: Alignment.center,
                    child:
                        Text("TAMBOLA", style: TextStyles.rajdhaniEB.title50),
                  ),
                ),
                TrendingGamesSection(model: model),
                GOWCard(
                  model: model,
                ),
                InfoComponent2(
                  heading: model.boxHeading,
                  assetList: model.boxAssets,
                  titleList: model.boxTitlles,
                ),
                MoreGamesSection(model: model),
                SafetyWidget(),
                SizedBox(
                  height: SizeConfig.padding80,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
