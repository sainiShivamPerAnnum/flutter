import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnersLeaderBoardSE extends StatelessWidget {
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<WinnerService, WinnerServiceProperties>(
        properties: [WinnerServiceProperties.winLeaderboard],
        builder: (context, model, properties) {
          return Container(
            child: DraggableScrollableSheet(
              initialChildSize: 0.24,
              maxChildSize: 0.94,
              minChildSize: 0.24,
              builder: (BuildContext context, myscrollController) {
                return Stack(
                  children: [
                    Positioned(
                      top: -SizeConfig.screenHeight * 0.19,
                      child: Container(
                        height: SizeConfig.screenHeight * 2,
                        // color: Colors.red,
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: SizeConfig.screenWidth,
                                child: CustomPaint(
                                  painter: ModalCustomBackground(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenWidth * 0.12,
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Text(
                          "Leaderboard",
                          style: TextStyles.title3.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: model.winners == null
                          ? Center(
                              child: SpinKitWave(
                                color: UiConstants.primaryColor,
                              ),
                            )
                          : (model.winners.isEmpty
                              ? Container(
                                  color: Colors.white,
                                  child: ListView(
                                    controller: myscrollController,
                                    children: [
                                      Center(
                                        child: NoRecordDisplayWidget(
                                          asset: "images/leaderboard.png",
                                          text: "Winners will be upadated soon",
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : WinnerboardView(
                                  winners: model.winners,
                                  controller: myscrollController,
                                  timeStamp: model.timeStamp,
                                )),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
