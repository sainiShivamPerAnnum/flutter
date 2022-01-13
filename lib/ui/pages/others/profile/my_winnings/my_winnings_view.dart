import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/hero_router.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/prize_claim_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'package:flutter/widgets.dart';

class MyWinningsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MyWinningsViewModel>(
      onModelReady: (model) {
        model.getWinningHistory();
        // model.getGoldenTickets();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          //floatingActionButton: AddTodoButton(),
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Winnings",
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(
                          top: SizeConfig.pageHorizontalMargins),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: "myWinnings",
                            child: WinningsContainer(
                              shadow: false,
                            ),
                          ),
                          PrizeClaimCard(
                            model: model,
                          ),
                          //GoldenRow(model: model),
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.padding24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins),
                                  child: Text(
                                    "Winning History",
                                    style: TextStyles.title3.bold,
                                  ),
                                ),
                                SizedBox(height: SizeConfig.padding16),
                                model.isWinningHistoryLoading
                                    ? ListLoader()
                                    : (model.winningHistory != null &&
                                            model.winningHistory.isNotEmpty
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: SizeConfig
                                                        .pageHorizontalMargins /
                                                    4),
                                            child: Column(
                                              children: List.generate(
                                                model.winningHistory.length,
                                                (i) => Theme(
                                                  data: ThemeData().copyWith(
                                                      dividerColor:
                                                          Colors.grey[50]),
                                                  child: ExpansionTile(
                                                    expandedCrossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    expandedAlignment:
                                                        Alignment.centerLeft,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: SizeConfig
                                                                .padding8),
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .pageHorizontalMargins +
                                                              SizeConfig
                                                                      .padding20 *
                                                                  2 +
                                                              SizeConfig
                                                                  .padding8,
                                                          right: SizeConfig
                                                                  .pageHorizontalMargins /
                                                              2,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "Type: "),
                                                                    Text((model.winningHistory[i].redeemType !=
                                                                                null &&
                                                                            model.winningHistory[i].redeemType !=
                                                                                "")
                                                                        ? "REDEMPTION"
                                                                        : "CREDIT"),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: SizeConfig
                                                                        .padding4),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "Status: "),
                                                                    Text(model
                                                                            .winningHistory[i]
                                                                            .tranStatus ??
                                                                        "COMPLETED"),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            Spacer(),
                                                            if (model
                                                                        .winningHistory[
                                                                            i]
                                                                        .redeemType !=
                                                                    null &&
                                                                model.winningHistory[i]
                                                                        .redeemType !=
                                                                    "")
                                                              InkWell(
                                                                onTap: () => model.showPrizeDetailsDialog(
                                                                    model
                                                                            .winningHistory[
                                                                                i]
                                                                            .redeemType ??
                                                                        "",
                                                                    model.winningHistory[i]
                                                                            .amount
                                                                            .abs() ??
                                                                        0.0),
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          SizeConfig
                                                                              .padding12,
                                                                      vertical:
                                                                          SizeConfig
                                                                              .padding8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    color: UiConstants
                                                                        .primaryColor,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        Assets
                                                                            .plane,
                                                                        color: Colors
                                                                            .white,
                                                                        width: SizeConfig
                                                                            .padding12,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              SizeConfig.padding8),
                                                                      Text(
                                                                        "Share",
                                                                        style: TextStyles
                                                                            .body3
                                                                            .colour(Colors.white),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                    textColor: Colors.black,
                                                    leading: CircleAvatar(
                                                      radius:
                                                          SizeConfig.padding24,
                                                      backgroundColor: model
                                                          .getWinningHistoryLeadingBg(model
                                                                  .winningHistory[
                                                                      i]
                                                                  .redeemType ??
                                                              ""),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            SizeConfig
                                                                .padding12),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                  blurRadius: 2,
                                                                  offset:
                                                                      Offset(
                                                                          4, 4),
                                                                  spreadRadius:
                                                                      2,
                                                                )
                                                              ]),
                                                          child: Image.asset(model
                                                              .getWinningHistoryLeadingImage(model
                                                                      .winningHistory[
                                                                          i]
                                                                      .redeemType ??
                                                                  "")),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      model.getWinningHistoryTitle(
                                                          model.winningHistory[
                                                              i]),
                                                      style:
                                                          TextStyles.body2.bold,
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                                  "dd MMM, yyyy")
                                                              .format(model
                                                                  .winningHistory[
                                                                      i]
                                                                  .timestamp
                                                                  .toDate()),
                                                          style: TextStyles
                                                              .body3
                                                              .colour(
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(width: 10),
                                                        if (model
                                                                .winningHistory[
                                                                    i]
                                                                .tranStatus ==
                                                            "PROCESSING")
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              color:
                                                                  Colors.yellow,
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        2),
                                                            child: Text(
                                                              model
                                                                  .winningHistory[
                                                                      i]
                                                                  .tranStatus,
                                                              style: TextStyles
                                                                  .body4.bold
                                                                  .colour(Colors
                                                                      .white),
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                      model.txnService
                                                          .getFormattedTxnAmount(
                                                              model
                                                                  .winningHistory[
                                                                      i]
                                                                  .amount),
                                                      style: TextStyles
                                                          .body2.bold
                                                          .colour(model
                                                                      .winningHistory[
                                                                          i]
                                                                      .amount >
                                                                  0
                                                              ? UiConstants
                                                                  .primaryColor
                                                              : Colors
                                                                  .blue[700]),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: NoRecordDisplayWidget(
                                              asset: Assets.noTransaction,
                                              text: "No Winning History yet",
                                            ),
                                          ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// class GoldenRow extends StatelessWidget {
//   GoldenRow({this.model});
//   final MyWinningsViewModel model;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: SizeConfig.padding24),
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.pageHorizontalMargins),
//             child: Row(
//               children: [
//                 Text(
//                   "Golden Tickets",
//                   style: TextStyles.title3.bold,
//                 ),
//                 Spacer(),
//                 TextButton(onPressed: () {}, child: Text('Show All'))
//               ],
//             ),
//           ),
//           Container(
//             width: SizeConfig.screenWidth,
//             height: SizeConfig.screenWidth / 4,
//             child: model.goldenTicketList == null
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: model.goldenTicketList.length,
//                     scrollDirection: Axis.horizontal,
//                     padding: EdgeInsets.zero,
//                     itemBuilder: (ctx, i) {
//                       return InkWell(
//                         onTap: () {
//                           AppState.delegate.appState.currentAction = PageAction(
//                             page: GoldenTicketViewPageConfig,
//                             widget: GoldenTicketView(
//                               ticket: model.goldenTicketList[i],
//                             ),
//                             state: PageState.addWidget,
//                           );
//                         },
//                         child: Hero(
//                           tag: i.toString(),
//                           child: Container(
//                             width: SizeConfig.screenWidth / 2,
//                             margin: EdgeInsets.only(
//                                 left: SizeConfig.pageHorizontalMargins),
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: AssetImage("images/gticket.png"),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           )
//         ],
//       ),
//     );
//   }
// }

