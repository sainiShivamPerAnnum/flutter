import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_subscription_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class AllSubscriptionModel {
  int? length;
  bool? isActive;
  List<SubscriptionModel>? subs;

  AllSubscriptionModel({this.length, this.isActive, this.subs});
  factory AllSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$AllSubscriptionModelFromJson(json);
}
