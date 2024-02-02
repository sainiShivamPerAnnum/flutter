// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String?,
      subId: json['subId'] as String?,
      status: json['status'] as String?,
      amount: json['amount'] as num?,
      frequency: json['frequency'] as String?,
      aUGGOLD99: json['AUGGOLD99'] as num?,
      lENDBOXP2P: json['LENDBOXP2P'] as num?,
      resumeFrequency: json['resumeFrequency'] as String?,
      createdOn: json['createdOn'] as String?,
      updatedOn: json['updatedOn'] as String?,
      nextDue: json['nextDue'] as String?,
    );
