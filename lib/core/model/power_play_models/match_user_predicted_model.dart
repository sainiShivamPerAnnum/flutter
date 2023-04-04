import 'dart:convert';

MatchPredictionBoardModel MatchPredictionBoardModelFromJson(String str) =>
    MatchPredictionBoardModel.fromJson(json.decode(str));

String MatchPredictionBoardModelToJson(MatchPredictionBoardModel data) =>
    json.encode(data.toJson());

class MatchPredictionBoardModel {
  MatchPredictionBoardModel({
    this.message,
    this.data,
  });

  final String? message;
  final List<MatchUserPredictedData>? data;

  MatchPredictionBoardModel copyWith({
    String? message,
    List<MatchUserPredictedData>? data,
  }) =>
      MatchPredictionBoardModel(
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MatchPredictionBoardModel.fromJson(Map<String, dynamic> json) =>
      MatchPredictionBoardModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MatchUserPredictedData>.from(
                json["data"]!.map((x) => MatchUserPredictedData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MatchUserPredictedData {
  MatchUserPredictedData({
    this.amount,
    this.count,
  });

  final String? amount;
  final int? count;

  MatchUserPredictedData copyWith({
    String? amount,
    int? count,
  }) =>
      MatchUserPredictedData(
        amount: amount ?? this.amount,
        count: count ?? this.count,
      );

  factory MatchUserPredictedData.fromJson(Map<String, dynamic> json) =>
      MatchUserPredictedData(
        amount: json["amount"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "count": count,
      };
}
