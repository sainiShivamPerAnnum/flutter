import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class AlertModel {
  String? id;
  String? actionUri;
  TimestampModel? createdTime;
  String? subtitle;
  String? title;
  bool? isHighlighted = false;
  bool? isPersistent;
  String? ctaText;
  String? imageUrl;
  Misc? misc;

  static final helper = HelperModel<AlertModel>(AlertModel.fromMap);

  AlertModel(
      {this.id,
      this.actionUri,
      this.createdTime,
      this.subtitle,
      this.title,
      this.isHighlighted,
      this.isPersistent,
      this.ctaText,
      this.imageUrl,
      this.misc});

  AlertModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    actionUri = json['actionUri'] ?? '';
    createdTime =
        json['createdOn'] ?? TimestampModel(seconds: 0, nanoseconds: 0);
    subtitle = json['subtitile'] ?? '';
    title = json['title'] ?? '';
    misc = json["misc"] == null ? null : Misc.fromJson(json["misc"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['actionUri'] = actionUri;
    data['created_time'] = createdTime!.toMap();
    data['subtitile'] = subtitle;
    data['title'] = title;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'actionUri': actionUri,
      'createdTime': createdTime!.toMap(),
      'subtitile': subtitle,
      'title': title,
    };
  }

  factory AlertModel.fromMap(Map<String, dynamic> map) {
    return AlertModel(
      id: map['id'] ?? '',
      actionUri: map['actionUri'] ?? '',
      createdTime: TimestampModel.fromMap(map["createdOn"]),
      subtitle: map['subtitle'] ?? '',
      title: map['title'] ?? '',
      isPersistent: map['isPersistent'] ?? false,
      ctaText: map['ctaText'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      misc: map["misc"] == null ? null : Misc.fromJson(map["misc"]),
    );
  }

  @override
  String toString() {
    return 'AlertModel(id: $id ,actionUri: $actionUri, createdTime: $createdTime, subtitle: $subtitle, title: $title)';
  }
}

class Misc {
  final String? gtId;
  final String? command;
  final String? amount;
  final String? userType;
  final bool? isSuperFello;

  Misc(
      {this.command,
      this.gtId,
      this.amount,
      this.userType,
      this.isSuperFello = true});

  factory Misc.fromJson(Map<String, dynamic> json) => Misc(
        command: json["command"],
        gtId: json["gtId"],
        amount: json["amount"].toString(),
        userType: json["userType"],
      );

  Map<String, dynamic> toJson() => {
        "command": command,
        "gtId": gtId,
        "amount": amount,
        "userType": userType,
      };
}