// /// {@template add_todo_button}
// /// Button to add a new [Todo].
// ///
// /// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
// ///
// /// Uses a [Hero] with tag [_heroAddTodo].
// /// {@endtemplate}
// class AddTodoButton extends StatelessWidget {
//   /// {@macro add_todo_button}
//   const AddTodoButton({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: GestureDetector(
//         onTap: () {
//           AppState.screenStack.add(ScreenItem.dialog);
//           Navigator.of(context).push(HeroDialogRoute(builder: (context) {
//             return const _AddTodoPopupCard();
//           }));
//         },
//         child: Hero(
//           tag: _heroAddTodo,
//           createRectTween: (begin, end) {
//             return CustomRectTween(begin: begin, end: end);
//           },
//           child: Material(
//             color: Colors.amber,
//             elevation: 2,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//             child: const Icon(
//               Icons.add_rounded,
//               size: 56,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Tag-value used for the add todo popup button.
// const String _heroAddTodo = 'add-todo-hero';

// /// {@template add_todo_popup_card}
// /// Popup card to add a new [Todo]. Should be used in conjuction with
// /// [HeroDialogRoute] to achieve the popup effect.
// ///
// /// Uses a [Hero] with tag [_heroAddTodo].
// /// {@endtemplate}
// class _AddTodoPopupCard extends StatelessWidget {
//   /// {@macro add_todo_popup_card}
//   const _AddTodoPopupCard({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Hero(
//           tag: _heroAddTodo,
//           createRectTween: (begin, end) {
//             return CustomRectTween(begin: begin, end: end);
//           },
//           child: Material(
//             color: Colors.amber,
//             elevation: 2,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const TextField(
//                       decoration: InputDecoration(
//                         hintText: 'New todo',
//                         border: InputBorder.none,
//                       ),
//                       cursorColor: Colors.white,
//                     ),
//                     const Divider(
//                       color: Colors.white,
//                       thickness: 0.2,
//                     ),
//                     const TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Write a note',
//                         border: InputBorder.none,
//                       ),
//                       cursorColor: Colors.white,
//                       maxLines: 6,
//                     ),
//                     const Divider(
//                       color: Colors.white,
//                       thickness: 0.2,
//                     ),
//                     FlatButton(
//                       onPressed: () {},
//                       child: const Text('Add'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// {@template custom_rect_tween}
// /// Linear RectTween with a [Curves.easeOut] curve.
// ///
// /// Less dramatic that the regular [RectTween] used in [Hero] animations.
// /// {@endtemplate}
// class CustomRectTween extends RectTween {
//   /// {@macro custom_rect_tween}
//   CustomRectTween({
//     @required Rect begin,
//     @required Rect end,
//   }) : super(begin: begin, end: end);

//   @override
//   Rect lerp(double t) {
//     final elasticCurveValue = Curves.easeOut.transform(t);
//     return Rect.fromLTRB(
//       lerpDouble(begin.left, end.left, elasticCurveValue),
//       lerpDouble(begin.top, end.top, elasticCurveValue),
//       lerpDouble(begin.right, end.right, elasticCurveValue),
//       lerpDouble(begin.bottom, end.bottom, elasticCurveValue),
//     );
//   }
// }
