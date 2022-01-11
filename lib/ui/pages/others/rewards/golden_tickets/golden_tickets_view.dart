import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/hero_router.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_ticket/golden_ticket_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class GoldenTicketsView extends StatelessWidget {
  const GoldenTicketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenTicketsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Golden Tickets",
                ),
                //Container(height: SizeConfig.screenHeight * 0.2),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.padding40),
                        topRight: Radius.circular(SizeConfig.padding40),
                      ),
                      color: Colors.white,
                    ),
                    child: model.goldenTicketList == null
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            itemCount: model.goldenTicketList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 1 / 1,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20),
                            itemBuilder: (ctx, i) {
                              return InkWell(
                                onTap:
                                    // () {
                                    //   AppState.delegate.appState.currentAction =
                                    //       PageAction(
                                    //     page: GoldenTicketViewPageConfig,
                                    //     widget: GoldenTicketView(
                                    //       ticket: model.goldenTicketList[i],
                                    //     ),
                                    //     state: PageState.addWidget,
                                    //   );
                                    // },
                                    () {
                                  AppState.screenStack.add(ScreenItem.dialog);
                                  Navigator.of(AppState
                                          .delegate.navigatorKey.currentContext)
                                      .push(
                                    HeroDialogRoute(
                                      builder: (context) {
                                        return _AddTodoPopupCard(
                                          ticket: model.goldenTicketList[i],
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: GoldenTicketCard(
                                  ticket: model.goldenTicketList[i],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GoldenTicketCard extends StatelessWidget {
  final GoldenTicket ticket;
  final bool enabled;
  GoldenTicketCard({this.ticket, this.enabled = false});
  @override
  Widget build(BuildContext context) {
    return Hero(
        key: Key(ticket.createdOn.toString()),
        tag: ticket.createdOn.toString(),
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              image: DecorationImage(
                  image: AssetImage("images/gticket.png"), fit: BoxFit.cover),
            ),
            height: SizeConfig.screenWidth * 0.6,
            width: SizeConfig.screenWidth * 0.6,
          ),
        )
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(32),
        //   child: Scratcher(
        //     enabled: enabled,
        //     image: Image.asset(
        //       "images/gticket.png",
        //       fit: BoxFit.cover,
        //     ),
        //     child: Container(
        //       height: SizeConfig.screenWidth * 0.6,
        //       color: Colors.white,
        //       width: SizeConfig.screenWidth * 0.6,
        //       margin: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
        //     ),
        //   ),
        // ),
        );
  }
}

final scratchKey = GlobalKey<ScratcherState>();

class _AddTodoPopupCard extends StatefulWidget {
  /// {@macro add_todo_popup_card}
  final GoldenTicket ticket;
  _AddTodoPopupCard({this.ticket});

  @override
  State<_AddTodoPopupCard> createState() => _AddTodoPopupCardState();
}

class _AddTodoPopupCardState extends State<_AddTodoPopupCard> {
  bool viewScratcher = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        viewScratcher = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(
                color: Colors.black,
              ),
            ),
            Spacer(),
            viewScratcher
                ? Hero(
                    key: Key(widget.ticket.createdOn.toString()),
                    tag: widget.ticket.createdOn.toString(),
                    createRectTween: (begin, end) {
                      return CustomRectTween(begin: begin, end: end);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Scratcher(
                        brushSize: 50,
                        threshold: 40,
                        key: scratchKey,
                        onThreshold: () {
                          scratchKey.currentState.reveal();

                          BaseUtil.showPositiveAlert("Reward Redeemed",
                              "Prizes will be credited soon to your account");
                        },
                        image: Image.asset(
                          "images/gticket.png",
                          fit: BoxFit.cover,
                        ),
                        child: Card(
                          child: Container(
                            height: SizeConfig.screenWidth * 0.6,
                            color: Colors.white,
                            width: SizeConfig.screenWidth * 0.6,
                            margin: EdgeInsets.only(
                                left: SizeConfig.pageHorizontalMargins),
                          ),
                        ),
                      ),
                    ),
                  )
                : GoldenTicketCard(
                    ticket: widget.ticket,
                    enabled: true,
                  ),
            // Hero(
            //   tag: widget.ticket.createdOn.toString(),
            //   createRectTween: (begin, end) {
            //     return CustomRectTween(begin: begin, end: end);
            //   },
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(16),
            //     child: Card(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(16),
            //         ),
            //         child: Scratcher(
            //           key: Key(widget.ticket.createdOn.toString()),
            //           threshold: 40,

            //           image: Image.asset(
            //             "images/gticket.png",
            //             height: SizeConfig.screenWidth * 0.6,
            //             width: SizeConfig.screenWidth * 0.6,
            //             fit: BoxFit.cover,
            //           ),
            //           child: Container(
            //             height: SizeConfig.screenWidth * 0.6,
            //             width: SizeConfig.screenWidth * 0.6,
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(16),
            //             ),
            //             margin: EdgeInsets.only(
            //                 left: SizeConfig.pageHorizontalMargins),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: List.generate(
            //                 widget.ticket.rewards.length,
            //                 (idx) => Text(
            //                     "${widget.ticket.rewards[idx].type}: ${widget.ticket.rewards[idx].value}"),
            //               ),
            //             ),
            //           ),
            //         )
            //         // : Image.asset(
            //         //     "images/gticket.png",
            //         //     width: SizeConfig.screenWidth * 0.8,
            //         //     height: (SizeConfig.screenWidth * 0.8) / 2,
            //         //     fit: BoxFit.cover,
            //         //   )
            //         ),
            //   ),
            // ),
            Spacer(),
            FelloAppBar()
          ],
        ),
      ),
    );
  }
}

class CustomRectTween extends RectTween {
  CustomRectTween({
    @required Rect begin,
    @required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin.left, end.left, elasticCurveValue),
      lerpDouble(begin.top, end.top, elasticCurveValue),
      lerpDouble(begin.right, end.right, elasticCurveValue),
      lerpDouble(begin.bottom, end.bottom, elasticCurveValue),
    );
  }
}
