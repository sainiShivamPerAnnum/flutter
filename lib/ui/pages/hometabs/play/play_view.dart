import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/play_offer_card.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class Play extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<PlayViewModel>(
      onModelReady: (model) {
        model.loadOfferList();
      },
      builder: (ctx, model, child) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.padding80),
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth * 0.38,
                child: model.isOfferListLoading
                    ? ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        scrollDirection: Axis.horizontal,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness32),
                            child: OfferCard(
                              shimmer: true,
                              model: PromoCardModel(
                                1,
                                null,
                                null,
                                null,
                                null,
                                4281648039,
                                null,
                                1,
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness32),
                            child: OfferCard(
                              shimmer: true,
                              model: PromoCardModel(1, null, null, null, null,
                                  4294942219, null, 1),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        itemCount: model.offerList.length,
                        itemBuilder: (ctx, i) {
                          return OfferCard(
                            model: model.offerList[i],
                          );
                        },
                      ),
              ),
              Transform.translate(
                offset: Offset(0, -SizeConfig.padding16),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                  ),
                  child: Text(
                    locale.playTrendingGames,
                    style: TextStyles.title3.bold,
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(100),
                      // topRight: Radius.circular(100),
                      ),
                  child: ListView(padding: EdgeInsets.zero, children: [
                    GestureDetector(
                      onTap: () => model.openGame(BaseUtil.gamesList[0]),
                      child: GameCard(
                        gameData: BaseUtil.gamesList[0],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => model.openGame(BaseUtil.gamesList[1]),
                      child: GameCard(
                        gameData: BaseUtil.gamesList[1],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.navBarHeight * 2.4,
                    )
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
