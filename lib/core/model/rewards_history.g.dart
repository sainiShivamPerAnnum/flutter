// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardsPaymentDetails _$RewardsPaymentDetailsFromJson(
        Map<String, dynamic> json) =>
    RewardsPaymentDetails(
      amount: (json['amount'] as num).toDouble(),
    );

RewardsHistoryModel _$RewardsHistoryModelFromJson(Map<String, dynamic> json) =>
    RewardsHistoryModel(
      paymentDetails: RewardsPaymentDetails.fromJson(
          json['paymentDetails'] as Map<String, dynamic>),
      advisorId: json['advisorId'] as String,
      bookingId: json['bookingId'] as String,
      isCoinUse: json['isCoinUse'] as bool,
      parentTxnId: json['parentTxnId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      advisorName: json['advisorName'] as String? ?? '',
    );
