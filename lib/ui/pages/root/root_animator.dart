import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:flutter/material.dart';

class RootAnimator extends StatefulWidget {
  const RootAnimator({Key key}) : super(key: key);

  @override
  _RootAnimatorState createState() => _RootAnimatorState();
}

class _RootAnimatorState extends State<RootAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Root(
      controller: _controller,
    );
  }
}
