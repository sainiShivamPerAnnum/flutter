import 'package:json_annotation/json_annotation.dart';

part 'my_fds.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class InvestmentModel {
  final String current;
  final String invested;
  final String netReturns;
  final String avgXIRR;
  final String status;

  InvestmentModel({
    required this.current,
    required this.invested,
    required this.netReturns,
    required this.avgXIRR,
    required this.status,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentModelFromJson(json);
}

@_deserializable
class FixedDeposit {
  final String name;
  final String current;
  final String invested;
  final String avgXIRR;
  final String tenure;

  FixedDeposit({
    required this.name,
    required this.current,
    required this.invested,
    required this.avgXIRR,
    required this.tenure,
  });

  factory FixedDeposit.fromJson(Map<String, dynamic> json) =>
      _$FixedDepositFromJson(json);
}
