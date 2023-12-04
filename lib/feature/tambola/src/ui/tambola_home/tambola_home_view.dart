/**
 * 
 * // [[DEPRECATED]]
 * 
 */

// import 'package:felloapp/core/enums/page_state_enum.dart';
// import 'package:felloapp/core/enums/view_state_enum.dart';
// import 'package:felloapp/feature/tambola/src/ui/tambola_home/tambola_home_vm.dart';
// import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_view.dart';
// import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/tambola_home_tickets_view.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/ui_pages.dart';
// import 'package:felloapp/ui/architecture/base_view.dart';
// import 'package:felloapp/ui/elements/appbar/appbar.dart';
// import 'package:felloapp/ui/pages/static/loader_widget.dart';
// import 'package:felloapp/util/styles/styles.dart';
// import 'package:flutter/material.dart';

// class TambolaHomeView extends StatefulWidget {
//   const TambolaHomeView({
//     Key? key,
//     this.standAloneScreen = true,
//   }) : super(key: key);
//   final bool standAloneScreen;
//   @override
//   State<TambolaHomeView> createState() => _TambolaHomeViewState();
// }

// class _TambolaHomeViewState extends State<TambolaHomeView> {
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<TambolaHomeViewModel>(
//       onModelReady: (model) => model.init(),
//       onModelDispose: (model) => model.dump(),
//       builder: (context, model, child) => model.state == ViewState.Busy
//           ? SizedBox(
//               width: SizeConfig.screenWidth,
//               child: const FullScreenLoader(),
//             )
//           : Scaffold(
//               backgroundColor: UiConstants.kBackgroundColor,
//               appBar: widget.standAloneScreen
//                   ? FAppBar(
//                       showAvatar: false,
//                       showCoinBar: false,
//                       showHelpButton: false,
//                       action: Row(
//                         children: [
//                           TextButton(
//                             style: TextButton.styleFrom(
//                               side: const BorderSide(
//                                   color: Colors.white, width: 1),
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(25))),
//                             ),
//                             onPressed: () {
//                               AppState.delegate!.appState.currentAction =
//                                   PageAction(
//                                 state: PageState.addWidget,
//                                 page: TambolaNewUser,
//                                 widget: const TambolaHomeDetailsView(
//                                   showPrizeSection: true,
//                                 ),
//                               );
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 10.0, right: 10.0),
//                               child: Text(
//                                 "Prizes",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: SizeConfig.body2,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             width: SizeConfig.padding12,
//                           ),
//                           InkWell(
//                             onTap: () => AppState
//                                 .delegate!.appState.currentAction = PageAction(
//                               state: PageState.addWidget,
//                               page: TambolaNewUser,
//                               widget: const TambolaHomeDetailsView(),
//                             ),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color:
//                                       UiConstants.kArrowButtonBackgroundColor,
//                                   border: Border.all(color: Colors.white)),
//                               padding: const EdgeInsets.all(6),
//                               child: Icon(
//                                 Icons.question_mark,
//                                 color: Colors.white,
//                                 size: SizeConfig.padding20,
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       title: "Tickets",
//                       backgroundColor: UiConstants.kBackgroundColor,
//                     )
//                   : null,
//               body: RefreshIndicator(
//                 color: UiConstants.primaryColor,
//                 backgroundColor: Colors.black,
//                 onRefresh: () async => model.init(),
//                 child: model.activeTambolaCardCount > 0
//                     ? const TambolaHomeTicketsView()
//                     : TambolaHomeDetailsView(
//                         isStandAloneScreen: widget.standAloneScreen,
//                       ),
//               ),
//             ),
//     );
//   }
// }
