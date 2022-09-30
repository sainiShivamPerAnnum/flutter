import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class DepositOptionModalSheet extends StatelessWidget {
  const DepositOptionModalSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.pageHorizontalMargins * 2),
      child: Column(children: [
        SizedBox(
          height: SizeConfig.padding80,
        )
      ]),
    );
  }
}
