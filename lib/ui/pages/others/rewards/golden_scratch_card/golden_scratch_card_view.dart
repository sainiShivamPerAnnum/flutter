import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/golden_scratch_card_vm.dart';
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

class GoldenScratchCardView extends StatelessWidget {
  final GoldenTicket ticket;
  final GoldenTicketsViewModel superModel;
  GoldenScratchCardView({@required this.ticket, @required this.superModel});
  @override
  Widget build(BuildContext context) {
    return BaseView<GoldenScratchCardViewModel>(
      onModelReady: (model) {
        model.init(ticket);
      },
      builder: (ctx, model, child) {
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
                model.viewScratchedCard
                    ? GoldenTicketGridItemCard(
                        ticket: ticket,
                        titleStyle: TextStyles.title1,
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
                                  "assets/images/gtbg.png",
                                  fit: BoxFit.cover,
                                  height: SizeConfig.screenWidth * 0.6,
                                  width: SizeConfig.screenWidth * 0.6,
                                ),
                                child: RedeemedGoldenScratchCard(
                                  ticket: ticket,
                                  titleStyle: TextStyles.title1,
                                ),
                              ),
                            ),
                          )
                        : GoldenTicketGridItemCard(
                            ticket: ticket,
                            titleStyle: TextStyles.title1,
                          )),
                Spacer(),
                if (model.bottompadding) FelloAppBar(),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                    image: DecorationImage(
                        image: AssetImage(Assets.splashBackground),
                        fit: BoxFit.fill),
                  ),
                  height: model.detailsModalHeight,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  child: model.state == ViewState.Busy
                      ? Center(
                          child: FittedBox(
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
                          ),
                        )
                      : (
                          // !model.isTicketRedeemedSuccessfully
                          //   ? NoRecordDisplayWidget(
                          //       asset: "images/badticket.png",
                          //       text:
                          //           "An error occured while redeeming your ticket",
                          //     )
                          //   :
                          SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "images/fello_logo.png",
                                    height: SizeConfig.padding40,
                                  ),
                                ],
                              ),
                              SizedBox(height: SizeConfig.padding16),
                              Column(
                                children: ticket.isRewarding
                                    ? [
                                        // Text(
                                        //   "Reward Details",
                                        //   style: TextStyles.title3.bold
                                        //       .colour(Colors.black87),
                                        // ),
                                        //SizedBox(height: SizeConfig.padding12),
                                        referralTile("${ticket.note}"),
                                        referralTile(
                                            "Rewards have been credited to your wallet"),
                                        ticket.redeemedTimestamp != null
                                            ? referralTile(
                                                "Redeemed on ${DateFormat('dd MMM, yyyy').format(ticket.redeemedTimestamp.toDate())} | ${DateFormat('h:mm a').format(ticket.redeemedTimestamp.toDate())}")
                                            : referralTile(
                                                "Recieved on ${DateFormat('dd MMM, yyyy').format(ticket.timestamp.toDate())} | ${DateFormat('h:mm a').format(ticket.timestamp.toDate())}")
                                        //referralTile("Version: ${ticket.version}"),
                                      ]
                                    : [
                                        referralTile(
                                            "Keep investing, keep playing to earn more golden tickets"),
                                      ],
                              ),
                            ],
                          ),
                        )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget referralTile(String title) {
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
