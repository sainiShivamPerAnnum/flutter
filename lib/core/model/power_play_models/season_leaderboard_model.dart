import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';

class SeasonLeaderboardItemModel {
  final String uid;
  final String uName;
  final int value;
  SeasonLeaderboardItemModel({
    required this.uid,
    required this.uName,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'value': value,
    };
  }

  static final helper = HelperModel<SeasonLeaderboardItemModel>(
      SeasonLeaderboardItemModel.fromMap);

  factory SeasonLeaderboardItemModel.fromMap(Map<String, dynamic> map) {
    return SeasonLeaderboardItemModel(
      uid: map['uid'] ?? "",
      uName: map["uName"] ?? "",
      value: map['value'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SeasonLeaderboardItemModel.fromJson(String source) =>
      SeasonLeaderboardItemModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SeasonLeaderboardItemModel(uid: $uid, value: $value)';

  @override
  bool operator ==(covariant SeasonLeaderboardItemModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.value == value;
  }

  @override
  int get hashCode => uid.hashCode ^ value.hashCode;
}
