import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class NoRecordDisplayWidget extends StatelessWidget {
  final String? asset;
  final String? assetSvg;
  final String? assetLottie;
  final String? text;
  final bool topPadding;
  final bool bottomPadding;

  const NoRecordDisplayWidget({
    this.asset,
    this.text,
    this.assetSvg,
    this.assetLottie,
    this.topPadding = true,
    this.bottomPadding = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (topPadding) SizedBox(height: SizeConfig.screenHeight! * 0.1),
        if (asset != null)
          Image.asset(
            asset!,
            height: SizeConfig.screenHeight! * 0.16,
          ),
        if (assetSvg != null)
          SvgPicture.asset(
            assetSvg!,
            height: SizeConfig.screenHeight! * 0.16,
          ),
        if (assetLottie != null)
          Lottie.asset(
            assetLottie!,
            repeat: false,
            height: SizeConfig.screenHeight! * 0.26,
          ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyles.body2.bold.colour(Colors.white),
        ),
        if (bottomPadding) SizedBox(height: SizeConfig.padding16),
      ],
    );
  }
}
