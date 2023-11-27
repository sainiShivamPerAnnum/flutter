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
import 'package:provider/provider.dart';

class ScratchCardsView extends StatelessWidget {
  final bool openFirst;

  const ScratchCardsView({
    super.key,
    this.openFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ScratchCardService>(
      builder: (context, model, properties) {
        model.allScratchCards.forEach((element) {
          debugPrint(
              "PrizeSubtype: ${element.eventType} & RT: ${element.redeemedTimestamp.toString()}");
        });
        return model.isFetchingScratchCards && model.allScratchCards.isEmpty
            ? const Center(child: FullScreenLoader())
            : model.allScratchCards.isEmpty
                ? ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: const [
                      NoRecordDisplayWidget(
                        assetSvg: Assets.noTickets,
                        text: "No Scratch Card won",
                      )
                    ],
                  )
                : GridView.builder(
                    physics: const ClampingScrollPhysics(),
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
                  );
      },
    );
  }
}
