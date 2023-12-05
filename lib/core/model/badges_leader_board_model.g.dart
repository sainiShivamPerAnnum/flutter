// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badges_leader_board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadgesLeaderBoardModel _$BadgesLeaderBoardModelFromJson(
        Map<String, dynamic> json) =>
    BadgesLeaderBoardModel(
      data:
          BadgesLeaderBoardData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );

BadgesLeaderBoardData _$BadgesLeaderBoardDataFromJson(
        Map<String, dynamic> json) =>
    BadgesLeaderBoardData(
      leaderBoard: (json['leaderBoard'] as List<dynamic>?)
              ?.map((e) => LeaderBoard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      otherBadges: (json['otherBadges'] as List<dynamic>?)
              ?.map((e) => OtherBadge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

LeaderBoard _$LeaderBoardFromJson(Map<String, dynamic> json) => LeaderBoard(
      name: json['name'] as String? ?? '',
      totalSaving: json['totalSaving'] as num? ?? 0.0,
      uid: json['uid'] as String? ?? '',
    );

OtherBadge _$OtherBadgeFromJson(Map<String, dynamic> json) => OtherBadge(
      url: json['url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      action: json['action'] as String? ?? '',
      buttonText: json['buttonText'] as String? ?? '',
      referText: json['referText'] as String? ?? '',
      bottomSheetText: json['bottomSheetText'] as String? ?? '',
      bottomSheetCta: json['bottomSheetCta'] as String? ?? '',
      ctaUrl: json['ctaUrl'] as String? ?? '',
    );
