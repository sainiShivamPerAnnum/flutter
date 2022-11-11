import 'package:flutter/material.dart';

class Blinker extends StatefulWidget {
  final Widget child;

  Blinker({@required this.child});
  @override
  _BlinkerState createState() => _BlinkerState();
}

class _BlinkerState extends State<Blinker> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
