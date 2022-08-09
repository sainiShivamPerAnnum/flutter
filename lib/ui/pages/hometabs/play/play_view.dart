import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gow_card.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_title.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/trendingGames.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

import 'play_components/more_games_section.dart';

class Play extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<PlayViewModel>(
      onModelReady: (model) {
        model.init();
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              ' Play',
              style: TextStyles.rajdhaniSB.title1,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              // FelloCoinBar(
              //   svgAsset: Assets.aTambolaTicket,
              //   size: SizeConfig.padding20,
              // ),
              FelloCoinBar(
                svgAsset: Assets.aFelloToken,
              ),
              SizedBox(
                width: SizeConfig.padding20,
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  AppState.delegate.appState.currentAction = PageAction(
                    page: Level2ViewPageConfig,
                    state: PageState.addPage,
                  );
                },
              ),
              SizedBox(
                width: SizeConfig.padding20,
              )
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GOWCard(
                  model: model,
                ),
                GameTitle(title: 'Trending'),
                TrendingGamesSection(model: model),
                GameTitle(title: 'Enjoy more Games'),
                MoreGamesSection(model: model),
// <<<<<<< HEAD
//                 PlayInfoSection(),
//                 SizedBox(
//                   height: SizeConfig.screenHeight * 0.16,
//                 )
// =======
                InfoComponent(
                  heading: model.boxHeading,
                  assetList: model.boxAssets,
                  titleList: model.boxTitlles,
                ),
                SizedBox(
                  height: SizeConfig.padding64,
                ),
// >>>>>>> campaign4.0
              ],
            ),
          ),
        );
      },
    );
  }
}
