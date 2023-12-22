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
      heroImage: json['heroImage'] as String? ??
          'https://fello-dev-uploads.s3.ap-south-1.amazonaws.com/Group+1244832512.svg',
    );

LeaderBoard _$LeaderBoardFromJson(Map<String, dynamic> json) => LeaderBoard(
      name: json['name'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
    );
