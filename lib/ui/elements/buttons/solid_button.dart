import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget {
  const SolidButton(
      {required this.onPress,
      required this.title,
      super.key,
      this.child,
      this.height,
      this.width,
      this.borderRadius,
      this.padding,
      this.bgColor,
      this.textStyle});
  final void Function() onPress;
  final Widget? child;
  final String title;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? SizeConfig.screenWidth! * 0.8,
      child: MaterialButton(
        onPressed: onPress,
        padding:
            padding ?? EdgeInsets.symmetric(vertical: SizeConfig.padding14),
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            side: BorderSide.none),
        color: bgColor ?? Colors.black.withOpacity(0.5),
        child: child ??
            Text(
              title,
              style: TextStyles.rajdhaniB.body1.merge(textStyle),
            ),
      ),
    );
  }
}
