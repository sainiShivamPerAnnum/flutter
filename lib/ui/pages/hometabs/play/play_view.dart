import 'dart:developer';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gow_card.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_title.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/trendingGames.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

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
            category: 'play',
          ),
          body: SingleChildScrollView(
            controller: _controller,
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
                InfoComponent(
                  heading: model.boxHeading,
                  assetList: model.boxAssets,
                  titleList: model.boxTitlles,
                  onStateChanged: () {
                    _controller.animateTo(_controller.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                ),
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
