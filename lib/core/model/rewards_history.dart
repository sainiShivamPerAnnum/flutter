import 'package:json_annotation/json_annotation.dart';

part 'rewards_history.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class RewardsPaymentDetails {
  final double amount;

  RewardsPaymentDetails({
    required this.amount,
  });

  factory RewardsPaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$RewardsPaymentDetailsFromJson(json);
}

@_deserializable
class RewardsHistoryModel {
  final RewardsPaymentDetails paymentDetails;
  final String advisorId;
  final String advisorName;
  final String bookingId;
  final bool isCoinUse;
  final String parentTxnId;
  final DateTime createdAt;
  final DateTime updatedAt;

  RewardsHistoryModel({
    required this.paymentDetails,
    required this.advisorId,
    required this.bookingId,
    required this.isCoinUse,
    required this.parentTxnId,
    required this.createdAt,
    required this.updatedAt,
    this.advisorName ='',
  });

  factory RewardsHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$RewardsHistoryModelFromJson(json);
}
