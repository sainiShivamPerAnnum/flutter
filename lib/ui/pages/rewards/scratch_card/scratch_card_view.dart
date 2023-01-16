import 'package:felloapp/core/enums/golden_ticket_service_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/hero_router.dart';
import 'package:felloapp/ui/pages/rewards/detailed_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card_utils.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ScratchCardsView extends StatelessWidget {
  final bool openFirst;
  ScratchCardsView({
    this.openFirst = false,
  });
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<ScratchCardService,
        ScratchCardServiceProperties>(
      properties: [ScratchCardServiceProperties.AllScratchCards],
      builder: (context, model, properties) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.maxScrollExtent ==
                scrollInfo.metrics.pixels) {
              model!.fetchAllScratchCards();
            }

            return true;
          },
          child: model!.isFetchingScratchCards
              ? Center(child: FullScreenLoader())
              : model.allScratchCards.isEmpty
                  ? ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        NoRecordDisplayWidget(
                          assetSvg: Assets.noTickets,
                          text: "No Golden Tickets won",
                        )
                      ],
                    )
                  : GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: model.allScratchCards.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: SizeConfig.padding8,
                          childAspectRatio: 1 / 0.84,
                          crossAxisCount: 2,
                          mainAxisSpacing: 0),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding16,
                          horizontal: SizeConfig.pageHorizontalMargins),
                      itemBuilder: (ctx, i) {
                        return InkWell(
                          onTap: () {
                            AppState.screenStack.add(ScreenItem.dialog);
                            Navigator.of(AppState
                                    .delegate!.navigatorKey.currentContext!)
                                .push(
                              HeroDialogRoute(
                                builder: (context) {
                                  return GTDetailedView(
                                    ticket: model.allScratchCards[i],
                                  );
                                },
                              ),
                            );
                          },
                          child: ScratchCardGridItemCard(
                            ticket: model.allScratchCards[i],
                            titleStyle: TextStyles.body2,
                            titleStyle2: TextStyles.body3,
                            width: SizeConfig.screenWidth! * 0.36,
                            subtitleStyle: TextStyles.body4,
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
