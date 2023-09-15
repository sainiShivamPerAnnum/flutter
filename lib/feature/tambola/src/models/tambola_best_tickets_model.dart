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
  List<TambolaTicketModel>? best;
  List<TicketStatsModel>? stats;
  int? ticketCap;

  Data({
    this.totalTicketCount = 0,
    this.category_1,
    this.category_2,
    this.category_3,
    this.category_4,
    this.stats,
    this.best,
    this.ticketCap = 10,
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
    if (json['best'] != null) {
      best = TambolaTicketModel.helper.fromMapArray(json['best']);
    }

    stats = (json['stats'] != null)
        ? TicketStatsModel.parseTicketsStats(json['stats'])
        : TicketStatsModel.getBaseTicketsStats();

    ticketCap = json["ticketCap"] ?? 10;
  }

  // int getTotalTicketsLength() {
  //   return (corners?.length ?? 0) +
  //       (oneRow?.length ?? 0) +
  //       (twoRows?.length ?? 0) +
  //       (fullHouse?.length ?? 0);
  // }

  List<TambolaTicketModel> allTickets() {
    return best ?? [];
  }
}

class TicketStatsModel {
  final String category;
  final String displayName;
  final int count;
  TicketStatsModel({
    required this.category,
    required this.displayName,
    required this.count,
  });

  static final helper = HelperModel<TicketStatsModel>(TicketStatsModel.fromMap);

  factory TicketStatsModel.fromMap(Map<String, dynamic> map) {
    return TicketStatsModel(
      category: map['category'] ?? "",
      displayName: map["displayName"] ?? "",
      count: map['count'] ?? "",
    );
  }

  static List<TicketStatsModel> parseTicketsStats(Map<String, dynamic> stats) {
    return [
      TicketStatsModel(
        category: "category_1",
        displayName: "5-7",
        count: stats["category_1"],
      ),
      TicketStatsModel(
        category: "category_2",
        displayName: "8-10",
        count: stats["category_2"],
      ),
      TicketStatsModel(
        category: "category_3",
        displayName: "11-13",
        count: stats["category_3"],
      ),
      TicketStatsModel(
        category: "category_4",
        displayName: "14-15",
        count: stats["category_4"],
      )
    ];
  }

  static List<TicketStatsModel> getBaseTicketsStats() {
    return [
      TicketStatsModel(
        category: "category_1",
        displayName: "5-7",
        count: 0,
      ),
      TicketStatsModel(
        category: "category_2",
        displayName: "8-10",
        count: 0,
      ),
      TicketStatsModel(
        category: "category_3",
        displayName: "11-13",
        count: 0,
      ),
      TicketStatsModel(
        category: "category_4",
        displayName: "14-15",
        count: 0,
      )
    ];
  }
}
