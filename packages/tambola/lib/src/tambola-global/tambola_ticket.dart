// import 'package:felloapp/core/model/daily_pick_model.dart';
// import 'package:felloapp/core/model/tambola_board_model.dart';
// import 'package:felloapp/util/localization/generated/l10n.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class Ticket extends StatelessWidget {
//   Ticket({
//     super.key,
//     required this.board,
//     required this.calledDigits,
//     this.bestBoards,
//     this.dailyPicks,
//     this.showBestOdds = true,
//   });

//   final TambolaBoard? board;
//   final DailyPick? dailyPicks;
//   final List<TambolaBoard?>? bestBoards;
//   final List<int> calledDigits;
//   final bool showBestOdds;

//   //List<int> markedIndices = [];
//   List<int?> ticketNumbers = [];

//   // markItem(int index) {
//   //   print("marked index : $index");
//   //   if (markedIndices.contains(index))
//   //     markedIndices.remove(index);
//   //   else
//   //     markedIndices.add(index);
//   //   setState(() {});
//   // }

//   Color getColor(int index) {
//     if (calledDigits.contains(ticketNumbers[index])) {
//       return UiConstants.kTicketPeachColor;
//     } else {
//       return Colors.transparent;
//     }
//   }

//   Color getTextColor(int index) {
//     if (calledDigits.contains(ticketNumbers[index])) {
//       return Colors.black;
//     } else {
//       return Colors.white;
//     }
//   }

//   SingleChildRenderObjectWidget markStatus(int index) {
//     if (calledDigits.contains(ticketNumbers[index])) {
//       return Align(
//         alignment: Alignment.center,
//         child: Transform.rotate(
//           angle: -45,
//           alignment: Alignment.center,
//           child: Container(
//             margin: const EdgeInsets.all(2),
//             width: 2,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(100),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }

//   void generateNumberList() {
//     for (int i = 0; i < 3; i++) {
//       for (int j = 0; j < 9; j++) {
//         ticketNumbers.add(board!.tambolaBoard![i][j]);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     S locale = S.of(context);
//     if (ticketNumbers.isEmpty) generateNumberList();

//     return Container(
//       width: SizeConfig.screenWidth,
//       decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(SizeConfig.roundness12),
//           border: Border.all(color: Colors.white.withOpacity(0.7), width: 0.3)),
//       margin: EdgeInsets.symmetric(
//         horizontal: SizeConfig.pageHorizontalMargins,
//       ),
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(SizeConfig.padding8),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     (board!.assigned_time.toDate().day == DateTime.now().day)
//                         ? Shimmer(
//                             gradient: const LinearGradient(
//                               colors: [
//                                 UiConstants.primaryLight,
//                                 UiConstants.primaryColor,
//                                 UiConstants.primaryLight
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             child: Text(
//                               locale.tambolaNew,
//                               style: TextStyles.rajdhaniB.body3,
//                             ),
//                           )
//                         : const SizedBox(),
//                     Row(
//                       children: [
//                         Text(
//                           '#${board!.getTicketNumber()}',
//                           style: TextStyles.sourceSans.body3
//                               .colour(Colors.white.withOpacity(0.7)),
//                         ),
//                         SizedBox(
//                           width: SizeConfig.padding4,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: SizeConfig.padding16),
//                 GridView.builder(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   itemCount: 27,
//                   physics: const NeverScrollableScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 9,
//                     mainAxisSpacing: 2,
//                     crossAxisSpacing: 1,
//                   ),
//                   itemBuilder: (ctx, i) {
//                     return Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: getColor(i),
//                         borderRadius: calledDigits.contains(ticketNumbers[i])
//                             ? null
//                             : BorderRadius.circular(
//                                 SizeConfig.blockSizeHorizontal * 1),
//                         border: Border.all(
//                             color: Colors.white
//                                 .withOpacity(ticketNumbers[i] == 0 ? 0.4 : 0.7),
//                             width: calledDigits.contains(ticketNumbers[i])
//                                 ? 0.0
//                                 : ticketNumbers[i] == 0
//                                     ? 0.5
//                                     : 0.7),
//                         shape: calledDigits.contains(ticketNumbers[i])
//                             ? BoxShape.circle
//                             : BoxShape.rectangle,
//                       ),
//                       child: Stack(
//                         children: [
//                           Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                               ticketNumbers[i] == 0
//                                   ? ""
//                                   : ticketNumbers[i].toString(),
//                               style: TextStyles.rajdhaniB.body3
//                                   .colour(getTextColor(i)),
//                             ),
//                           ),
//                           markStatus(i)
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           // Expanded(
//           //   child: Container(
//           //     padding: EdgeInsets.symmetric(
//           //       horizontal: SizeConfig.padding16,
//           //     ),
//           // child: Odds(dailyPicks, board, bestBoards, showBestOdds),
//           //   ),
//           // ),
//           Padding(
//             padding: EdgeInsets.all(SizeConfig.padding6),
//             child: Text(
//               "${locale.tGeneratedOn}${DateTime.fromMillisecondsSinceEpoch(board!.assigned_time.millisecondsSinceEpoch).day.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(board!.assigned_time.millisecondsSinceEpoch).month.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(board!.assigned_time.millisecondsSinceEpoch).year}",
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: SizeConfig.smallTextSize,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
