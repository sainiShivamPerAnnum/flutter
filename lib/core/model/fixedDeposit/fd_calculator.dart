import 'package:json_annotation/json_annotation.dart';

part 'fd_calculator.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class FDInterestModel {
  final bool success;
  final FDCalculator? data;

  FDInterestModel({required this.success, this.data});

  factory FDInterestModel.fromJson(Map<String, dynamic> json) =>
      _$FDInterestModelFromJson(json);
}

@_deserializable
class FDCalculator {
  final String totalInterest;
  final String maturityAmount;
  final double interestRate;

  FDCalculator({
    required this.totalInterest,
    required this.maturityAmount,
    required this.interestRate,
  });

  factory FDCalculator.fromJson(Map<String, dynamic> json) =>
      _$FDCalculatorFromJson(json);
}
