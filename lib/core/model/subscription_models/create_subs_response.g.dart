// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_subs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSubscriptionResponse _$CreateSubscriptionResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateSubscriptionResponse',
      json,
      ($checkedConvert) {
        final val = CreateSubscriptionResponse(
          data: $checkedConvert(
              'data',
              (v) =>
                  SubscriptionResponseData.fromJson(v as Map<String, dynamic>)),
          message: $checkedConvert('message', (v) => v as String? ?? ''),
        );
        return val;
      },
    );

SubscriptionResponseData _$SubscriptionResponseDataFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionResponseData',
      json,
      ($checkedConvert) {
        final val = SubscriptionResponseData(
          intent: $checkedConvert('intent',
              (v) => SubscriptionIntent.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

SubscriptionIntent _$SubscriptionIntentFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionIntent',
      json,
      ($checkedConvert) {
        final val = SubscriptionIntent(
          redirectUrl:
              $checkedConvert('redirectUrl', (v) => v as String? ?? ''),
          alreadyExist:
              $checkedConvert('alreadyExist', (v) => v as bool? ?? false),
          subId: $checkedConvert('subId', (v) => v as String? ?? ''),
        );
        return val;
      },
    );
