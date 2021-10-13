import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Play extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<PlayViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return Container(
          child: ListView(
            children: [
              SizedBox(height: SizeConfig.padding24),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth * 0.44,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      model.offerList.length,
                      (i) {
                        return Container(
                          width: SizeConfig.screenWidth * 0.6,
                          height: SizeConfig.screenWidth * 0.34,
                          margin: EdgeInsets.only(
                              left: SizeConfig.pageHorizontalMargins,
                              right: SizeConfig.pageHorizontalMargins / 2),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Assets.germsPattern),
                                fit: BoxFit.cover),
                            color: model.offerList[i].bgColor,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 30,
                                color:
                                    model.offerList[i].bgColor.withOpacity(0.3),
                                offset: Offset(
                                  0,
                                  SizeConfig.screenWidth * 0.15,
                                ),
                                spreadRadius: -44,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 0.07,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  model.offerList[i].title1,
                                  style: TextStyles.title5
                                      .colour(Colors.white)
                                      .bold,
                                ),
                                SizedBox(height: SizeConfig.padding6),
                                Text(
                                  model.offerList[i].title2,
                                  style: TextStyles.title5
                                      .colour(Colors.white)
                                      .bold,
                                ),
                                SizedBox(
                                  height: SizeConfig.padding12,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: SizeConfig.screenWidth * 0.171,
                                  height: SizeConfig.screenWidth * 0.065,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    model.offerList[i].buttonText,
                                    style: TextStyles.body4
                                        .colour(Colors.white)
                                        .bold,
                                  ),
                                )
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
                  SizedBox(width: SizeConfig.pageHorizontalMargins),
                  Text(
                    locale.playTrendingGames,
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
                        gameData: model.gameList[index],
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: SizeConfig.navBarHeight * 2.4,
              )
            ],
          ),
        );
      },
    );
  }
}
