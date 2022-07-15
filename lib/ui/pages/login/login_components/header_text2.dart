import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class HeaderText2 extends StatelessWidget {
  const HeaderText2({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
      textAlign: TextAlign.center,
    );
  }
}
