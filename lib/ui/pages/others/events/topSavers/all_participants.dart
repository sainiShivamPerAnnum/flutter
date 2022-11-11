import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_savers_new.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AllParticipantsView extends StatelessWidget {
  final TopSaverViewModel model;
  final bool forPastWinners;

  AllParticipantsView({
    @required this.model,
    @required this.forPastWinners,
  });
  bool isInteger(num value) => value is int || value == value.roundToDouble();

  getItemCountCurrentWinners() {
    if (model.campaignType == Constants.HS_DAILY_SAVER) {
      if (model.currentParticipants.length < 30)
        return model.currentParticipants.length;
      else
        return 30;
    } else if (model.campaignType == Constants.HS_WEEKLY_SAVER) {
      if (model.currentParticipants.length < 50)
        return model.currentParticipants.length;
      else
        return 50;
    } else if (model.campaignType == Constants.HS_MONTHLY_SAVER) {
      if (model.currentParticipants.length < 80)
        return model.currentParticipants.length;
      else
        return 80;
    } else
      return model.currentParticipants.length;
  }

  getItemCountPastWinners() {
    if (model.campaignType == Constants.HS_DAILY_SAVER) {
      if (model.pastWinners.length < 30)
        return model.pastWinners.length;
      else
        return 30;
    } else if (model.campaignType == Constants.HS_WEEKLY_SAVER) {
      if (model.pastWinners.length < 50)
        return model.pastWinners.length;
      else
        return 50;
    } else if (model.campaignType == Constants.HS_MONTHLY_SAVER) {
      if (model.pastWinners.length < 80)
        return model.pastWinners.length;
      else
        return 80;
    } else
      return model.pastWinners.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: UiConstants.kBackgroundColor,
          elevation: 0.0,
          title: Text(
            forPastWinners ? 'Past Winners' : 'Top Participants',
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyles.title4.bold.colour(Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                AppState.backButtonDispatcher.didPopRoute();
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        backgroundColor: UiConstants.kBackgroundColor,
        body: Stack(
          children: [
            NewSquareBackground(),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
                child: !forPastWinners
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: SizeConfig.padding12),
                        shrinkWrap: true,
                        itemCount: getItemCountCurrentWinners(),
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding20,
                              horizontal: SizeConfig.padding2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}',
                                        style: TextStyles.rajdhaniSB.body2,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding20,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          model.currentParticipants[index]
                                              .username,
                                          style: TextStyles.sourceSans.body3
                                              .setOpecity(0.8),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  model.currentParticipants[index]
                                          ?.displayScore ??
                                      ''.toString(),
                                  style: TextStyles.rajdhaniM.body3,
                                ),
                              ],
                            ),
                          );
                        },
                        //Current participants
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(top: SizeConfig.padding12),
                        shrinkWrap: true,
                        itemCount: getItemCountPastWinners(),
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding20,
                              horizontal: SizeConfig.padding2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        '${index + 1}',
                                        style: TextStyles.rajdhaniSB.body2,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding20,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          model.pastWinners[index].username,
                                          style: TextStyles.sourceSans.body3
                                              .setOpecity(0.8),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  "${model.pastWinners[index].score.truncateToDecimalPlaces(3)} gm"
                                      .toString(),
                                  style: TextStyles.rajdhaniM.body3,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ));
  }
}
