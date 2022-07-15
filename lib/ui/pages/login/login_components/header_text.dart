import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key key,
    this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.rajdhaniB.title2,
      textAlign: TextAlign.center,
    );
  }
}
