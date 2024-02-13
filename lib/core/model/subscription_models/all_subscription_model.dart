import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_subscription_model.g.dart';

@JsonSerializable(
  createToJson: false,
)
class Subscriptions {
  final int length;
  final bool isActive;
  final List<SubscriptionModel> subs;

  const Subscriptions({
    this.length = 0,
    this.isActive = false,
    this.subs = const [],
  });
  factory Subscriptions.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsFromJson(json);
}

extension SubscriptionsX on Subscriptions {
  num get totalSipInvestedAmount => subs.fold(
      0.0, (previousValue, element) => previousValue + element.amount);
}
