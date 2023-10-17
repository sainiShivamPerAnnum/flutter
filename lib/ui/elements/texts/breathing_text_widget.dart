import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:flutter/material.dart';

class CustomAnimText extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  final String? animText;
  final TextStyle? textStyle;

  const CustomAnimText({
    required Animation<double> animation,
    super.key,
    this.animText,
    this.textStyle,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Text(
        animText ?? locale.btnLoading,
        style: textStyle ?? const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

class BreathingText extends StatefulWidget {
  final String? alertText;
  final TextStyle? textStyle;

  const BreathingText({super.key, this.alertText, this.textStyle});

  @override
  _BreathingTextState createState() => _BreathingTextState();
}

// #docregion print-state
class _BreathingTextState extends State<BreathingText>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    animation = Tween<double>(begin: 0.1, end: 1).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  // #enddocregion print-state

  @override
  Widget build(BuildContext context) => CustomAnimText(
      animation: animation,
      animText: widget.alertText,
      textStyle: widget.textStyle);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
// #docregion print-state
}
