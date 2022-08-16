import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class BaseAnimation extends StatefulWidget {
  const BaseAnimation({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  State<BaseAnimation> createState() => _BaseAnimationState();
}

class _BaseAnimationState extends State<BaseAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation1, _animation2, _animation3;
  double sw = SizeConfig.screenWidth;
  double sh = SizeConfig.screenHeight;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // END: 430

    _animation1 = Tween(begin: 0.0, end: sw * 1.195).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Cubic(.20, .20, 1, 0),
      ),
    );
    _animation2 = Tween(begin: 0.0, end: sw * 1.195).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Cubic(.10, .4, .50, 0),
      ),
    );

    _animation3 = Tween(begin: 0.0, end: sw * 1.195).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Cubic(0.20, .65, .30, 0),
      ),
    );
    initDelay();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void initDelay() async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            widget.child,
            Visibility(
              visible: _animationController.value != 1,
              child: CustomPaint(
                painter: AnimationPainter(
                  transparentCircleRadius: _animation1.value,
                  outerCircleRadius: _animation2.value,
                  outerThinCircleRadius: _animation3.value,
                ),
                size: Size(sw, sh),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AnimationPainter extends CustomPainter {
  final double transparentCircleRadius,
      outerThinCircleRadius,
      outerCircleRadius;

  AnimationPainter({
    @required this.transparentCircleRadius,
    @required this.outerThinCircleRadius,
    @required this.outerCircleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final paint = Paint();
    path.fillType = PathFillType.evenOdd;
    paint.color = UiConstants.kAnimationBackGroundColor;

    path.addRect(Rect.largest);
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        // radius: radius,
        radius: transparentCircleRadius,
      ),
    );
    canvas.drawPath(path, paint);

    final circlePaint = Paint()
      ..color = UiConstants.kAnimationRingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      outerCircleRadius,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      outerThinCircleRadius,
      circlePaint
        ..strokeWidth = 10
        ..color = UiConstants.kAnimationRingColor.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
