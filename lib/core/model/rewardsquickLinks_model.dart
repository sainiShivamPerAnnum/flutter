// ignore_for_file: constant_identifier_names

import 'package:felloapp/core/model/rewardsCta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rewardsquickLinks_model.g.dart';

enum RewardsType {
  ticket,
  rupee,
}

@JsonSerializable(
  createToJson: false,
)
class RewardsQuickLinksModel {
  final String title;
  final String subTitle;
  final String rewardText;
  final RewardsType rewardType;
  final int rewardCount;
  final String imageUrl;
  final List<RewardsCta> cta;

  RewardsQuickLinksModel({
    this.title = '',
    this.subTitle = '',
    this.rewardText = '',
    this.rewardType = RewardsType.ticket,
    this.rewardCount = 0,
    this.imageUrl = '',
    this.cta = const [],
  });

  factory RewardsQuickLinksModel.fromJson(Map<String, dynamic> json) =>
      _$RewardsQuickLinksModelFromJson(json);
}
