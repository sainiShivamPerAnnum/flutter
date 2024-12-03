import 'dart:math';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class CustomSwitchNew extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;
  final bool isLoading;

  const CustomSwitchNew({
    required this.initialValue,
    this.isLoading = false,
    this.onChanged,
    this.onTap,
    super.key,
  });

  @override
  State<CustomSwitchNew> createState() => _CustomSwitchNewState();
}

class _CustomSwitchNewState extends State<CustomSwitchNew>
    with SingleTickerProviderStateMixin {
  static const _curve = Curves.easeIn;
  static const _duration = Duration(milliseconds: 300);

  late final AnimationController _animationController;
  late final Animation<Color?> _colorAnimation;
  late final Animation<Size?> _sizeAnimation;

  bool _selected = true;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;

    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: _curve,
    );

    _colorAnimation = ColorTween(
      begin: UiConstants.kTextColor6,
      end: UiConstants.kTextColor,
    ).animate(curvedAnimation);

    _sizeAnimation = SizeTween(
      begin: const Size.square(6),
      end: const Size.square(6),
    ).animate(curvedAnimation);

    if (_selected) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant CustomSwitchNew oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      _selected = widget.initialValue;
      _onValueChanged();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (widget.onChanged != null) {
      setState(() => _selected = !_selected);
      await _onValueChanged();
      widget.onChanged?.call(_selected);
    }

    if (widget.onTap != null) {
      widget.onTap?.call();
    }
  }

  Future<void> _onValueChanged() async {
    if (_selected) {
      await _animationController.forward();
    } else {
      await _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: SizeConfig.padding25,
        width: SizeConfig.padding42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness56),
          color: UiConstants.kTextColor.withOpacity(.25),
        ),
        padding: EdgeInsets.all(SizeConfig.padding4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              alignment:
                  _selected ? Alignment.centerRight : Alignment.centerLeft,
              duration: _duration,
              curve: _curve,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  if (widget.isLoading) {
                    return SizedBox.square(
                      dimension: SizeConfig.padding16,
                      child: const CircularProgressIndicator(
                        color: UiConstants.kTextColor,
                      ),
                    );
                  }

                  return SizedBox.square(
                    dimension: SizeConfig.padding16,
                    child: CustomPaint(
                      painter: _ThumbPainter(
                        _colorAnimation.value!,
                        _sizeAnimation.value!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThumbPainter extends CustomPainter {
  final Color thumbColor;
  final Size circleSize;

  _ThumbPainter(this.thumbColor, this.circleSize);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundCirclePainter = Paint()..color = thumbColor;
    final radius = max(size.height / 2, size.width / 2);
    final rectCenter = (Offset.zero & size).center;
    canvas.drawCircle(
      rectCenter,
      radius,
      backgroundCirclePainter,
    );
  }

  @override
  bool shouldRepaint(covariant _ThumbPainter oldDelegate) =>
      oldDelegate.thumbColor != thumbColor ||
      oldDelegate.circleSize != circleSize;
}
