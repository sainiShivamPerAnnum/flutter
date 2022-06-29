import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
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
        top: SizeConfig.padding32,
        bottom: SizeConfig.padding20,
      ),
      child: Text(
        title,
        style: TextStyles.sourceSansSB.title4,
      ),
    );
  }
}