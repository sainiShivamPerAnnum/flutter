import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_ticket_utils.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
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
  final GoldenTicketsViewModel superModel;
  GTDetailedView({@required this.ticket, @required this.superModel});
  @override
  Widget build(BuildContext context) {
    return BaseView<GTDetailedViewModel>(
      onModelReady: (model) {
        model.init(ticket);
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(
                  color: Colors.black,
                ),
              ),
              Spacer(),
              model.viewScratchedCard
                  ? GoldenTicketGridItemCard(
                      ticket: ticket,
                      titleStyle: TextStyles.title2,
                    )
                  : (model.viewScratcher
                      ? Hero(
                          key: Key(ticket.timestamp.toString()),
                          tag: ticket.timestamp.toString(),
                          createRectTween: (begin, end) {
                            return CustomRectTween(begin: begin, end: end);
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness16),
                            child: Scratcher(
                              accuracy: ScratchAccuracy.low,
                              brushSize: 50,
                              threshold: 40,
                              key: scratchKey,
                              onThreshold: () =>
                                  model.redeemCard(superModel, ticket),
                              image: Image.asset(
                                Assets.gtCover,
                                fit: BoxFit.cover,
                                height: SizeConfig.screenWidth * 0.6,
                                width: SizeConfig.screenWidth * 0.6,
                              ),
                              child: RedeemedGoldenScratchCard(
                                ticket: ticket,
                                titleStyle: TextStyles.title2,
                              ),
                            ),
                          ),
                        )
                      : GoldenTicketGridItemCard(
                          ticket: ticket,
                          titleStyle: TextStyles.title2,
                        )),
              Spacer(),
              if (model.bottompadding) FelloAppBar(),
              AnimatedContainer(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [UiConstants.scaffoldColor, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                    // image: DecorationImage(
                    //     image: AssetImage(Assets.splashBackground),
                    //     fit: BoxFit.fill),
                  ),
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

  Widget setModalContent(GTDetailedViewModel model) {
    if (ticket.redeemedTimestamp != null) {
      //redeemed ticket -> just show the details
      return Padding(
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Congratulations!", style: TextStyles.title2.bold),
            SizedBox(height: SizeConfig.padding16),
            Column(children: [
              bulletTiles("${ticket.note}"),
              bulletTiles("Rewards have been credited to your wallet"),
              ticket.redeemedTimestamp != null
                  ? bulletTiles(
                      "Redeemed on ${DateFormat('dd MMM, yyyy').format(ticket.redeemedTimestamp.toDate())} | ${DateFormat('h:mm a').format(ticket.redeemedTimestamp.toDate())}")
                  : bulletTiles(
                      "Recieved on ${DateFormat('dd MMM, yyyy').format(ticket.timestamp.toDate())} | ${DateFormat('h:mm a').format(ticket.timestamp.toDate())}")
            ]),
          ],
        ),
      );
    } else {
      if (model.isCardScratched) {
        if (!ticket.isRewarding ||
            ticket.rewardArr == null ||
            ticket.rewardArr.isEmpty)
          return Padding(
            padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("No rewards won", style: TextStyles.title2.bold),
                SizedBox(height: SizeConfig.padding16),
                Column(children: [
                  bulletTiles("Keep investing, keep playing and win big!"),
                ]),
              ],
            ),
          );
        else {
          if (model.state == ViewState.Busy) {
            return Padding(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitWave(
                    color: UiConstants.primaryColor,
                    size: SizeConfig.padding32,
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  Text(
                    "Please wait, registering your ticket",
                    style: TextStyles.body2.bold,
                  )
                ],
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Congratulations!", style: TextStyles.title2.bold),
                  SizedBox(height: SizeConfig.padding16),
                  Column(children: [
                    bulletTiles("${ticket.note}"),
                    bulletTiles("Rewards have been credited to your wallet"),
                    ticket.redeemedTimestamp != null
                        ? bulletTiles(
                            "Redeemed on ${DateFormat('dd MMM, yyyy').format(ticket.redeemedTimestamp.toDate())} | ${DateFormat('h:mm a').format(ticket.redeemedTimestamp.toDate())}")
                        : bulletTiles(
                            "Recieved on ${DateFormat('dd MMM, yyyy').format(ticket.timestamp.toDate())} | ${DateFormat('h:mm a').format(ticket.timestamp.toDate())}")
                  ]),
                ],
              ),
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
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Icon(
            Icons.brightness_1,
            size: 12,
            color: UiConstants.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyles.body3,
            ),
          ),
        ],
      ),
    );
  }
}
