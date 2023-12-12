import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeUnlockDialog extends StatelessWidget {
  const BadgeUnlockDialog({
    required this.badgeInformation,
    super.key,
  });

  final BadgeLevelInformation badgeInformation;

  Future<void> _onPressed() async {
    locator<UserService>().referralFromNotification = true;
    await AppState.backButtonDispatcher?.didPopRoute();
    final action = badgeInformation.ctaAction;

    if (action != null) {
      await ActionResolver.instance.resolve(action);
    }
  }

  void _onClose() {
    AppState.backButtonDispatcher?.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
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
                    badgeInformation.badgeurl,
                    height: SizeConfig.padding132,
                    width: SizeConfig.padding132,
                  ),
                  SizedBox(
                    height: SizeConfig.padding20,
                  ),
                  badgeInformation.title.beautify(
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
                      badgeInformation.barHeading,
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
