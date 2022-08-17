import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_ticket_utils.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:scratcher/scratcher.dart';

final scratchKey = GlobalKey<ScratcherState>();

class GTDetailedView extends StatelessWidget {
  final GoldenTicket ticket;
  GTDetailedView({@required this.ticket});
  @override
  Widget build(BuildContext context) {
    return BaseView<GTDetailedViewModel>(
      onModelReady: (model) {
        model.init(ticket);
      },
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  AppState.backButtonDispatcher.didPopRoute();
                },
                icon: Icon(Icons.close),
              )
            ],
          ),
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Column(
            children: [
              Spacer(),
              (model.viewScratchedCard)
                  ? RepaintBoundary(
                      key: ticketImageKey,
                      child: GoldenTicketGridItemCard(
                        ticket: ticket,
                        titleStyle: TextStyles.title2,
                        titleStyle2: TextStyles.title4,
                        subtitleStyle: TextStyles.body1,
                        width: SizeConfig.screenWidth * 0.6,
                      ),
                    )
                  : (model.viewScratcher
                      ? Hero(
                          key: Key(ticket.timestamp.toString()),
                          tag: ticket.timestamp.toString(),
                          createRectTween: (begin, end) {
                            return CustomRectTween(begin: begin, end: end);
                          },
                          child: Scratcher(
                            color: Colors.transparent,
                            accuracy: ScratchAccuracy.low,
                            brushSize: 50,
                            threshold: 40,
                            key: scratchKey,
                            onThreshold: () => model.redeemCard(ticket),
                            image: Image.asset(
                              Assets.unredemmedGoldenTicketBG_png,
                              fit: BoxFit.contain,
                              height: SizeConfig.screenWidth * 0.6,
                              width: SizeConfig.screenWidth * 0.6,
                            ),
                            child: RepaintBoundary(
                              key: ticketImageKey,
                              child: RedeemedGoldenScratchCard(
                                ticket: ticket,
                                width: SizeConfig.screenWidth * 0.6,
                              ),
                            ),
                          ),
                        )
                      : GoldenTicketGridItemCard(
                          ticket: ticket,
                          titleStyle: TextStyles.title2,
                          titleStyle2: TextStyles.title4,
                          subtitleStyle: TextStyles.body1,
                          width: SizeConfig.screenWidth * 0.6,
                        )),
              AnimatedContainer(
                  decoration: BoxDecoration(),
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  child: setTicketHeader(model)),
              Spacer(flex: 2),
              AnimatedContainer(
                  decoration: BoxDecoration(),
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  child: setModalContent(model))
            ],
          ),
        );
      },
    );
  }

  Widget setTicketHeader(GTDetailedViewModel model) {
    if (ticket.redeemedTimestamp != null &&
        ticket.redeemedTimestamp !=
            TimestampModel(seconds: 0, nanoseconds: 0)) {
      //redeemed ticket -> just show the details
      return Column(
        children: [
          Text("Congratulations!",
              style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
            child: Text(
              "${ticket.note}",
              style:
                  TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    } else {
      if (model.isCardScratched) {
        if (!ticket.isRewarding ||
            ticket.rewardArr == null ||
            ticket.rewardArr.isEmpty)
          return Column(
            children: [
              Text("No Rewards won",
                  style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                child: Text(
                  "Keep investing, keep playing and win big!",
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor3),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        else {
          if (model.state == ViewState.Busy) {
            return SizedBox.shrink();
          } else {
            return Column(
              children: [
                Text("Congratulations!",
                    style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
                  child: Text(
                    "${ticket.note}",
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor3),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }
        }
      } else {
        return Column(
          children: [
            Text("Hurray!",
                style: TextStyles.rajdhaniB.title2.colour(Colors.white)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: Text(
                "You’ve earned a golden ticket.",
                style: TextStyles.sourceSans.body4.colour(Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
              child: Text(
                "Scratch and win exciting rewards.",
                style:
                    TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }
    }
  }

  Widget setModalContent(GTDetailedViewModel model) {
    if (ticket.redeemedTimestamp != null &&
        ticket.redeemedTimestamp !=
            TimestampModel(seconds: 0, nanoseconds: 0)) {
      //redeemed ticket -> just show the details
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: UiConstants.gameCardColor,
        ),
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          bulletTiles("Rewards have been credited to your wallet"),
          (ticket.redeemedTimestamp != null &&
                  ticket.redeemedTimestamp !=
                      TimestampModel(seconds: 0, nanoseconds: 0))
              ? bulletTiles(
                  "Redeemed on ${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp.seconds * 1000))}")
              : bulletTiles(
                  "Received on ${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp.seconds * 1000))}")
        ]),
      );
    } else {
      if (model.isCardScratched) {
        if (!ticket.isRewarding ||
            ticket.rewardArr == null ||
            ticket.rewardArr.isEmpty)
          return Column(
            children: [],
          );
        else {
          if (model.state == ViewState.Busy) {
            return Container(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              width: double.infinity,
              decoration: BoxDecoration(
                color: UiConstants.gameCardColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SpinKitWave(
                    color: UiConstants.primaryColor,
                    size: SizeConfig.padding32,
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  Text(
                    "Adding prize to your wallet",
                    style: TextStyles.body2.bold.colour(Colors.white),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: UiConstants.gameCardColor,
              ),
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    bulletTiles("Rewards have been credited to your wallet"),
                    (ticket.redeemedTimestamp != null &&
                            ticket.redeemedTimestamp !=
                                TimestampModel(seconds: 0, nanoseconds: 0))
                        ? bulletTiles(
                            "Redeemed on ${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.redeemedTimestamp.seconds * 1000))}")
                        : bulletTiles(
                            "Received on ${DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp.seconds * 1000))} | ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticket.timestamp.seconds * 1000))}")
                  ]),
            );
          }
        }
      } else {
        return SizedBox(height: 0);
      }
    }
  }

  Widget bulletTiles(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.brightness_1,
            size: 06,
            color: UiConstants.kTextColor2,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyles.body3.colour(UiConstants.kTextColor2),
          ),
        ],
      ),
    );
  }
}
