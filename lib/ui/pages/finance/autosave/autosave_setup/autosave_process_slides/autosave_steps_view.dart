import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosaveStepsView extends StatelessWidget {
  final AutosaveProcessViewModel model;

  const AutosaveStepsView({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Steps to Setup Autosave",
          style: TextStyles.rajdhaniSB.title4,
        ),
        SizedBox(height: SizeConfig.padding26),
        AutosaveStepTile(
          image: SvgPicture.asset(
            Assets.floGold,
            height: SizeConfig.screenWidth! * 0.1,
            width: SizeConfig.screenWidth! * 0.1,
          ),
          title: "Choose an asset to Autosave",
          subtitle: Text(
            "You can choose amongst Fello Flo, Digital Gold or both",
            style: TextStyles.sourceSans.body4.colour(
              UiConstants.kTextColor2,
            ),
          ),
        ),
        AutosaveStepTile(
          image: SvgPicture.asset(
            Assets.rupee,
            height: SizeConfig.screenWidth! * 0.0667,
            width: SizeConfig.screenWidth! * 0.0667,
          ),
          title: "Enter amount and choose a frequency",
          subtitle: Text(
            "You can choose daily, weekly and monthly frequencies",
            style: TextStyles.sourceSans.body4.colour(
              UiConstants.kTextColor2,
            ),
          ),
        ),
        AutosaveStepTile(
          image: SvgPicture.asset(
            Assets.upiIcon,
            height: SizeConfig.screenWidth! * 0.064,
            width: SizeConfig.screenWidth! * 0.064,
          ),
          title: "Select a UPI app to setup Autosave",
          subtitle: Text(
            "Choose amongst popular UPI apps, approve mandate and activate autosave!",
            style: TextStyles.sourceSans.body4.colour(
              UiConstants.kTextColor2,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.multiAvatars,
                fit: BoxFit.cover,
                width: SizeConfig.screenWidth! * 0.16,
              ),
              SizedBox(width: SizeConfig.padding12),
              Expanded(
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "500+  users are growing their wealth with Autosave",
                      style: TextStyles.sourceSans.body3,
                    )),
              )
            ],
          ),
        ),
        AppPositiveBtn(
          btnText: "NEXT",
          onPressed: () {
            Haptic.vibrate();
            model.proceed();
          },
          width: SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
        ),
        SizedBox(
          height: SizeConfig.pageHorizontalMargins,
        ),
      ],
    );
  }
}

class AutosaveStepTile extends StatelessWidget {
  final Widget image;
  final String title;
  final Widget subtitle;
  const AutosaveStepTile(
      {required this.image,
      required this.subtitle,
      required this.title,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! * 0.08,
        vertical: SizeConfig.screenWidth! * 0.0533,
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: SizeConfig.screenWidth! * 0.1307,
              height: SizeConfig.screenWidth! * 0.1307,
              color: Colors.black38,
              child: Center(child: image),
            ),
          ),
          SizedBox(
            width: SizeConfig.padding24,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.sourceSans.body2,
                ),
                SizedBox(
                  height: SizeConfig.padding4,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.6,
                  child: subtitle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
