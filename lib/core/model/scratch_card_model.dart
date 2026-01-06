// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';

class ScratchCard {
  String? gtId;
  bool? canTransfer;
  String? eventType;
  String? gtType;
  bool? isRewarding;
  bool? isLevelChange;
  String? note;
  String? prizeSubtype;
  TimestampModel? redeemedTimestamp;
  List<Reward>? rewardArr;
  TimestampModel? timestamp;
  String? userId;
  String? version;
  String? tag;

  ScratchCard(
      {this.gtId,
      this.userId,
      this.timestamp,
      this.eventType,
      this.isLevelChange,
      this.prizeSubtype,
      this.note,
      this.gtType,
      this.canTransfer,
      this.isRewarding,
      this.rewardArr,
      this.redeemedTimestamp,
      this.version,
      this.tag
    });

  factory ScratchCard.none() => ScratchCard.fromJson({}, '');

  factory ScratchCard.fromJson(Map<String, dynamic> json, String docId) {
    return ScratchCard(
      gtId: json['id'] ?? docId,
      canTransfer: json["canTransfer"] ?? false,
      eventType: json["eventType"] ?? '',
      gtType: json["gtType"] ?? '',
      isLevelChange: json["isLevelChange"] ?? false,
      isRewarding: json["isRewarding"] ?? false,
      note: json["note"] ?? '',
      prizeSubtype: json["prizeSubtype"] ?? '',
      userId: json["userId"] ?? '',
      version: json["version"],
      rewardArr:
          json['rewardArr'] != null ? Reward.objArray(json['rewardArr']) : [],
      timestamp: TimestampModel.fromMap(json['timestamp']),
      redeemedTimestamp: TimestampModel.fromMap(json['redeemedTimestamp']),
      tag: json["tag"],
    );

    // gtId = json['id'] ?? docId;
    // userId = json['userId'] ?? '';
    // timestamp = TimestampModel.fromMap(json['timestamp']);
    // eventType = json['eventType'] ?? '';
    // gtType = json['gtType'] ?? '';
    // isLevelChange = json['isLevelChange'] ?? false;
    // prizeSubtype = json['prizeSubtype'] ?? '';
    // note = json['note'] ?? '';
    // canTransfer = json['canTransfer'] ?? false;
    // isRewarding = json['isRewarding'] ?? false;
    // redeemedTimestamp = TimestampModel.fromMap(json['redeemedTimestamp']);
    // rewardArr =
    //     json['rewardArr'] != null ? Reward.objArray(json['rewardArr']) : [];
    // version = json['version'];
    // tag: json["tag"];
  }

  Map<String, dynamic> toJson() => {
        "id": gtId,
        "canTransfer": canTransfer,
        "eventType": eventType,
        "gtType": gtType,
        "isLevelChange": isLevelChange,
        "isRewarding": isRewarding,
        "note": note,
        "prizeSubtype": prizeSubtype,
        "userId": userId,
        "version": version,
        "rewardArr": rewardArr == null
            ? []
            : List<dynamic>.from(rewardArr!.map((x) => x.toJson())),
        "timestamp": timestamp?.toMap(),
        "redeemedTimestamp": redeemedTimestamp?.toMap(),
        "tag": tag,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScratchCard &&
          runtimeType == other.runtimeType &&
          gtId == other.gtId &&
          canTransfer == other.canTransfer &&
          eventType == other.eventType &&
          gtType == other.gtType &&
          isRewarding == other.isRewarding &&
          isLevelChange == other.isLevelChange &&
          note == other.note &&
          prizeSubtype == other.prizeSubtype &&
          redeemedTimestamp == other.redeemedTimestamp &&
          rewardArr == other.rewardArr &&
          timestamp == other.timestamp &&
          userId == other.userId &&
          version == other.version &&
          tag == other.tag;

  @override
  int get hashCode =>
      gtId.hashCode ^
      canTransfer.hashCode ^
      eventType.hashCode ^
      gtType.hashCode ^
      isRewarding.hashCode ^
      isLevelChange.hashCode ^
      note.hashCode ^
      prizeSubtype.hashCode ^
      redeemedTimestamp.hashCode ^
      rewardArr.hashCode ^
      timestamp.hashCode ^
      userId.hashCode ^
      version.hashCode ^
      tag.hashCode;

  @override
  String toString() {
    return 'ScratchCard{gtId: $gtId, canTransfer: $canTransfer, eventType: $eventType, gtType: $gtType, isRewarding: $isRewarding, isLevelChange: $isLevelChange, note: $note, prizeSubtype: $prizeSubtype, redeemedTimestamp: $redeemedTimestamp, rewardArr: $rewardArr, timestamp: $timestamp, userId: $userId, version: $version, tag: $tag}';
  }
}

class Reward {
  String? type;
  int? value;

  Reward({
    this.type,
    this.value,
  });

  static List<Reward> objArray(List<dynamic> list) {
    List<Reward> rewards = [];
    list.forEach((e) {
      rewards.add(Reward.fromMap(e));
    });
    return rewards;
  }

  Reward copyWith({
    String? type,
    int? value,
  }) {
    return Reward(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'value': value,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      type: map['type'] as String?,
      value: map['value'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Reward.fromJson(String source) =>
      Reward.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Reward(type: $type, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reward && other.type == type && other.value == value;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode;
}

// Why a reward map, why not directly a reward array
// with reward class object
