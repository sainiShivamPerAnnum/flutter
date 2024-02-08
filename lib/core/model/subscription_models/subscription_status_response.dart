import 'package:json_annotation/json_annotation.dart';

import 'subscription_status.dart';

part 'subscription_status_response.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class SubscriptionStatusResponse {
  final String message;
  final SubscriptionTransactionData data;

  const SubscriptionStatusResponse({
    required this.message,
    required this.data,
  });

  factory SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusResponseFromJson(json);
}

@_deserializable
class SubscriptionTransactionData {
  final SubscriptionStatusData subscription;

  const SubscriptionTransactionData(this.subscription);

  factory SubscriptionTransactionData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTransactionDataFromJson(json);
}

@_deserializable
class SubscriptionStatusData {
  final String id;
  final num amount;
  @JsonKey(unknownEnumValue: Frequency.DAILY)
  final Frequency frequency;
  @JsonKey(unknownEnumValue: AutosaveState.IDLE)
  final AutosaveState status;
  final bool isActive;
  final num AUGGOLD99;
  final num LENDBOXP2P;
  final String startDate;
  final String createdOn;
  final String assetType;
  final int tt;
  final List gts;

  const SubscriptionStatusData({
    this.id = '',
    this.amount = 0,
    this.frequency = Frequency.DAILY,
    this.status = AutosaveState.IDLE,
    this.isActive = false,
    this.AUGGOLD99 = 0,
    this.LENDBOXP2P = 0,
    this.startDate = '',
    this.createdOn = '',
    this.assetType = '',
    this.tt = 0,
    this.gts = const [],
  });

  factory SubscriptionStatusData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusDataFromJson(json);
}
