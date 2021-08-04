// import 'package:felloapp/main.dart';
// import 'package:felloapp/util/size_config.dart';
// import 'package:felloapp/util/ui_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class WalkThroughCompleted extends StatefulWidget {
//   @override
//   _WalkThroughCompletedState createState() => _WalkThroughCompletedState();
// }

// class _WalkThroughCompletedState extends State<WalkThroughCompleted> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               height: SizeConfig.screenHeight * 0.6,
//               width: SizeConfig.screenWidth * 0.98,
//               child: Center(
//                 child:
//                     SvgPicture.asset('images/svgs/walkthrough_completed.svg'),
//               ),
//             ),
//             SizedBox(
//               height: SizeConfig.screenHeight * 0.01,
//             ),
//             Text(
//               'Congratulations !',
//               style: TextStyle(
//                   fontSize: SizeConfig.largeTextSize * 1.5,
//                   color: UiConstants.primaryColor,
//                   fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: SizeConfig.screenHeight * 0.01,
//             ),
//             Container(
//                 width: SizeConfig.screenWidth * 0.9,
//                 child: Text(
//                   'You now know how Fello works ! Let\'s take you to the app where you can Play and Invest.',
//                   style: TextStyle(
//                       color: UiConstants.textColor,
//                       fontSize: SizeConfig.largeTextSize),
//                 )),
//             Expanded(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   width: double.infinity,
//                   height: SizeConfig.blockSizeVertical * 8,
//                   decoration: BoxDecoration(
//                     gradient: new LinearGradient(colors: [
//                       UiConstants.primaryColor,
//                       UiConstants.primaryColor.withBlue(200),
//                     ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
//                   ),
//                   child: Material(
//                     child: MaterialButton(
//                       child: Text(
//                         'Let\'s Go',
//                         style: Theme.of(context).textTheme.button.copyWith(
//                             color: Colors.white,
//                             fontSize: SizeConfig.largeTextSize * 1.1,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       highlightColor: Colors.white30,
//                       splashColor: Colors.white30,
//                       onPressed: () {
//                         backButtonDispatcher.didPopRoute();
//                         backButtonDispatcher.didPopRoute();
//                       },
//                     ),
//                     color: Colors.transparent,
//                     borderRadius: new BorderRadius.circular(30.0),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
