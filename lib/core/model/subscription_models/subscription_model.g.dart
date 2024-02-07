// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionModel',
      json,
      ($checkedConvert) {
        final val = SubscriptionModel(
          id: $checkedConvert('id', (v) => v as String? ?? ''),
          subId: $checkedConvert('subId', (v) => v as String? ?? ''),
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$AutosaveStateEnumMap, v,
                      unknownValue: AutosaveState.IDLE) ??
                  AutosaveState.IDLE),
          assetType: $checkedConvert(
              'assetType',
              (v) =>
                  $enumDecodeNullable(_$SIPAssetTypesEnumMap, v,
                      unknownValue: SIPAssetTypes.UNKNOWN) ??
                  SIPAssetTypes.UNKNOWN),
          amount: $checkedConvert('amount', (v) => v as num? ?? 0),
          frequency: $checkedConvert('frequency', (v) => v as String? ?? ''),
          aUGGOLD99: $checkedConvert('AUGGOLD99', (v) => v as num? ?? 0),
          lENDBOXP2P: $checkedConvert('LENDBOXP2P', (v) => v as num? ?? 0),
          createdOn: $checkedConvert('createdOn', (v) => v as String? ?? ''),
          nextDue: $checkedConvert('nextDue', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {'aUGGOLD99': 'AUGGOLD99', 'lENDBOXP2P': 'LENDBOXP2P'},
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
