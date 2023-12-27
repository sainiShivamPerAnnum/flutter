// ignore_for_file: lines_longer_than_80_chars

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

typedef _LevelInformation = ({
  String badgeUrl,
  String description,
  String title,
});

class LevelUnlockDialog extends StatelessWidget {
  const LevelUnlockDialog({
    required this.level,
    super.key,
  });

  final SuperFelloLevel level;

  String _getLevelName() {
    return switch (level) {
      SuperFelloLevel.GOOD => 'Good Fello',
      SuperFelloLevel.WISE => 'Wise Fello',
      SuperFelloLevel.SUPER_FELLO => 'Super Fello',
      _ => ''
    };
  }

  Future<void> _onPressed() async {
    locator<UserService>().referralFromNotification = true;
    await AppState.backButtonDispatcher?.didPopRoute();

    final label = _getLevelName();

    await Share.share(
      'I just upgraded to $label on the FELLO app! This gives me access to some great benefits. You can become one too! Come, let\'s save together!\n\n https://fello.in/download/app ',
    );

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.badgeUnlock,
      properties: {
        'level_changed': true,
        'current_level': locator<UserService>().baseUser!.superFelloLevel.name,
      },
    );
  }

  void _onClose() {
    AppState.backButtonDispatcher?.didPopRoute();
  }

  _LevelInformation _levelData() {
    return switch (level) {
      SuperFelloLevel.GOOD => (
          title: 'You are a Good Fello!',
          description: 'You have earned all badges in Good Fello level',
          badgeUrl:
              'https://ik.imagekit.io/9xfwtu0xm/Badges/beginner_fello.svg',
        ),
      SuperFelloLevel.WISE => (
          title: 'You are a Wise Fello!',
          description: 'You have earned all badges in Wise Fello level',
          badgeUrl:
              'https://ik.imagekit.io/9xfwtu0xm/Badges/intermediate_fello.svg',
        ),
      SuperFelloLevel.SUPER_FELLO => (
          title: 'You are a Super Fello!',
          description: 'You have earned all badges in Super Fello level',
          badgeUrl: 'https://ik.imagekit.io/9xfwtu0xm/Badges/supe_fello.svg',
        ),
      SuperFelloLevel.NEW_FELLO => (
          title: '',
          description: '',
          badgeUrl: '',
        )
    };
  }

  @override
  Widget build(BuildContext context) {
    final (:title, :description, :badgeUrl) = _levelData();
    final border = BorderRadius.circular(10);
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding20,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: border,
          gradient: LinearGradient(
            begin: const Alignment(-.5, -1),
            end: const Alignment(.2, 1),
            colors: [
              Colors.white.withOpacity(.25),
              const Color(0xff292929),
              const Color(0xffF5F5F5).withOpacity(.22)
            ],
          ),
        ),
        padding: const EdgeInsets.all(1.5),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff292929),
                borderRadius: border,
              ),
              padding: EdgeInsets.only(
                top: SizeConfig.padding32,
                bottom: SizeConfig.padding30,
                left: SizeConfig.padding28,
                right: SizeConfig.padding28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Congratulations!',
                    style: TextStyles.rajdhaniB.body0.copyWith(
                      fontSize: 28,
                      letterSpacing: .4,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding20,
                  ),
                  SvgPicture.network(
                    badgeUrl,
                    height: SizeConfig.padding132,
                    width: SizeConfig.padding132,
                  ),
                  SizedBox(
                    height: SizeConfig.padding20,
                  ),
                  title.beautify(
                    style: TextStyles.rajdhaniSB.title4.colour(
                      Colors.white,
                    ),
                    alignment: TextAlign.center,
                    boldStyle: TextStyles.rajdhaniSB.title4.colour(
                      UiConstants.yellow3,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding28,
                    ),
                    child: Text(
                      description,
                      style: TextStyles.sourceSans.body3.colour(
                        UiConstants.kTextFieldTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding30,
                  ),
                  SecondaryButton(
                    label: 'TELL EVERYONE NOW',
                    onPressed: _onPressed,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: InkWell(
                onTap: _onClose,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
