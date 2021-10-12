import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Play extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<PlayViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return Container(
          child: ListView(
            children: [
              SizedBox(height: kToolbarHeight * 0.4),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth * 0.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                      (index) {
                        return Container(
                          width: SizeConfig.screenWidth * 0.64,
                          height: SizeConfig.screenWidth * 0.4,
                          margin: EdgeInsets.only(
                              left: SizeConfig.scaffoldMargin,
                              right: SizeConfig.scaffoldMargin / 2),
                          decoration: BoxDecoration(
                              color: UiConstants.tertiarySolid,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 30,
                                  color: UiConstants.tertiarySolid
                                      .withOpacity(0.3),
                                  offset: Offset(
                                    0,
                                    SizeConfig.screenWidth * 0.15,
                                  ),
                                  spreadRadius: -44,
                                )
                              ]),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "WIN",
                                  style: TextStyles.title5
                                      .colour(Colors.white)
                                      .bold,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "4 Tickets Now",
                                  style: TextStyles.title5
                                      .colour(Colors.white)
                                      .bold,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: SizeConfig.screenWidth * 0.24,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "Explore",
                                    style: TextStyles.body4
                                        .colour(Colors.white)
                                        .bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: SizeConfig.scaffoldMargin),
                  Text(
                    "Trending Games",
                    style: TextStyles.title3.bold,
                  ),
                ],
              ),
              if (model.state == ViewState.Idle)
                Column(
                  children: List.generate(
                    2,
                    (index) => GestureDetector(
                      onTap: () => AppState.delegate.appState.currentAction =
                          PageAction(
                              state: PageState.addPage,
                              page: model.gameList[index].pageConfig),
                      child: GameCard(
                        name: model.gameList[index].gameName,
                        tag: model.gameList[index].tag,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: kBottomNavigationBarHeight * 3.2,
              )
            ],
          ),
        );
      },
    );
  }
}
