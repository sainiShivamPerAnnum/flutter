import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class BlackWhiteButton extends StatelessWidget {
  const BlackWhiteButton({
    required this.onPress,
    required this.title,
    Key? key,
    this.child,
    this.padding,
    this.borderRadius,
    this.height,
    this.width,
    this.textStyle,
  })  : _color = Colors.white,
        _textColor = Colors.black,
        _showBorder = false,
        super(key: key);
  final void Function() onPress;
  final Widget? child;
  final String title;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const BlackWhiteButton.inverse({
    required this.onPress,
    required this.title,
    this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
    this.textStyle,
  })  : _color = null,
        _textColor = Colors.white,
        _showBorder = true;
  final Color? _color;
  final Color _textColor;
  final bool _showBorder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: MaterialButton(
        onPressed: () {
          onPress.call();
        },
        padding: padding,
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            side: _showBorder
                ? const BorderSide(color: Colors.white)
                : BorderSide.none),
        color: _color,
        child: child ??
            Text(
              title,
              style: TextStyles.rajdhaniSB.body3
                  .colour(_textColor)
                  .merge(textStyle),
            ),
      ),
    );
  }
}
