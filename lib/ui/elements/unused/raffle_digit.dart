// import 'dart:async';

// import 'package:felloapp/util/logger.dart';
// import 'package:flutter/material.dart';

// class SingleDigit extends StatefulWidget {
//   final TextStyle textStyle;
//   final BoxDecoration boxDecoration;
//   final int initialValue;

//   _SingleDigitState _state;

//   SingleDigit(
//       {this.boxDecoration: const BoxDecoration(color: Colors.transparent),
//       this.textStyle: const TextStyle(color: Colors.black, fontSize: 22),
//       this.initialValue: 0});

//   @override
//   State<StatefulWidget> createState() {
//     _state =
//         new _SingleDigitState(textStyle, boxDecoration, 0, this.initialValue);
//     return _state;
//   }

//   setValue(newValue) {
//     if (_state != null) {
//       _state._setValue(newValue);
//     }
//   }
// }

// class _SingleDigitState extends State<SingleDigit>
//     with TickerProviderStateMixin {
//   _SingleDigitState(this._textStyle, this._boxDecoration, this.previousValue,
//       this.currentValue);

//   final TextStyle _textStyle;
//   final BoxDecoration _boxDecoration;
//   Log log = new Log('RaffleDigitWidget');

//   int previousValue;
//   int currentValue;

//   Animation<double> animation;
//   AnimationController controller;

//   @override
//   void initState() {
//     super.initState();
//     int x = this.currentValue;
//     this.currentValue = 0;
//     _initAnimation();
//     new Timer(const Duration(seconds: 1), () {
//       setState(() {
//         this.currentValue = x;
//         _initAnimation();
//       });
//     });
//   }

//   _initAnimation() {
//     try {
//       controller = AnimationController(
//           duration: const Duration(milliseconds: 1400), vsync: this);
//       animation = Tween<double>(
//               begin: previousValue.toDouble(), end: currentValue.toDouble())
//           .animate(controller)
//             ..addListener(() {
//               setState(() {});
//             });
//       controller.forward();
//     } catch (e) {
//       log.error('Raffle digit animation breaking');
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }

//   _setValue(int newValue) {
//     this.previousValue = this.currentValue;
//     this.currentValue = newValue;
//     controller.dispose();
//     _initAnimation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size digitSize = _getSingleDigitSize();

//     return Container(
//       decoration: _boxDecoration,
//       child: SizedOverflowBox(
//         alignment: Alignment.topCenter,
//         size: digitSize,
//         child: ClipRect(
//           clipper: CustomDigitClipper(digitSize),
//           child: Transform.translate(
//             offset: Offset(0, -this.animation.value * digitSize.height),
//             child: Column(
//               children: <Widget>[
//                 for (var i = 0; i < 100; i++)
//                   Text(
//                     i.toString(),
//                     style: _textStyle,
//                     textAlign: TextAlign.center,
//                   ) // ADD STYLE TO THE TEXT
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   ///
//   /// Calculates the size of a single digit based on the current text style
//   ///
//   _getSingleDigitSize() {
//     final painter = TextPainter();
//     painter.text = TextSpan(style: _textStyle, text: '90');
//     painter.textDirection = TextDirection.ltr;
//     painter.textAlign = TextAlign.left;
//     painter.textScaleFactor = 1.0;
//     painter.layout();
//     return painter.size;
//   }
// }

// class CustomDigitClipper extends CustomClipper<Rect> {
//   CustomDigitClipper(this.digitSize);

//   final Size digitSize;

//   @override
//   Rect getClip(Size size) {
//     return Rect.fromPoints(
//         Offset.zero, Offset(digitSize.width, digitSize.height));
//   }

//   @override
//   bool shouldReclip(CustomClipper<Rect> oldClipper) {
//     return false;
//   }
// }
