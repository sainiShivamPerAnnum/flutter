import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class SubscriptionModel {
  String? id;
  String? subId;
  String? status;
  num? amount;
  String? frequency;
  @JsonKey(name: 'AUGGOLD99')
  num? aUGGOLD99;
  @JsonKey(name: 'LENDBOXP2P')
  num? lENDBOXP2P;
  String? resumeFrequency;
  String? createdOn;
  String? updatedOn;
  String? nextDue;

  SubscriptionModel({
    this.id,
    this.subId,
    this.status,
    this.amount,
    this.frequency,
    this.aUGGOLD99,
    this.lENDBOXP2P,
    this.resumeFrequency,
    this.createdOn,
    this.updatedOn,
    this.nextDue,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}
