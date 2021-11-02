import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:flutter/material.dart';

class TicketSummaryCardModel {
  final List<BestTambolaTicketsSumm> data;
  final String cardType;
  final String bgAsset;
  final Color color;

  TicketSummaryCardModel({this.bgAsset, this.data, this.cardType, this.color});
}

class BestTambolaTicketsSumm {
  final List<Ticket> boards;
  final String title;

  BestTambolaTicketsSumm({@required this.boards, @required this.title});
}
