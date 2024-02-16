// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionStatusResponse _$SubscriptionStatusResponseFromJson(
        Map<String, dynamic> json) =>
    SubscriptionStatusResponse(
      message: json['message'] as String,
      data: SubscriptionTransactionData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

SubscriptionTransactionData _$SubscriptionTransactionDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionTransactionData(
      SubscriptionStatusData.fromJson(
          json['subscription'] as Map<String, dynamic>),
    );

SubscriptionStatusData _$SubscriptionStatusDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionStatusData(
      id: json['id'] as String? ?? '',
      amount: json['amount'] as num? ?? 0,
      frequency: $enumDecodeNullable(_$FrequencyEnumMap, json['frequency'],
              unknownValue: Frequency.DAILY) ??
          Frequency.DAILY,
      status: $enumDecodeNullable(_$AutosaveStateEnumMap, json['status'],
              unknownValue: AutosaveState.IDLE) ??
          AutosaveState.IDLE,
      isActive: json['isActive'] as bool? ?? false,
      AUGGOLD99: json['AUGGOLD99'] as num? ?? 0,
      LENDBOXP2P: json['LENDBOXP2P'] as num? ?? 0,
      startDate: json['startDate'] as String? ?? '',
      createdOn: json['createdOn'] as String? ?? '',
      assetType: json['assetType'] as String? ?? '',
      tt: json['tt'] as int? ?? 0,
      gts: json['gts'] as List<dynamic>? ?? const [],
    );

const _$FrequencyEnumMap = {
  Frequency.DAILY: 'DAILY',
  Frequency.WEEKLY: 'WEEKLY',
  Frequency.MONTHLY: 'MONTHLY',
};

const _$AutosaveStateEnumMap = {
  AutosaveState.IDLE: 'IDLE',
  AutosaveState.INIT: 'INIT',
  AutosaveState.ACTIVE: 'ACTIVE',
  AutosaveState.PAUSE_FROM_APP: 'PAUSE_FROM_APP',
  AutosaveState.PAUSE_FROM_APP_FOREVER: 'PAUSE_FROM_APP_FOREVER',
  AutosaveState.PAUSE_FROM_PSP: 'PAUSE_FROM_PSP',
  AutosaveState.CANCELLED: 'CANCELLED',
};
