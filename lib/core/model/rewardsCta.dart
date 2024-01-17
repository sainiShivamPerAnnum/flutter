import 'package:felloapp/core/model/action.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rewardsCta.g.dart';

@JsonSerializable(
  createToJson: false,
)
class RewardsCta {
  final Action? action;

  RewardsCta({
    this.action,
  });

  factory RewardsCta.fromJson(Map<String, dynamic> json) =>
      _$RewardsCtaFromJson(json);
}
