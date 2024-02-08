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
      assetType: $enumDecodeNullable(_$SIPAssetTypesEnumMap, json['assetType'],
              unknownValue: SIPAssetTypes.UNKNOWN) ??
          SIPAssetTypes.UNKNOWN,
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

const _$SIPAssetTypesEnumMap = {
  SIPAssetTypes.UNI_FLEXI: 'UNI_FLEXI',
  SIPAssetTypes.UNI_FIXED_3: 'UNI_FIXED_3',
  SIPAssetTypes.UNI_FIXED_6: 'UNI_FIXED_6',
  SIPAssetTypes.AUGGOLD99: 'AUGGOLD99',
  SIPAssetTypes.BOTH: 'BOTH',
  SIPAssetTypes.UNKNOWN: 'UNKNOWN',
};
