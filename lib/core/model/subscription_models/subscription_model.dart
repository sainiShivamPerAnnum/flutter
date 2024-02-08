import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:json_annotation/json_annotation.dart';

import 'subscription_status.dart';

part 'subscription_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SubscriptionModel {
  final String id; // phone pe id on backend.
  final String subId;
  @JsonKey(unknownEnumValue: AutosaveState.IDLE)
  final AutosaveState status;
  final num amount;
  final String frequency;
  @JsonKey(unknownEnumValue: SIPAssetTypes.UNKNOWN)
  final SIPAssetTypes assetType;
  @JsonKey(name: 'AUGGOLD99')
  final num aUGGOLD99;
  @JsonKey(name: 'LENDBOXP2P')
  final num lENDBOXP2P;
  final String createdOn;
  final String nextDue;

  const SubscriptionModel({
    this.id = '',
    this.subId = '',
    this.status = AutosaveState.IDLE,
    this.assetType = SIPAssetTypes.UNKNOWN,
    this.amount = 0,
    this.frequency = '',
    this.aUGGOLD99 = 0,
    this.lENDBOXP2P = 0,
    this.createdOn = '',
    this.nextDue = '',
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}
