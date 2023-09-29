import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';

class TambolaBestTicketsModel {
  String? message;
  Data? data;

  TambolaBestTicketsModel({this.message, this.data});

  TambolaBestTicketsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? totalTicketCount;
  List<TambolaTicketModel>? corners;
  List<TambolaTicketModel>? oneRow;
  List<TambolaTicketModel>? twoRows;
  List<TambolaTicketModel>? fullHouse;

  Data(
      {this.totalTicketCount = 0,
      this.corners,
      this.oneRow,
      this.twoRows,
      this.fullHouse});

  Data.fromJson(Map<String, dynamic> json) {
    totalTicketCount = json['totalTicketCount'] ?? 0;
    if (json['corners'] != null) {
      corners = TambolaTicketModel.helper.fromMapArray(json['corners']);
    }
    if (json['oneRow'] != null) {
      oneRow = TambolaTicketModel.helper.fromMapArray(json['oneRow']);
    }
    if (json['twoRows'] != null) {
      twoRows = TambolaTicketModel.helper.fromMapArray(json['twoRows']);
    }
    if (json['fullHouse'] != null) {
      fullHouse = TambolaTicketModel.helper.fromMapArray(json['fullHouse']);
    }
  }

  // int getTotalTicketsLength() {
  //   return (corners?.length ?? 0) +
  //       (oneRow?.length ?? 0) +
  //       (twoRows?.length ?? 0) +
  //       (fullHouse?.length ?? 0);
  // }

  List<TambolaTicketModel> allTickets() {
    return [
      ...corners ?? [],
      ...oneRow ?? [],
      ...twoRows ?? [],
      ...fullHouse ?? [],
    ];
  }
}
