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
