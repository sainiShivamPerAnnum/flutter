// import 'package:felloapp/feature/tambola/src/ui/widgets/tambola_picks/current_picks.dart';
// import 'package:felloapp/ui/elements/page_views/height_adaptive_pageview.dart';
// import 'package:felloapp/util/styles/styles.dart';
// import 'package:flutter/material.dart';

// import 'weekly_picks.dart';

// class PicksCardView extends StatefulWidget {
//   const PicksCardView({super.key});

//   @override
//   State<PicksCardView> createState() => _PicksCardViewState();
// }

// class _PicksCardViewState extends State<PicksCardView> {
//   PageController? controller;
//   int _tabNo = 0;
//   bool isShowingAllPicks = false;
//   double titleOpacity = 1.0;
//   double _tabPosWidthFactor = 0;

//   double get tabPosWidthFactor => _tabPosWidthFactor;

//   int get tabNo => _tabNo;

//   set tabNo(value) {
//     setState(() {
//       _tabNo = value;
//     });
//   }

//   set tabPosWidthFactor(value) {
//     setState(() {
//       _tabPosWidthFactor = value;
//     });
//   }

//   void switchTab(int tab) {
//     if (tab == tabNo) return;

//     tabPosWidthFactor = tabNo == 0
//         ? SizeConfig.screenWidth! / 2 - SizeConfig.pageHorizontalMargins
//         : SizeConfig.pageHorizontalMargins;

//     controller!.animateToPage(
//       tab,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.linear,
//     );
//     tabNo = tab;
//   }

//   @override
//   void initState() {
//     controller = PageController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: SizeConfig.screenWidth,
//       decoration: BoxDecoration(
//         color: UiConstants.kSnackBarPositiveContentColor,
//         borderRadius: BorderRadius.all(
//           Radius.circular(SizeConfig.roundness12),
//         ),
//       ),
//       padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.only(left: 15),
//                   child: TextButton(
//                     onPressed: () => switchTab(0),
//                     child: Text(
//                       "Today's Picks",
//                       style: TextStyles.sourceSansSB.body1
//                           .colour(UiConstants.titleTextColor)
//                           .setOpacity(tabNo == 0
//                               ? 1
//                               : 0.6), // TextStyles.sourceSansSB.body1,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.only(right: 15),
//                   child: TextButton(
//                     onPressed: () => switchTab(1),
//                     child: Text(
//                       'Weekly Picks',
//                       style: TextStyles.sourceSansSB.body1
//                           .colour(UiConstants.titleTextColor)
//                           .setOpacity(tabNo == 1
//                               ? 1
//                               : 0.6), //tyle: TextStyles.sourceSansSB.body1,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Row(
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 500),
//                 height: 5,
//                 width: tabPosWidthFactor,
//               ),
//               Container(
//                 height: 5,
//                 width: SizeConfig.screenWidth! / 2 -
//                     SizeConfig.pageHorizontalMargins * 2,
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(5))),
//               )
//             ],
//           ),
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 500),
//             curve: Curves.easeInCubic,
//             height: tabNo == 0 ? SizeConfig.padding32 : SizeConfig.padding16,
//           ),
//           HeightAdaptivePageView(
//             controller: controller,
//             onPageChanged: switchTab,
//             children: const [CurrentPicks(), WeeklyPicks()],
//           ),
//         ],
//       ),
//     );
//   }
// }
