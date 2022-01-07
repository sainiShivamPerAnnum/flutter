import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class GoldenTicketView extends StatelessWidget {
  final GoldenTicket ticket;
  GoldenTicketView({@required this.ticket});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Hero(
          tag: '0',
          child: Scratcher(
            threshold: 40,
            onThreshold: () {
              BaseUtil.showPositiveAlert("Reward Redeemed",
                  "Prizes will be credited soon to your account");
            },
            image: Image.asset("images/gticket.png"),
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: SizeConfig.screenWidth / 4,
                color: Colors.white,
                width: SizeConfig.screenWidth / 2,
                margin: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    ticket.rewards.length,
                    (idx) => Text(
                        "${ticket.rewards[idx].type}: ${ticket.rewards[idx].value}"),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
