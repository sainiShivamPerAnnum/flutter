import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/play_offer_card.dart';
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
              SizedBox(height: SizeConfig.padding12),
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
                        return OfferCard(
                          model: model,
                          i: i,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
                child: Text(
                  locale.playTrendingGames,
                  style: TextStyles.title3.bold,
                ),
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
