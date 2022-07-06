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
        model.loadGameLists();
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
              FelloCoinBar(
                svgAsset: Assets.aTambolaTicket,
                size: SizeConfig.padding20,
              ),
              FelloCoinBar(
                svgAsset: Assets.aFelloToken,
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
                if (model.isGOWCheck)...[
                   GOWCard(
                    model: model,
                    gameIndex: model.isGOWIndex-1,
                  ),
              ],
                GameTitle(title: 'Trending'),
                TrendingGamesSection(model: model),
                GameTitle(title: 'Enjoy more Games'),
                MoreGamesSection(model: model),
                PlayInfoSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
