import 'package:felloapp/core/model/timestamp_model.dart';

class AlertModel {
  String id;
  String actionUri;
  TimestampModel createdTime;
  String subtitle;
  String title;
  bool isHighlighted = false;

  AlertModel(
      {this.id, this.actionUri, this.createdTime, this.subtitle, this.title});

  AlertModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actionUri = json['actionUri'];
    createdTime = json['created_time'];
    subtitle = json['subtitile'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['actionUri'] = this.actionUri;
    data['created_time'] = this.createdTime.toMap();
    data['subtitile'] = this.subtitle;
    data['title'] = this.title;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'actionUri': actionUri,
      'createdTime': createdTime.toMap(),
      'subtitile': subtitle,
      'title': title,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'],
      actionUri: map['actionUri'],
      createdTime: TimestampModel.fromMap(map["created_time"]),
      subtitle: map['subtitle'],
      title: map['title'],
    );
  }

  @override
  String toString() {
    return 'AlertModel(id: $id ,actionUri: $actionUri, createdTime: $createdTime, subtitle: $subtitle, title: $title)';
  }
}
