import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class DefaultAvatar extends StatelessWidget {
  final Size size;

  DefaultAvatar({Key key, this.size}) : super(key: key);
  final int rand = 1 + math.Random().nextInt(4);
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/vectors/userAvatars/AV$rand.svg",
      width: size?.width ?? SizeConfig.iconSize5,
      height: size?.height ?? SizeConfig.iconSize5,
    );
  }
}
