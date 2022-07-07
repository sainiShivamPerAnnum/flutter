// import 'package:cloud_firestore/cloud_firestore.dart';

class AlertModel {
  String id;
  String actionUri;
  CreatedAt createdTime;
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
    data['created_time'] = this.createdTime.toJson();
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
      createdTime: CreatedAt.fromMap(map["created_time"]),
      subtitle: map['subtitle'],
      title: map['title'],
    );
  }

  @override
  String toString() {
    return 'AlertModel(id: $id ,actionUri: $actionUri, createdTime: $createdTime, subtitle: $subtitle, title: $title)';
  }
}

class CreatedAt {
  CreatedAt({
    this.seconds,
    this.nanoseconds,
  });

  int seconds;
  int nanoseconds;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.seconds;
    data['_nanoseconds'] = this.nanoseconds;
    return data;
  }

  factory CreatedAt.fromMap(Map<String, dynamic> json) => CreatedAt(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toMap() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };
}
