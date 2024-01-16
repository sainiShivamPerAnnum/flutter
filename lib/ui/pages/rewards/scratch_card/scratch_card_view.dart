import 'dart:developer';

import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/hero_router.dart';
import 'package:felloapp/ui/pages/rewards/detailed_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/ui/pages/rewards/scratch_card_utils.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
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
        for (final element in model.allScratchCards) {
          debugPrint(
              "PrizeSubtype: ${element.eventType} & RT: ${element.redeemedTimestamp.toString()}");
        }
        return model.isFetchingScratchCards && model.allScratchCards.isEmpty
            ? const Center(child: FullScreenLoader())
            : model.allScratchCards.isEmpty
                ? const NoScratchCardsFound()
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
                      if (i == model.allScratchCards.length - 1 && !model.isLastPageForScratchCards) {
                        model.fetchScratchCards(more: true);
                      }
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

class NoScratchCardsFound extends StatelessWidget {
  const NoScratchCardsFound({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.padding44,
        ),
        const AppImage(Assets.noScratchCards),
        SizedBox(
          height: SizeConfig.padding40,
        ),
        Text(
          locale.noScratchCards,
          style: TextStyles.rajdhaniSB.title4.colour(UiConstants.kTextColor),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        SizedBox(
          width: 290,
          child: Text(
            locale.noScratchCardsSub,
            textAlign: TextAlign.center,
            style: TextStyles.sourceSans.body3
                .colour(UiConstants.kTextFieldTextColor),
          ),
        ),
      ],
    );
  }
}
