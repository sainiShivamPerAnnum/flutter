class PowerPlayReward {
  PowerPlayReward({
    this.message,
    this.data,
  });

  final String? message;
  final RewardData? data;

  PowerPlayReward copyWith({
    String? message,
    RewardData? data,
  }) =>
      PowerPlayReward(
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PowerPlayReward.fromJson(Map<String, dynamic> json) =>
      PowerPlayReward(
        message: json["message"],
        data: json["data"] == null ? null : RewardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class RewardData {
  RewardData({
    this.amount,
    this.flc,
  });

  final int? amount;
  final int? flc;

  RewardData copyWith({
    int? amount,
    int? flc,
  }) =>
      RewardData(
        amount: amount ?? this.amount,
        flc: flc ?? this.flc,
      );

  factory RewardData.fromJson(Map<String, dynamic> json) => RewardData(
        amount: json["amount"],
        flc: json["flc"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "flc": flc,
      };
}
