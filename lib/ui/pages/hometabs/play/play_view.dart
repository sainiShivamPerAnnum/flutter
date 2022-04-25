import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/play_offer_card.dart';
import 'package:felloapp/util/haptic.dart';
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
      onModelDispose: (model) {
        model.clear();
      },
      builder: (ctx, model, child) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: SizeConfig.padding80),
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
                              model: PromoCardModel(1, null, null, null, null,
                                  4281648039, null, 1, 0),
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness32),
                            child: OfferCard(
                              shimmer: true,
                              model: PromoCardModel(1, null, null, null, null,
                                  4294942219, null, 1, 0),
                            ),
                          ),
                        ],
                      )
                    : PageView.builder(
                        scrollDirection: Axis.horizontal,
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: SizeConfig.pageHorizontalMargins),
                        controller: model.promoPageController,
                        itemCount: model.offerList.length,
                        itemBuilder: (ctx, i) {
                          return OfferCard(
                            model: model.offerList[i],
                          );
                        },
                      ),
              ),
              Transform.translate(
                offset: Offset(0, -SizeConfig.padding12),
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
                child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding12),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Haptic.vibrate();
                          AppState.delegate
                              .parseRoute(Uri.parse('/cricketHome'));
                        },
                        child: GameCard(
                          gameData: BaseUtil.gamesList[0],
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding6),
                      GestureDetector(
                        onTap: () {
                          Haptic.vibrate();

                          AppState.delegate.parseRoute(Uri.parse('/poolHome'));
                        },
                        child: GameCard(
                          gameData: BaseUtil.gamesList[1],
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding6),
                      GestureDetector(
                        onTap: () {
                          Haptic.vibrate();
                          model.openGame(BaseUtil.gamesList[2]);
                        },
                        child: GameCard(
                          gameData: BaseUtil.gamesList[2],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.navBarHeight * 2.4,
                      )
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
