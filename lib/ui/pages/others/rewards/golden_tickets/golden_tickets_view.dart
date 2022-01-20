import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/hero_router.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/golden_scratch_card_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_ticket_utils.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GoldenTicketsView extends StatelessWidget {
  const GoldenTicketsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenTicketsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      onModelDispose: (model) {
        model.finish();
      },
      builder: (ctx, model, child) {
        return Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.maxScrollExtent ==
                  scrollInfo.metrics.pixels) {
                model.requestMoreData();
              }
              return true;
            },
            child: RefreshIndicator(
              onRefresh: () => model.refresh(),
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: model.streamController.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.hasError)
                    return new NoRecordDisplayWidget(
                      asset: "Assets.badticket.png",
                      text: "Unable to load your tickets at the moment",
                    );
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: SpinKitWave(
                            color: UiConstants.primaryColor,
                            size: SizeConfig.padding32),
                      );
                    default:
                      log("Items: " + snapshot.data.length.toString());

                      model.arrangeGoldenTickets(snapshot.data);
                      return model.arrangedGoldenTicketList == null ||
                              model.arrangedGoldenTicketList.length == 0
                          ? ListView(
                              shrinkWrap: true,
                              children: [
                                NoRecordDisplayWidget(
                                  assetLottie: Assets.noData,
                                  text: "No Golden Scratch Cards yet",
                                )
                              ],
                            )
                          : GridView.builder(
                              itemCount: model.arrangedGoldenTicketList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: SizeConfig.padding8,
                                      childAspectRatio: 1 / 1,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: SizeConfig.padding8),
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding16,
                                  horizontal: SizeConfig.pageHorizontalMargins),
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    AppState.screenStack.add(ScreenItem.dialog);
                                    Navigator.of(AppState.delegate.navigatorKey
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
                                    ticket: model.arrangedGoldenTicketList[i],
                                    titleStyle: TextStyles.body1,
                                  ),
                                );
                              },
                            );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
