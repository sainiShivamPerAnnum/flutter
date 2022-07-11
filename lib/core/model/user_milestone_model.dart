import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';

class UserMilestone {
  final String id;
  final String actionUri;
  final String prizeSubtype;
  final String title;
  final int flc;
  final int amt;
  bool isCompleted;
  static final helper = HelperModel<UserMilestone>(
    (map) => UserMilestone.fromMap(map),
  );
  UserMilestone({
    this.id,
    this.actionUri,
    this.prizeSubtype,
    this.title,
    this.flc,
    this.amt,
    this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'actionUri': actionUri,
      'prizeSubtype': prizeSubtype,
      'title': title,
      'flc': flc,
      'amt': amt,
      'isCompleted': isCompleted,
    };
  }

  factory UserMilestone.fromMap(Map<String, dynamic> map) {
    return UserMilestone(
      id: map['id'] ?? 0,
      actionUri: map['actionUri'] ?? '',
      prizeSubtype: map['prizeSubtype'] ?? '',
      title: map['title'],
      flc: map['flc'] ?? 0,
      amt: map['amt'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMilestone.fromJson(String source) =>
      UserMilestone.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserMilestoneModel(id: $id, actionUri: $actionUri, prizeSubtype: $prizeSubtype, title: $title, flc: $flc, amt: $amt, isCompleted: $isCompleted)';
  }
}
