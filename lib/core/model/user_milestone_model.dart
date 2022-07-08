import 'dart:convert';

UserMilestoneModel userMilestoneModelFromJson(String str) =>
    UserMilestoneModel.fromJson(json.decode(str));

String userMilestoneModelToJson(UserMilestoneModel data) =>
    json.encode(data.toJson());

class UserMilestoneModel {
  UserMilestoneModel({
    this.message,
    this.data,
  });

  String message;
  List<UserMilestone> data;

  factory UserMilestoneModel.fromJson(Map<String, dynamic> json) =>
      UserMilestoneModel(
        message: json["message"],
        data: List<UserMilestone>.from(
          json["data"].map((x) => UserMilestone.fromMap(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(
          data.map((x) => x.toMap()),
        ),
      };
}

class UserMilestone {
  UserMilestone({
    this.id,
    this.title,
    this.actionUri,
    this.prizeSubtype,
    this.flc,
    this.amt,
    this.isCompleted,
  });

  String id;
  String title;
  String actionUri;
  String prizeSubtype;
  int flc;
  int amt;
  bool isCompleted;

  factory UserMilestone.fromMap(Map<String, dynamic> map) => UserMilestone(
        id: map["id"],
        title: map["title"],
        actionUri: map["actionUri"] == null ? null : map["actionUri"],
        prizeSubtype: map["prizeSubtype"],
        flc: map["flc"] ?? 0,
        amt: map["amt"] ?? 0,
        isCompleted: map["isCompleted"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "actionUri": actionUri == null ? null : actionUri,
        "prizeSubtype": prizeSubtype,
        "flc": flc ?? 0,
        "amt": amt ?? 0,
        "isCompleted": isCompleted ?? false,
      };
}
