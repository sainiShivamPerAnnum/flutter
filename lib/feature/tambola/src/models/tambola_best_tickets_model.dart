// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';
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
  List<TambolaTicketModel>? category_1;
  List<TambolaTicketModel>? category_2;
  List<TambolaTicketModel>? category_3;
  List<TambolaTicketModel>? category_4;
  List<TicketStatsModel>? stats;

  Data({
    this.totalTicketCount = 0,
    this.category_1,
    this.category_2,
    this.category_3,
    this.category_4,
    this.stats,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalTicketCount = json['totalTicketCount'] ?? 0;
    if (json['category_1'] != null) {
      category_1 = TambolaTicketModel.helper.fromMapArray(json['category_1']);
    }
    if (json['category_2'] != null) {
      category_2 = TambolaTicketModel.helper.fromMapArray(json['category_2']);
    }
    if (json['category_3'] != null) {
      category_3 = TambolaTicketModel.helper.fromMapArray(json['category_3']);
    }
    if (json['category_4'] != null) {
      category_4 = TambolaTicketModel.helper.fromMapArray(json['category_4']);
    }

    // stats = (json['stats'] != null)
    //     ? TicketStatsModel.helper.fromMapArray(json['category_4'])
    //     : TicketStatsModel.base();
  }

  // int getTotalTicketsLength() {
  //   return (corners?.length ?? 0) +
  //       (oneRow?.length ?? 0) +
  //       (twoRows?.length ?? 0) +
  //       (fullHouse?.length ?? 0);
  // }

  List<TambolaTicketModel> allTickets() {
    return [
      ...category_1 ?? [],
      ...category_2 ?? [],
      ...category_3 ?? [],
      ...category_4 ?? [],
    ];
  }
}

class TicketStatsModel {
  final String category;
  final int count;
  TicketStatsModel({
    required this.category,
    required this.count,
  });

  static final helper = HelperModel<TicketStatsModel>(TicketStatsModel.fromMap);

  factory TicketStatsModel.fromMap(Map<String, dynamic> map) {
    return TicketStatsModel(
      category: map['category'] ?? "",
      count: map['count'] ?? "",
    );
  }

  factory TicketStatsModel.base() {
    return TicketStatsModel(
      category: "category",
      count: 0,
    );
  }
}
