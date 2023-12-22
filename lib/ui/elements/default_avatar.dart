import 'dart:math' as math;

import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class DefaultAvatar extends StatelessWidget {
  final Size? size;

  const DefaultAvatar({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final rand = 1 + math.Random().nextInt(4);
    return SvgPicture.asset(
      "assets/vectors/userAvatars/AV$rand.svg",
      width: size?.width ?? SizeConfig.iconSize5,
      height: size?.height ?? SizeConfig.iconSize5,
    );
  }
}
