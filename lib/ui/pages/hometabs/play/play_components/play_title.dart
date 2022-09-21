import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class GameTitle extends StatelessWidget {
  final String title;
  const GameTitle({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.padding24,
        bottom: SizeConfig.padding20,
      ),
      child: Text(
        title,
        style: TextStyles.sourceSansSB.title4,
      ),
    );
  }
}

class GameTitleWithSubTitle extends StatelessWidget {
  GameTitleWithSubTitle({@required this.title, this.subtitle, Key key})
      : super(key: key);

  String title;
  String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.pageHorizontalMargins,
        top: SizeConfig.padding35,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.rajdhaniSB.body0,
          ),
          subtitle == null
              ? SizedBox.shrink()
              : SizedBox(
                  height: SizeConfig.padding2,
                ),
          subtitle == null
              ? SizedBox.shrink()
              : Text(
                  subtitle,
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor2),
                ),
        ],
      ),
    );
  }
}
