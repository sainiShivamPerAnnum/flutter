import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/play_offer_card.dart';
import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
import 'package:felloapp/ui/widgets/gameComponents/gameCard.dart';

import 'package:felloapp/ui/widgets/gameComponents/gameShimmer/gameCardShimmer.dart';
import 'package:felloapp/ui/widgets/gameComponents/gameShimmer/moreGamesShimmer.dart';
import 'package:felloapp/ui/widgets/gameComponents/gameShimmer/trendingGamesShimmer.dart';
import 'package:felloapp/ui/widgets/gameComponents/gameTitle.dart';
import 'package:felloapp/ui/widgets/gameComponents/moreGames.dart';
import 'package:felloapp/ui/widgets/gameComponents/titlesGames.dart';
import 'package:felloapp/ui/widgets/gameComponents/trendingGames.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Play extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
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
              'Play',
              style: TextStyles.rajdhaniSB.title1,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              AppBarButton(
                svgAsset: 'assets/svg/frame_svg.svg',
                coin: '20',
                borderColor: Colors.white10,
                screenWidth: SizeConfig.screenWidth * 0.18,
                onTap: () {},
                style: TextStyles.sourceSansSB.body2,
              ),
              AppBarButton(
                svgAsset: 'assets/svg/token_svg.svg',
                coin: '200',
                borderColor: Colors.white10,
                screenWidth: SizeConfig.screenWidth * 0.21,
                onTap: () {},
                style: TextStyles.sourceSansSB.body2,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Haptic.vibrate();
                    AppState.delegate.parseRoute(
                      Uri.parse(BaseUtil.gamesList[0].route),
                    );
                  },
                  child: model.isGamesListDataLoading
                      ? GameCardShimmer()
                      : NewGameCard(
                          thumbnailUrl: model.gamesListData[0].thumbnailUri,
                          gameName: model.gamesListData[0].gameName,
                          playCost: model.gamesListData[0].playCost,
                          prizeAmount: model.gamesListData[0].prizeAmount,
                        ),
                ),
                GameTitle(title: 'Trending'),
                SizedBox(
                  height: SizeConfig.screenWidth * 0.522,
                  width: SizeConfig.screenWidth,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.isGamesListDataLoading
                        ? 3
                        : model.gamesListData.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (ctx, index) {
                      return model.isGamesListDataLoading
                          ? TrendingGamesShimmer()
                          : TrendingGames(
                              thumbnailUrl:
                                  model.gamesListData[index].thumbnailUri,
                              gameName: model.gamesListData[index].gameName,
                              playCost: model.gamesListData[index].playCost,
                              prizeAmount:
                                  model.gamesListData[index].prizeAmount,
                            );
                    },
                  ),
                ),
                GameTitle(title: 'Enjoy more Games'),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 3,
                  itemBuilder: (ctx, index) {
                    return model.isGamesListDataLoading
                        ? MoreGamesShimmer()
                        : MoreGames(
                            thumbnailUrl:
                                model.gamesListData[index].thumbnailUri,
                            gameName: model.gamesListData[index].gameName,
                            playCost: model.gamesListData[index].playCost,
                            prizeAmount: model.gamesListData[index].prizeAmount,
                          );
                  },
                ),
                //What to do on Play?
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenWidth * 0.981,
                  margin:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                  decoration: BoxDecoration(
                    color: Color(0xff333333),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      Text(
                        'What to do on Play?',
                        style: TextStyles.rajdhaniSB.title4,
                      ),
                      SizedBox(
                        height: SizeConfig.padding32,
                      ),
                      TitlesGames(
                        asset: '',
                        whiteText: 'Play Games ',
                        greyText: 'with the\ntokens won',
                        icon: SvgPicture.asset(
                          'assets/svg/play_ludo.svg',
                          height: SizeConfig.padding46,
                          width: SizeConfig.padding38,
                        ),
                        isLast: false,
                      ),
                      TitlesGames(
                        asset: 'assets/svg/play_leaderboard.svg',
                        whiteText: 'Play Games ',
                        greyText: 'with the\ntokens won',
                        icon: SvgPicture.asset(
                          'assets/svg/play_leaderboard.svg',
                          height: SizeConfig.padding70,
                          width: SizeConfig.padding35,
                        ),
                        isLast: false,
                      ),
                      TitlesGames(
                        asset: 'assets/svg/play_gift.svg',
                        whiteText: 'Play Games ',
                        greyText: 'with the\ntokens won',
                        icon: SvgPicture.asset(
                          'assets/svg/play_gift.svg',
                          height: SizeConfig.padding44,
                          width: SizeConfig.padding35,
                        ),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.padding16),
              ],
            ),
          ),
        );
      },
    );
  }
}






