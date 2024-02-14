import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SipErrorWidget extends StatelessWidget {
  SipErrorWidget({super.key});
  final locale = locator<S>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: SizeConfig.padding56,
              ),
              Text(
                'Oops, this one is on us',
                style:
                    TextStyles.rajdhaniSB.title4.colour(UiConstants.kTextColor),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Text(
                'Our team is trying to resolve it earliest possible',
                style: TextStyles.sourceSans.body3
                    .colour(UiConstants.kTextFieldTextColor),
              ),
              SizedBox(
                height: SizeConfig.padding42,
              ),
              AppImage(
                Assets.sipError,
                height: SizeConfig.padding252,
              ),
            ],
          ),
          SecondaryButton(
            onPressed: () async =>
                await AppState.backButtonDispatcher!.didPopRoute(),
            label: locale.proceed,
          ),
        ],
      ),
    );
  }
}
