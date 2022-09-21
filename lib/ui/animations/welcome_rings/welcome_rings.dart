import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularAnim extends StatefulWidget {
  const CircularAnim({Key key}) : super(key: key);

  @override
  State<CircularAnim> createState() => _CircularAnimState();
}

class _CircularAnimState extends State<CircularAnim>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  ScrollController _scrollController;
  Animation<double> _ringOneAnimation;
  Animation<double> _ringTwoAnimation;
  Animation<double> _holeAnimation;
  double _scaleFactor = 1;

  double get scaleFactor => this._scaleFactor;

  set scaleFactor(double value) {
    setState(() {
      this._scaleFactor = value;
    });
  }

  bool _isAnimationInProgress = true;

  get isAnimationInProgress => this._isAnimationInProgress;

  set isAnimationInProgress(value) {
    setState(() {
      this._isAnimationInProgress = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 300);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _ringOneAnimation = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.1, curve: Curves.easeOutCirc));
    _ringTwoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.1, curve: Curves.easeOutCirc),
    );
    _holeAnimation = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1, curve: Curves.easeOutCirc));


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: <Widget>[
          // SingleChildScrollView(
          //   reverse: true,
          //   controller: _scrollController,
          //   child: Container(
          //     width: SizeConfig.screenWidth,
          //     height: SizeConfig.screenWidth * 2.165 * 3,
          //     decoration: const BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage("assets/images/jbg.png"),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
          if (isAnimationInProgress)
            AnimatedScale(
              scale: scaleFactor,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInQuint,
              child: Hole(
                holeAnimation: _holeAnimation,
              ),
            ),
          if (isAnimationInProgress)
            AnimatedScale(
              scale: scaleFactor,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInQuint,
              child: Ring(
                widthFactor: 2,
                ringAnimation: _ringOneAnimation,
              ),
            ),
          if (isAnimationInProgress)
            AnimatedScale(
              scale: scaleFactor,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInQuint,
              child: Ring(
                widthFactor: 1,
                ringAnimation: _ringTwoAnimation,
              ),
            ),

          Align(
            alignment: Alignment.bottomRight,
            child:SafeArea(
              child: CircleAvatar(
              child: FloatingActionButton(
                onPressed: () {
                  _controller.reset();
                  scaleFactor = 1;
                  _controller.forward();

                  // Future.delayed(
                  //   const Duration(milliseconds: 800),
                  //       () {
                  //     _scrollController.animateTo(0,
                  //         duration: const Duration(seconds: 2), curve: Curves.easeOut);
                  //   },
                  // );
                  Future.delayed(const Duration(milliseconds: 600), () {
                    scaleFactor = 5.0;
                  });
                  Future.delayed(const Duration(milliseconds: 1600), () {
                    isAnimationInProgress = false;
                  });
                },
                child: const Icon(Icons.animation, color: Colors.white),
              ),
          ),
            ),)
        ],

    );
  }
}

class Ring extends AnimatedWidget {
  Ring({Key key, this.ringAnimation, this.widthFactor})
      : super(key: key, listenable: ringAnimation);
  final Animation<double> ringAnimation;
  final int widthFactor;
  final width = 10;
  @override
  Widget build(BuildContext context) {
    final maxWidth = width * widthFactor;
    return Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: ringAnimation.value,
        child: Container(
          width: SizeConfig.screenWidth * (widthFactor == 2 ? 0.8 : 1),
          height: SizeConfig.screenWidth * (widthFactor == 2 ? 0.8 : 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: ringAnimation.value * maxWidth,
              color: const Color(0xff067770).withOpacity(
                  (1 - ringAnimation.value)
                      .clamp(widthFactor == 2 ? 0.15 : 0.1, 1)),
            ),
          ),
        ),
      ),
    );
  }
}

class Hole extends AnimatedWidget {
  Hole({Key key, this.holeAnimation})
      : super(key: key, listenable: holeAnimation);

  final Animation<double> holeAnimation;

  Animation get value => (listenable as Animation);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: InvertedCircleClipper(animation: holeAnimation),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D4042),
              Color(0xFF053739),
            ],
          ),
        ),
        // color: const Color(0xff1B262B),
      ),
    );
  }
}

class InvertedCircleClipper extends CustomClipper<Path> {
  InvertedCircleClipper({this.animation}) : super(reclip: animation);
  Animation<double> animation;

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: animation.value * (size.height / 8)))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
