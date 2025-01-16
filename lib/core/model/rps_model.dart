import 'package:json_annotation/json_annotation.dart';

part 'rps_model.g.dart';

@JsonSerializable()
class RpsData {
  final String uid;
  final double principleAmount;
  final String fundType;
  final int tenure;
  final double accuredInterest;
  final List<Rps> rps;
  final String createdAt;
  final String updatedAt;

  RpsData({
    required this.uid,
    required this.principleAmount,
    required this.fundType,
    required this.tenure,
    required this.accuredInterest,
    required this.rps,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RpsData.fromJson(Map<String, dynamic> json) =>
      _$RpsDataFromJson(json);

  Map<String, dynamic> toJson() => _$RpsDataToJson(this);
}

@JsonSerializable()
class Rps {
  final String timeline;
  final double scheduledAmount;
  final double paidAmount;
  final double paidInterest;
  final bool isPaid;

  Rps({
    required this.timeline,
    required this.scheduledAmount,
    required this.paidAmount,
    required this.paidInterest,
    required this.isPaid,
  });

  factory Rps.fromJson(Map<String, dynamic> json) => _$RpsFromJson(json);

  Map<String, dynamic> toJson() => _$RpsToJson(this);
}
