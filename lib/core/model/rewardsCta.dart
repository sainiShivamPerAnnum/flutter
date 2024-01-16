import 'package:felloapp/core/model/action.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rewardsCta.g.dart';

@JsonSerializable()
class RewardsCta {
  String? label;
  String? style;
  Action? action;

  RewardsCta({this.label, this.style, this.action});

  factory RewardsCta.fromJson(Map<String, dynamic> json) => _$RewardsCtaFromJson(json);
  Map<String, dynamic> toJson() => _$RewardsCtaToJson(this);
}