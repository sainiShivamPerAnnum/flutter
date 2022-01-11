import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class GoldenTicketView extends StatelessWidget {
  final GoldenTicket ticket;
  GoldenTicketView({@required this.ticket});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: GoldenTicketCard(
          ticket: ticket,
          enabled: true,
        ),
      ),
    );
  }
}
