// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String? ?? '',
      subId: json['subId'] as String? ?? '',
      status: $enumDecodeNullable(_$AutosaveStateEnumMap, json['status'],
              unknownValue: AutosaveState.IDLE) ??
          AutosaveState.IDLE,
      assetType: json['assetType'] as String? ?? 'UNKNOWN',
      amount: json['amount'] as num? ?? 0,
      frequency: json['frequency'] as String? ?? '',
      aUGGOLD99: json['AUGGOLD99'] as num? ?? 0,
      lENDBOXP2P: json['LENDBOXP2P'] as num? ?? 0,
      createdOn: json['createdOn'] as String? ?? '',
      nextDue: json['nextDue'] as String? ?? '',
    );

const _$AutosaveStateEnumMap = {
  AutosaveState.IDLE: 'IDLE',
  AutosaveState.INIT: 'INIT',
  AutosaveState.ACTIVE: 'ACTIVE',
  AutosaveState.PAUSE_FROM_APP: 'PAUSE_FROM_APP',
  AutosaveState.PAUSE_FROM_APP_FOREVER: 'PAUSE_FROM_APP_FOREVER',
  AutosaveState.PAUSE_FROM_PSP: 'PAUSE_FROM_PSP',
  AutosaveState.CANCELLED: 'CANCELLED',
};
