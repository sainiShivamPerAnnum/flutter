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
      builder: (_, __) => GestureDetector(
        onTap: () {
          Haptic.vibrate();
          locator<AnalyticsService>().track(
              eventName: AnalyticsEvents.tambolaGameCard,
              properties:
                  AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
                "Time left for draw Tambola (mins)":
                    AnalyticsProperties.getTimeLeftForTambolaDraw(),
                "Tambola Tickets Owned":
                    AnalyticsProperties.getTambolaTicketCount(),
              }));
          if (model.game.route != null)
            AppState.delegate.parseRoute(Uri.parse(model.game.route));
        },
        child: Container(
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
              Radius.circular(SizeConfig.roundness12),
            ),
          ),
          child: Builder(builder: (_) {
            if (model == null) {
              return SizedBox.shrink();
            }
            switch (tambolaController.tambolaWidgetType) {
              case TambolaWidgetType.Banner:
                return _BannerWidget(model.game?.route ?? '');
              case TambolaWidgetType.Timer:
                return _TambolaTimer(
                    controller: tambolaController,
                    route: model.game?.route ?? '');
              case TambolaWidgetType.Tickets:
                return _TicketWidget(
                  model,
                  controller: tambolaController,
                );
              default:
                return Container();
            }
          }),
        ),
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
              _BannerTitle(),
              SizedBox(
                height: 12,
              ),
              CustomSaveButton(
                border: Border.all(color: Color(0xff919193)),
                color: Color(0xff232326),
                title: 'Start Playing',
                width: SizeConfig.screenWidth * 0.40,
                height: SizeConfig.screenWidth * 0.10,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _TambolaTimer extends StatelessWidget {
  _TambolaTimer({Key key, @required this.controller, @required this.route})
      : super(key: key);
  final TambolaWidgetController controller;
  final String route;

  String intToTimeLeft(int value) {
    int h, m, s;

    h = (value ~/ 3600);

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String result = h.toString().padLeft(2, '0') +
        ' : ' +
        m.toString().padLeft(2, '0') +
        ' : ' +
        s.toString().padLeft(2, '0');

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.tambola_1cr_),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Today’s draw at 6 PM ',
                style: TextStyles.sourceSans.body4,
              ),
              Text(
                intToTimeLeft(controller.timeLeftForTambola),
                style: TextStyles.sourceSansB.title4,
              ),
              SizedBox(
                height: 12,
              ),
              CustomSaveButton(
                border: Border.all(color: Color(0xff919193)),
                color: Color(0xff232326),
                title: 'Start Playing',
                width: SizeConfig.screenWidth * 0.40,
                height: SizeConfig.screenWidth * 0.10,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketWidget extends StatelessWidget {
  const _TicketWidget(this.model, {Key key, @required this.controller})
      : super(key: key);
  final TambolaWidgetController controller;
  final TambolaCardModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.tambola_1cr_),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Today’s draws ',
                style: TextStyles.sourceSans.body4,
              ),
              SizedBox(
                height: 8,
              ),
              TodayPicksBallsAnimation(
                picksList: model.todaysPicks ?? [-1, -1, -1],
                ballHeight: SizeConfig.screenHeight * .05,
                ballWidth: SizeConfig.screenHeight * .05,
                margin: EdgeInsets.symmetric(horizontal: 2),
              ),
              SizedBox(
                height: 12,
              ),
              CustomSaveButton(
                border: Border.all(color: Color(0xff919193)),
                color: Color(0xff232326),
                title: 'Start Playing',
                width: SizeConfig.screenWidth * 0.40,
                height: SizeConfig.screenWidth * 0.10,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerTitle extends StatelessWidget {
  const _BannerTitle({Key key, this.space}) : super(key: key);
  final double space;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.tambola_title),
        SizedBox(
          height: space ?? 4,
        ),
        Text(
          'Win ₹1 Crore!',
          style: TextStyles.sourceSansB.body1.colour(Color(0xffFFD979)),
        ),
      ],
    );
  }
}
