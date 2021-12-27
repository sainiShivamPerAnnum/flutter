

// class SummaryCardsView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<SummaryCardsViewModel>(
//       onModelReady: (model) => model.init(),
//       builder: (ctx, model, child) {
//         if (model.state == ViewState.Busy)
//           return SizedBox();
//         else
//           return SizedBox();
//       },
//     );
//   }
// }

// class SummaryCards extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Widget _widget;
//     if (!fetchedFlag || !drawFetchedFlag) {
//       _widget = SizedBox();
//     } else if (boards == null || count == 0) {
//       _widget = SizedBox();
//     } else {
//       if (!_isTicketSummaryLoaded)
//         ticketSummaryData = _getTambolaTicketsSummary();

//       _widget = ticketSummaryData.isEmpty
//           ? SizedBox()
//           : Container(
//               height: SizeConfig.screenWidth * 0.36,
//               width: SizeConfig.screenWidth,
//               margin: EdgeInsets.symmetric(
//                   vertical: SizeConfig.blockSizeHorizontal * 2),
//               child: PageView(
//                 controller: _summaryController,
//                 physics: BouncingScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 children: List.generate(
//                   ticketSummaryData.length,
//                   (index) => Container(
//                     width: SizeConfig.screenWidth,
//                     alignment: Alignment.center,
//                     child: Container(
//                       margin: ticketSummaryData.length == 1
//                           ? EdgeInsets.all(0)
//                           : EdgeInsets.only(
//                               right: SizeConfig.blockSizeHorizontal * 3),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: ticketSummaryData[index].color,
//                         image: DecorationImage(
//                           image: NetworkImage(ticketSummaryData[index].bgAsset),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color:
//                               ticketSummaryData[index].color.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(
//                             SizeConfig.globalMargin,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 ticketSummaryData[index].data[0].title,
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.mediumTextSize * 1.2,
//                                   color: Colors.white,
//                                   height: 1.6,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   AppState.delegate.appState.currentAction =
//                                       PageAction(
//                                     state: PageState.addWidget,
//                                     page: TSummaryDetailsPageConfig,
//                                     widget: SummaryTicketsDisplay(
//                                       summary: ticketSummaryData[index],
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   width: SizeConfig.screenWidth * 0.3,
//                                   alignment: Alignment.center,
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 10),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.white,
//                                     ),
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                   child: Text(
//                                     ticketSummaryData[index].data.length == 1
//                                         ? "Show ticket(s)"
//                                         : "Show All",
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.mediumTextSize,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//     }
//     return _widget;
//   }
// }
