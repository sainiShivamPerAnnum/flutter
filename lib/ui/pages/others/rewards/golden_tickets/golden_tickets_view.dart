import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/hero_router.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/golden_scratch_card_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_ticket_utils.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class GoldenTicketsView extends StatelessWidget {
  const GoldenTicketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenTicketsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      onModelDispose: (model) {
        model.disp();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          body: HomeBackground(
            child: Column(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  title: "Golden Rewards",
                ),
                //Container(height: SizeConfig.screenHeight * 0.2),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.roundness40),
                          topRight: Radius.circular(SizeConfig.roundness40),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          WinningsContainer(
                            borderRadius: SizeConfig.roundness12,
                            shadow: false,
                            height: SizeConfig.screenWidth * 0.12,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.pageHorizontalMargins),
                              child: Row(
                                children: [
                                  Text(
                                    "Upcoming reward on your path",
                                    style: TextStyles.body2.bold
                                        .colour(Colors.white),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.navigate_next_outlined,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              AppState.delegate.appState.currentAction =
                                  PageAction(
                                      state: PageState.addPage,
                                      page: GoldenMilestonesViewPageConfig);
                            },
                          ),
                          Expanded(
                              child:
                                  // model.arrangedGoldenTicketList == null
                                  //     ? Center(child: CircularProgressIndicator())
                                  //     :
                                  // (model.arrangedGoldenTicketList.length == 0
                                  //     ? Center(
                                  //         child: NoRecordDisplayWidget(
                                  //           assetLottie: Assets.noData,
                                  //           text: "No Golden Scratch Cards yet",
                                  //         ),
                                  //       )
                                  //     :
                                  NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo.metrics.maxScrollExtent ==
                                  scrollInfo.metrics.pixels) {
                                log("loading more data");
                                model.requestNextPage();
                              }
                              return true;
                            },
                            child: RefreshIndicator(
                              onRefresh: () async => model.refresh(),
                              child: StreamBuilder<List<DocumentSnapshot>>(
                                stream: model.streamController.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<DocumentSnapshot>>
                                        snapshot) {
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return new Text('Loading...');
                                    default:
                                      log("Items: " +
                                          snapshot.data.length.toString());
                                      model.goldenTicketList = snapshot.data
                                          .map((e) => GoldenTicket.fromJson(
                                              e.data(), e.id))
                                          .toList();
                                      model.arrangeGoldenTickets();
                                      return GridView.builder(
                                        itemCount: model
                                            .arrangedGoldenTicketList.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing:
                                                    SizeConfig.padding8,
                                                childAspectRatio: 1 / 1,
                                                crossAxisCount: 2,
                                                mainAxisSpacing:
                                                    SizeConfig.padding8),
                                        padding: EdgeInsets.all(
                                            SizeConfig.pageHorizontalMargins),
                                        itemBuilder: (ctx, i) {
                                          return InkWell(
                                            onTap: () {
                                              AppState.screenStack
                                                  .add(ScreenItem.dialog);
                                              Navigator.of(AppState
                                                      .delegate
                                                      .navigatorKey
                                                      .currentContext)
                                                  .push(
                                                HeroDialogRoute(
                                                  builder: (context) {
                                                    return GoldenScratchCardView(
                                                      ticket: model
                                                          .arrangedGoldenTicketList[i],
                                                      superModel: model,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: GoldenTicketGridItemCard(
                                              ticket: model
                                                  .arrangedGoldenTicketList[i],
                                              titleStyle: TextStyles.body1,
                                            ),
                                          );
                                        },
                                      );
                                  }
                                },
                              ),
                            ),
                          )
                              //),
                              )
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
