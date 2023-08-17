import 'package:flutter/material.dart';

class AnimatedDottedRectangle extends StatefulWidget {
  @override
  _AnimatedDottedRectangleState createState() =>
      _AnimatedDottedRectangleState();
}

class _AnimatedDottedRectangleState extends State<AnimatedDottedRectangle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  final int numberOfDotsPerSide = 12;
  final int numberOfVerticalDots = 5;
  final double dotRadius = 4.0;

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
        width: 250,
        height: 150,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
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
                child: Transform.flip(
                  flipY: true,
                  child: _buildDotColumn(1),
                )),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FilledButton(
            child: const Text("Speed Up"),
            onPressed: () {
              updateAnimationSpeed(3);
            }),
        const SizedBox(width: 24),
        FilledButton(
            child: const Text("Change Curve"),
            onPressed: () {
              updateAnimationCurve(Curves.easeInExpo);
            }),
      ]),
    ]);
  }

  Widget _buildDotRow(int row) {
    return SizedBox(
        width: 250,
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
                radius: dotRadius,
              );
            },
          ),
        ));
  }

  Widget _buildDotColumn(int column) {
    return SizedBox(
      height: 100,
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
              radius: dotRadius,
            );
          },
        ),
      ),
    );
  }
}

class AnimatedDot extends AnimatedWidget {
  final double radius;
  final int index;

  AnimatedDot({
    Key? key,
    required Animation<double> dotAnimation,
    required this.radius,
    required this.index,
  }) : super(key: key, listenable: dotAnimation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Opacity(
      opacity: animation.value,
      child: Container(
        margin: const EdgeInsets.all(2),
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.white : Colors.white38,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
