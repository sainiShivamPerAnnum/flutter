import 'package:json_annotation/json_annotation.dart';

import 'subscription_status.dart';

part 'subscription_status_response.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
  checked: true,
);

@_deserializable
class SubscriptionStatusResponse {
  final String message;
  final SubscriptionStatusData data;

  const SubscriptionStatusResponse({
    required this.message,
    required this.data,
  });

  factory SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusResponseFromJson(json);
}

@_deserializable
class SubscriptionStatusData {
  final String id;
  final String subId;
  final String uid;
  final num amount;
  @JsonKey(unknownEnumValue: Frequency.DAILY)
  final Frequency frequency;
  @JsonKey(unknownEnumValue: AutosaveState.IDLE)
  final AutosaveState status;
  final bool isActive;
  final num AUGGOLD99;
  final num LENDBOXP2P;
  @JsonKey(unknownEnumValue: Frequency.DAILY)
  final Frequency resumeFrequency;
  final String resumeDate;
  final String startDate;
  final String createdOn;
  final String updatedOn;
  final String assetType;
  final String payResponseCode;
  final String responseCode;
  final int tt;
  final List gts;
  @JsonKey(name: 'tambola_tts')
  final num tambola;

  const SubscriptionStatusData({
    this.id = '',
    this.subId = '',
    this.uid = '',
    this.amount = 0,
    this.frequency = Frequency.DAILY,
    this.status = AutosaveState.IDLE,
    this.isActive = false,
    this.AUGGOLD99 = 0,
    this.LENDBOXP2P = 0,
    this.resumeFrequency = Frequency.DAILY,
    this.resumeDate = '',
    this.startDate = '',
    this.createdOn = '',
    this.updatedOn = '',
    this.assetType = '',
    this.payResponseCode = '',
    this.responseCode = '',
    this.tt = 0,
    this.gts = const [],
    this.tambola = 0,
  });

  factory SubscriptionStatusData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusDataFromJson(json);
}
