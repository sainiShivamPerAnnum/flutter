import 'dart:convert';

import 'package:felloapp/core/model/alert_model.dart';

UserNotificationModel userNotificationModelFromJson(String str) =>
    UserNotificationModel.fromJson(json.decode(str));

String userNotificationModelToJson(UserNotificationModel data) =>
    json.encode(data.toJson());

class UserNotificationModel {
  UserNotificationModel({
    this.notifications,
    this.lastDocId,
    this.alertsLength,
  });

  List<AlertModel> notifications;
  String lastDocId;
  int alertsLength;

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) =>
      UserNotificationModel(
        notifications: List<AlertModel>.from(
            json["notifications"].map((x) => AlertModel.fromJson(x))),
        lastDocId: json["lastDocId"],
        alertsLength: json["alertsLength"],
      );

  Map<String, dynamic> toJson() => {
        "notifications": List<AlertModel>.from(notifications.map((x) => x)),
        "lastDocId": lastDocId,
        "alertsLength": alertsLength,
      };
  factory UserNotificationModel.fromMap(Map<String, dynamic> map) {
    return UserNotificationModel(
      notifications: map["notifications"],
      lastDocId: map["lastDocId"],
      alertsLength: map["alertsLength"],
    );
  }
}
