import 'package:json_annotation/json_annotation.dart';

part 'badges_leader_board_model.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class BadgesLeaderBoardModel {
  final String message;
  final BadgesLeaderBoardData data;

  const BadgesLeaderBoardModel({
    required this.data,
    this.message = '',
  });

  factory BadgesLeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      _$BadgesLeaderBoardModelFromJson(json);
}

@_deserializable
class BadgesLeaderBoardData {
  final List<LeaderBoard> leaderBoard;
  final List<OtherBadge> otherBadges;

  const BadgesLeaderBoardData({
    this.leaderBoard = const [],
    this.otherBadges = const [],
  });

  factory BadgesLeaderBoardData.fromJson(Map<String, dynamic> json) =>
      _$BadgesLeaderBoardDataFromJson(json);
}

@_deserializable
class LeaderBoard {
  final String name;
  final num totalSaving;
  final String uid;

  const LeaderBoard({
    this.name = '',
    this.totalSaving = 0.0,
    this.uid = '',
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) =>
      _$LeaderBoardFromJson(json);
}

@_deserializable
class OtherBadge {
  final String url;
  final String title;
  final bool enable;
  final String description;
  final String action;
  final String buttonText;
  final String referText;
  final String bottomSheetText;
  final String bottomSheetCta;
  final String ctaUrl;

  const OtherBadge({
    this.url = '',
    this.title = '',
    this.enable = false,
    this.description = '',
    this.action = '',
    this.buttonText = '',
    this.referText = '',
    this.bottomSheetText = '',
    this.bottomSheetCta = '',
    this.ctaUrl = '',
  });

  factory OtherBadge.fromJson(Map<String, dynamic> json) =>
      _$OtherBadgeFromJson(json);
}
