import 'package:cloud_firestore/cloud_firestore.dart';

class AlertModel {
  String actionUri;
  Timestamp createdTime;
  String subtitle;
  String title;

  AlertModel({this.actionUri, this.createdTime, this.subtitle, this.title});

  AlertModel.fromJson(Map<String, dynamic> json) {
    actionUri = json['actionUri'];
    createdTime = json['created_time'];
    subtitle = json['subtitile'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actionUri'] = this.actionUri;
    data['created_time'] = this.createdTime;
    data['subtitile'] = this.subtitle;
    data['title'] = this.title;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'actionUri': actionUri,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'subtitile': subtitle,
      'title': title,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      actionUri: map['actionUri'],
      createdTime: map['created_time'],
      subtitle: map['subtitle'],
      title: map['title'],
    );
  }
}
