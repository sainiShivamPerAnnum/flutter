import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarButton extends StatelessWidget {
  final String? svgAsset, coin;
  final Color? borderColor;
  final VoidCallback? onTap;
  final TextStyle? style;
  final double? size;
  const AppBarButton({
    this.svgAsset,
    this.coin,
    this.borderColor,
    this.onTap,
    this.style,
    this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        margin: EdgeInsets.all(SizeConfig.padding8),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: borderColor ?? Colors.white10),
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              svgAsset!,
              height: size ?? SizeConfig.padding24,
              width: size ?? SizeConfig.padding24,
            ),
            SizedBox(width: SizeConfig.padding4),
            Text(
              coin!,
              style: style ?? TextStyles.sourceSansSB.body2,
            ),
          ],
        ),
      ),
    );
  }
}

class FelloAppBarBackButton extends StatelessWidget {
  final Function? onBackPress;
  final Color color;
  const FelloAppBarBackButton({this.onBackPress, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBackPress as void Function()? ??
          (() => AppState.backButtonDispatcher!.didPopRoute()),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.padding4),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: SizeConfig.iconSize1,
        ),
      ),
    );
  }
}
