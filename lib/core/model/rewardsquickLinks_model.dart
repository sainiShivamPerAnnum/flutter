// ignore_for_file: constant_identifier_names

import 'package:felloapp/core/model/rewardsCta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rewardsquickLinks_model.g.dart';

enum RewardsType {
  ticket('ticket'),
  rupee('rupee');
  const RewardsType(this.type);
  final String type;
}

@JsonSerializable()
class RewardsQuickLinksModel {
  String? title;
  String? subTitle;
  String? rewardText;
  RewardsType? rewardType;
  int? rewardCount;
  String? imageUrl;
  List<RewardsCta>? cta;

  RewardsQuickLinksModel(
      {this.title,
      this.subTitle,
      this.rewardText,
      this.rewardType,
      this.rewardCount,
      this.imageUrl,
      this.cta});

  factory RewardsQuickLinksModel.fromJson(Map<String, dynamic> json) =>
      _$RewardsQuickLinksModelFromJson(json);
  Map<String, dynamic> toJson() => _$RewardsQuickLinksModelToJson(this);
}
