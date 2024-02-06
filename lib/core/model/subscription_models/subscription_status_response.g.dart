// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_status_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionStatusResponse _$SubscriptionStatusResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionStatusResponse',
      json,
      ($checkedConvert) {
        final val = SubscriptionStatusResponse(
          message: $checkedConvert('message', (v) => v as String),
          data: $checkedConvert(
              'data',
              (v) =>
                  SubscriptionStatusData.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

SubscriptionStatusData _$SubscriptionStatusDataFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionStatusData',
      json,
      ($checkedConvert) {
        final val = SubscriptionStatusData(
          id: $checkedConvert('id', (v) => v as String? ?? ''),
          subId: $checkedConvert('subId', (v) => v as String? ?? ''),
          uid: $checkedConvert('uid', (v) => v as String? ?? ''),
          amount: $checkedConvert('amount', (v) => v as num? ?? 0),
          frequency: $checkedConvert(
              'frequency',
              (v) =>
                  $enumDecodeNullable(_$FrequencyEnumMap, v,
                      unknownValue: Frequency.DAILY) ??
                  Frequency.DAILY),
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$AutosaveStateEnumMap, v,
                      unknownValue: AutosaveState.IDLE) ??
                  AutosaveState.IDLE),
          isActive: $checkedConvert('isActive', (v) => v as bool? ?? false),
          AUGGOLD99: $checkedConvert('AUGGOLD99', (v) => v as num? ?? 0),
          LENDBOXP2P: $checkedConvert('LENDBOXP2P', (v) => v as num? ?? 0),
          resumeFrequency: $checkedConvert(
              'resumeFrequency',
              (v) =>
                  $enumDecodeNullable(_$FrequencyEnumMap, v,
                      unknownValue: Frequency.DAILY) ??
                  Frequency.DAILY),
          resumeDate: $checkedConvert('resumeDate', (v) => v as String? ?? ''),
          startDate: $checkedConvert('startDate', (v) => v as String? ?? ''),
          createdOn: $checkedConvert('createdOn', (v) => v as String? ?? ''),
          updatedOn: $checkedConvert('updatedOn', (v) => v as String? ?? ''),
          assetType: $checkedConvert('assetType', (v) => v as String? ?? ''),
          payResponseCode:
              $checkedConvert('payResponseCode', (v) => v as String? ?? ''),
          responseCode:
              $checkedConvert('responseCode', (v) => v as String? ?? ''),
          tt: $checkedConvert('tt', (v) => v as int? ?? 0),
          gts: $checkedConvert('gts', (v) => v as List<dynamic>? ?? const []),
          tambola: $checkedConvert('tambola_tts', (v) => v as num? ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {'tambola': 'tambola_tts'},
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
