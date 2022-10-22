import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameRewards extends StatelessWidget {
  const GameRewards({
    Key key,
    @required this.prizeAmount,
  }) : super(key: key);

  final int prizeAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          Assets.gift,
          height: SizeConfig.padding20,
        ),
        Text(
          'Win upto Rs.$prizeAmount',
          style: TextStyles.sourceSans.body3.colour(Colors.grey.shade600),
        ),
      ],
    );
  }
}
