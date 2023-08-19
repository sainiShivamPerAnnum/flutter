import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class AnimatedDottedRectangle extends StatefulWidget {
  final Widget child;

  const AnimatedDottedRectangle({required this.child, super.key});
  @override
  _AnimatedDottedRectangleState createState() =>
      _AnimatedDottedRectangleState();
}

class _AnimatedDottedRectangleState extends State<AnimatedDottedRectangle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  final int numberOfDotsPerSide = 18;
  final int numberOfVerticalDots = 6;
  // final double dotRadius = SizeConfig.padding4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _dotAnimations = List.generate(
      numberOfDotsPerSide * 2 + numberOfVerticalDots * 2,
      (index) {
        double begin =
            index / (numberOfDotsPerSide * 2 + numberOfVerticalDots * 2);
        double end =
            (index + 1) / (numberOfDotsPerSide * 2 + numberOfVerticalDots * 2);

        return Tween<double>(begin: 0.2, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(begin, end, curve: Curves.easeInOut),
          ),
        );
      },
    );

    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateAnimationSpeed(double speed) {
    _controller.duration = Duration(seconds: speed.toInt());
    _controller.repeat(reverse: true);
  }

  void updateAnimationCurve(Curve curve) {
    _controller.stop();
    _controller.reset();
    _controller.duration = Duration(seconds: _controller.duration!.inSeconds);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: SizeConfig.screenWidth! * 0.75,
        height: SizeConfig.screenWidth! * 0.32,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: _buildDotRow(0),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _buildDotColumn(0),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.flip(flipX: true, child: _buildDotRow(1)),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Transform.flip(flipY: true, child: _buildDotColumn(1))),
            Align(
              alignment: Alignment.center,
              child: widget.child,
            )
          ],
        ),
      ),
      // const SizedBox(height: 20),
      // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //   FilledButton(
      //       child: const Text("Speed Up"),
      //       onPressed: () {
      //         updateAnimationSpeed(3);
      //       }),
      //   const SizedBox(width: 24),
      //   FilledButton(
      //       child: const Text("Change Curve"),
      //       onPressed: () {
      //         updateAnimationCurve(Curves.easeInExpo);
      //       }),
      // ]),
    ]);
  }

  Widget _buildDotRow(int row) {
    return SizedBox(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        numberOfDotsPerSide,
        (index) {
          return AnimatedDot(
            index: index,
            dotAnimation: _dotAnimations[
                ((row == 1 ? 1 : 0) * numberOfVerticalDots) +
                    (row * numberOfDotsPerSide) +
                    index],
            // radius: dotRadius,
          );
        },
      ),
    ));
  }

  Widget _buildDotColumn(int column) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding2),
      height: SizeConfig.screenWidth! * 0.28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          numberOfVerticalDots,
          (index) {
            return AnimatedDot(
              index: index,
              dotAnimation: _dotAnimations[
                  ((column == 0 ? 1 : 2) * numberOfDotsPerSide) +
                      (column * numberOfVerticalDots) +
                      index],
              // radius: dotRadius,
            );
          },
        ),
      ),
    );
  }
}

class AnimatedDot extends AnimatedWidget {
  // final double radius;
  final int index;

  AnimatedDot({
    Key? key,
    required Animation<double> dotAnimation,
    // required this.radius,
    required this.index,
  }) : super(key: key, listenable: dotAnimation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: animation.value,
      child: Container(
        margin: const EdgeInsets.all(2),
        width: index % 2 == 0 ? SizeConfig.padding6 : SizeConfig.padding4,
        height: index % 2 == 0 ? SizeConfig.padding6 : SizeConfig.padding4,
        decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.white : Colors.white38,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
