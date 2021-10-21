import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloInfoDialog extends StatelessWidget {
  final String title, subtitle, asset;
  final Widget action;
  final bool showCrossIcon;
  final Widget customContent;
  FelloInfoDialog(
      {this.title,
      this.asset,
      this.subtitle,
      this.customContent,
      this.action,
      this.showCrossIcon});
  @override
  Widget build(BuildContext context) {
    return FelloDialog(
      content: customContent != null
          ? customContent
          : Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                SvgPicture.asset(
                  asset,
                  height: SizeConfig.screenHeight * 0.16,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.04,
                ),
                Text(
                  title,
                  style: TextStyles.title2.bold,
                ),
                SizedBox(height: SizeConfig.padding16),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyles.body2.colour(Colors.grey),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                action
              ],
            ),
      showCrossIcon: showCrossIcon ?? false,
    );
  }
}
