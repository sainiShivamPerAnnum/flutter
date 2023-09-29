// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:felloapp/core/model/timestamp_model.dart';
// import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
// import 'package:felloapp/feature/tambola/src/ui/widgets/tambola_picks/countdown_timer.dart';
// import 'package:felloapp/util/locator.dart';
// import 'package:felloapp/util/styles/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CurrentPicks extends StatelessWidget {
//   const CurrentPicks({
//     Key? key,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: SizeConfig.screenWidth! * 0.25,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Selector<TambolaService, List<int>?>(
//             selector: (_, tambolaService) => tambolaService.todaysPicks,
//             builder: (context, todaysPicks, child) {
//               return todaysPicks != null &&
//                       !todaysPicks.contains(-1) &&
//                       !todaysPicks.contains(0)
//                   ? TodayPicksBallsAnimation(picksList: todaysPicks)
//                   : child!;
//             },
//             child: AppCountdownTimer(
//               endTime: TimestampModel.fromTimestamp(
//                 Timestamp.fromDate(
//                   DateTime(
//                     DateTime.now().year,
//                     DateTime.now().month,
//                     DateTime.now().day,
//                     18,
//                     0,
//                     10,
//                   ),
//                 ),
//               ),
//               onTimerEnd: () => locator<TambolaService>()
//                   .fetchWeeklyPicks(forcedRefresh: true),
//             ),
//           ),
//           Selector<TambolaService, int>(
//             selector: (context, provider) => provider.matchedTicketCount,
//             builder: (context, totalTicketMatched, child) {
//               if (totalTicketMatched > 0) {
//                 return Container(
//                   padding: EdgeInsets.only(
//                       top: SizeConfig.padding24, bottom: SizeConfig.padding16),
//                   child: Text(
//                     "Today’s draw matches your $totalTicketMatched tickets!",
//                     style: TextStyles.sourceSansSB.body3,
//                   ),
//                 );
//               }
//               return SizedBox(height: SizeConfig.padding28);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TodayPicksBallsAnimation extends StatelessWidget {
//   const TodayPicksBallsAnimation(
//       {Key? key,
//       required this.picksList,
//       this.ballHeight,
//       this.ballWidth,
//       this.margin})
//       : super(key: key);
//   final List<int> picksList;
//   final double? ballHeight;
//   final double? ballWidth;
//   final EdgeInsets? margin;

//   @override
//   Widget build(BuildContext context) {
//     List<int> animationDurations = [2500, 4000, 5000, 3500, 4500];
//     List<Color> ballColorCodes = [
//       const Color(0xffC34B29),
//       const Color(0xffFFD979),
//       const Color(0xffAECCFF),
//     ];

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         picksList.length,
//         (index) => Container(
//           height: ballHeight ?? SizeConfig.screenWidth! * 0.14,
//           margin:
//               margin ?? EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
//           child: AnimatedPicksDisplay(
//             ballHeight: ballHeight ?? SizeConfig.screenWidth! * 0.14,
//             ballWidth: ballWidth ?? SizeConfig.screenWidth! * 0.14,
//             number: picksList[index],
//             animationDurationMilliseconds: animationDurations[index],
//             ballColor: ballColorCodes[index],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AnimatedPicksDisplay extends StatefulWidget {
//   const AnimatedPicksDisplay({
//     Key? key,
//     required this.number,
//     required this.animationDurationMilliseconds,
//     required this.ballColor,
//     required this.ballHeight,
//     required this.ballWidth,
//   }) : super(key: key);

//   final int number;

//   final int animationDurationMilliseconds;
//   final Color ballColor;
//   final double ballHeight;
//   final double ballWidth;

//   @override
//   State<AnimatedPicksDisplay> createState() => _AnimatedPicksDisplayState();
// }

// class _AnimatedPicksDisplayState extends State<AnimatedPicksDisplay> {
//   Random random = Random();

//   List<int> randomList = [];

//   bool isAnimationDone = false;

//   List<Color> ballColorCodes = [
//     const Color(0xffC34B29),
//     const Color(0xffFFD979),
//     const Color(0xffAECCFF),
//   ];

//   ScrollController? _controller;

//   @override
//   void initState() {
//     _controller = ScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (isAnimationDone == false) {
//         Future.delayed(const Duration(milliseconds: 500), _scrollDown);
//       }
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   void _scrollDown() {
//     _controller!.animateTo(
//       _controller!.position.maxScrollExtent,
//       duration: Duration(milliseconds: widget.animationDurationMilliseconds),
//       curve: Curves.fastOutSlowIn,
//     );
//     isAnimationDone = true;
//   }

//   Container _buildBalls(int nToShow, bool showEmpty, Color ballColor) {
//     return Container(
//       width: widget.ballWidth,
//       height: widget.ballHeight,
//       padding: EdgeInsets.all(SizeConfig.padding4),
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//       ),
//       child: Container(
//         padding: EdgeInsets.all(SizeConfig.padding4),
//         width: widget.ballWidth,
//         height: widget.ballHeight,
//         decoration: BoxDecoration(
//           color: ballColor,
//           shape: BoxShape.circle,
//         ),
//         child: Container(
//           padding: EdgeInsets.all(SizeConfig.padding2),
//           decoration: BoxDecoration(
//               color: Colors.transparent,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 0.7)),
//           child: Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Text(
//                 nToShow == -1 || nToShow == 0 ? '-' : nToShow.toString(),
//                 style: TextStyles.rajdhaniB.body2.colour(Colors.black),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     //GEnerating random numbers
//     return Container(
//       width: SizeConfig.screenWidth! * 0.14,
//       height: SizeConfig.screenWidth! * 0.14,
//       decoration: const BoxDecoration(
//         color: UiConstants.kArrowButtonBackgroundColor,
//         shape: BoxShape.circle,
//       ),
//       child: ClipOval(
//         child: SingleChildScrollView(
//           physics: const NeverScrollableScrollPhysics(),
//           controller: _controller,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               isAnimationDone
//                   ? _buildBalls(widget.number, false, widget.ballColor)
//                   : ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: randomList.length,
//                       itemBuilder: (context, index) {
//                         return _buildBalls(
//                             randomList[index],
//                             index == 0,
//                             Colors.primaries[
//                                 Random().nextInt(Colors.primaries.length)]);
//                       },
//                     ),
//               _buildBalls(widget.number, false, widget.ballColor),
//             ],
//           ),
//         ),
//       ),
//     );
//     ;
//   }
// }
