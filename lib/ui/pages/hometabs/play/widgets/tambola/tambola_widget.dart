import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/tambola_ticket_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/tambola/tambola_controller.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../util/styles/ui_constants.dart';

class TambolaWidget extends StatelessWidget {
  const TambolaWidget(this.tambolaController, this.model, {Key key})
      : super(key: key);
  final TambolaWidgetController tambolaController;
  final TambolaCardModel model;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tambolaController,
      builder: (_, __) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.pageHorizontalMargins / 2,
                bottom: 11,
                left: SizeConfig.pageHorizontalMargins + 10),
            child: Text(
              'Tambola',
              style: TextStyles.rajdhaniSB.body1,
            ),
          ),
          Container(
            height: SizeConfig.screenHeight * 0.22,
            margin: EdgeInsets.only(
                right: SizeConfig.pageHorizontalMargins,
                bottom: SizeConfig.pageHorizontalMargins,
                left: SizeConfig.pageHorizontalMargins),
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            decoration: BoxDecoration(
              color: UiConstants.kSnackBarPositiveContentColor,
              borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.roundness24),
              ),
            ),
            child: Builder(builder: (_) {
              switch (tambolaController.tambolaWidgetType) {
                case TambolaWidgetType.Banner:
                  return _BannerWidget(model.game.route);
                case TambolaWidgetType.Timer:
                case TambolaWidgetType.Tickets:
                  return GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.tambolaGameCard,
                          properties: AnalyticsProperties
                              .getDefaultPropertiesMap(extraValuesMap: {
                            "Time left for draw Tambola (mins)":
                                AnalyticsProperties.getTimeLeftForTambolaDraw(),
                            "Tambola Tickets Owned":
                                AnalyticsProperties.getTabolaTicketCount(),
                          }));
                      AppState.delegate.parseRoute(
                        Uri.parse(model.game.route),
                      );
                    },
                    child: _TicketWidget(
                      model,
                      tambolaWidgetType: tambolaController.tambolaWidgetType,
                    ),
                  );
                default:
                  return Container();
              }
            }),
          ),
        ],
      ),
    );
  }
}

class _BannerWidget extends StatelessWidget {
  const _BannerWidget(this.route, {Key key}) : super(key: key);
  final String route;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(Assets.tambola_1cr),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.tambola_title),
              SizedBox(
                height: 12,
              ),
              CustomSaveButton(
                onTap: () {
                  Haptic.vibrate();
                  locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.tambolaGameCard,
                      properties: AnalyticsProperties.getDefaultPropertiesMap(
                          extraValuesMap: {
                            "Time left for draw Tambola (mins)":
                                AnalyticsProperties.getTimeLeftForTambolaDraw(),
                            "Tambola Tickets Owned":
                                AnalyticsProperties.getTabolaTicketCount(),
                          }));
                  AppState.delegate.parseRoute(
                    Uri.parse(route),
                  );
                },
                title: 'Start Playing',
                width: SizeConfig.screenWidth * 0.35,
                height: SizeConfig.screenWidth * 0.11,
              )
            ],
          ),
        )
      ],
    );
  }
}

class _TicketWidget extends StatelessWidget {
  const _TicketWidget(this.model, {Key key, @required this.tambolaWidgetType})
      : super(key: key);
  final TambolaWidgetType tambolaWidgetType;
  final TambolaCardModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tambola',
                  style: TextStyles.rajdhaniSB.body1,
                ),
                Text('${model.dailyPicksCount * 7}',
                    style: TextStyles.sourceSans.body4.setOpecity(0.5)),
              ],
            ),
            Text('Win 1 Crore',
                style: TextStyles.sourceSans.body2
                    .colour(UiConstants.kModalSheetMutedTextBackgroundColor))
          ],
        ),
        SizedBox(
          height: 12,
        ),
        DailyPicksTimer(
          replacementWidget: TodayPicksBallsAnimation(
            picksList:
                model.todaysPicks != null ? model.todaysPicks : [-1, -1, -1],
          ),
        ),
        Spacer(),
        if (tambolaWidgetType == TambolaWidgetType.Tickets)
          Text(
            'Next draw at 6 PM',
            style: TextStyles.sourceSans.body4,
          ),
        if (tambolaWidgetType == TambolaWidgetType.Timer)
          RichText(
            text: TextSpan(
              text: 'Today’s draw matches your',
              style: TextStyles.sourceSans.body4,
              children: [
                TextSpan(
                    text: ' 4 tickets!',
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kWinnerPlayerPrimaryColor))
              ],
            ),
          ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
