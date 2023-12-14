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
  final String heroImage;

  const BadgesLeaderBoardData({
    this.leaderBoard = const [],
    this.heroImage =
        'https://fello-dev-uploads.s3.ap-south-1.amazonaws.com/Group+1244832512.svg',
  });

  factory BadgesLeaderBoardData.fromJson(Map<String, dynamic> json) =>
      _$BadgesLeaderBoardDataFromJson(json);
}

@_deserializable
class LeaderBoard {
  final String name;
  final String uid;

  const LeaderBoard({
    this.name = '',
    this.uid = '',
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) =>
      _$LeaderBoardFromJson(json);
}
