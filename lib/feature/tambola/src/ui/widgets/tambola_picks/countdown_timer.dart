// // ignore_for_file: library_private_types_in_public_api

// import 'dart:async';

// import 'package:felloapp/core/model/timestamp_model.dart';
// import 'package:felloapp/util/styles/styles.dart';
// import 'package:flutter/material.dart';

// class AppCountdownTimer extends StatefulWidget {
//   final TimestampModel endTime;
//   final Color? backgroundColor;
//   final VoidCallback? onTimerEnd;

//   const AppCountdownTimer({
//     required this.endTime,
//     this.backgroundColor,
//     this.onTimerEnd,
//     super.key,
//   });

//   @override
//   _AppCountdownTimerState createState() => _AppCountdownTimerState();
// }

// class _AppCountdownTimerState extends State<AppCountdownTimer> {
//   Duration? duration;
//   Timer? timer;
//   bool showTimer = true;
//   Duration? timeLeft;
//   // bool countDown = true;

//   @override
//   void initState() {
//     timeLeft = widget.endTime.toDate().difference(DateTime.now());
//     print("Time left: ${timeLeft!.inMinutes}");
//     if (timeLeft!.isNegative) {
//       //Timer ended
//       showTimer = false;
//     } else {
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         timer =
//             Timer.periodic(const Duration(seconds: 1), (_) => updateTimer());
//       });
//     }
//     super.initState();
//   }

//   Future<void> updateTimer() async {
//     timeLeft = widget.endTime.toDate().difference(DateTime.now());
//     if (timeLeft!.inSeconds == 0) {
//       if (widget.onTimerEnd != null) widget.onTimerEnd!();
//       showTimer = false;
//       timer?.cancel();
//     } else {
//       final seconds = timeLeft!.inSeconds.abs() - 1;
//       duration = Duration(seconds: seconds);
//     }
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     duration = null;
//     timer?.cancel();
//     super.dispose();
//   }

//   String twoDigits(int n) => n.toString().padLeft(2, '0');

//   @override
//   Widget build(BuildContext context) {
//     if (showTimer) {
//       final hours = twoDigits(duration?.inHours ?? 0);
//       final minutes = twoDigits(duration?.inMinutes.remainder(60) ?? 0);
//       final seconds = twoDigits(duration?.inSeconds.remainder(60) ?? 0);
//       return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         buildTimeCard(time: hours),
//         const TimerDots(),
//         buildTimeCard(time: minutes),
//         const TimerDots(),
//         buildTimeCard(time: seconds),
//       ]);
//     }
//     return const SizedBox();
//   }

//   Widget buildTimeCard({required String time}) => Container(
//         height: SizeConfig.screenWidth! * 0.16,
//         width: SizeConfig.screenWidth! * 0.16,
//         decoration: BoxDecoration(
//           color: widget.backgroundColor ?? UiConstants.kBackgroundColor,
//           shape: BoxShape.circle,
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           time,
//           style: TextStyles.rajdhaniSB.title2.letterSpace(2),
//         ),
//       );
// }

// class TimerDots extends StatelessWidget {
//   const TimerDots({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: SizeConfig.screenWidth! * 0.14,
//       width: SizeConfig.padding20,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: SizeConfig.padding2,
//             backgroundColor: UiConstants.kTextColor,
//           ),
//           SizedBox(height: SizeConfig.padding8),
//           CircleAvatar(
//             radius: SizeConfig.padding2,
//             backgroundColor: UiConstants.kTextColor2,
//           ),
//         ],
//       ),
//     );
//   }
// }
