// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';

class GoldenTicket {
  String gtId;
  bool canTransfer;
  String eventType;
  String gtType;
  bool isRewarding;
  bool isLevelChange;
  String note;
  String prizeSubtype;
  TimestampModel redeemedTimestamp;
  List<Reward> rewardArr;
  TimestampModel timestamp;
  String userId;
  String version;

  GoldenTicket({
    this.gtId,
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
  });

  GoldenTicket.fromJson(Map<String, dynamic> json, String docId) {
    gtId = docId;
    userId = json['userId'];
    timestamp = TimestampModel.fromMap(json['timestamp']);
    eventType = json['eventType'];
    gtType = json['gtType'];
    isLevelChange = json['isLevelChange'] ?? false;
    prizeSubtype = json['prizeSubtype'];
    note = json['note'] ?? '';
    canTransfer = json['canTransfer'] ?? false;
    isRewarding = json['isRewarding'] ?? false;
    redeemedTimestamp = TimestampModel.fromMap(json['redeemedTimestamp']);
    rewardArr =
        json['rewardArr'] != null ? Reward.objArray(json['rewardArr']) : [];
    version = json['version'];
  }
}

class Reward {
  String type;
  int value;
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
    String type,
    int value,
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
      type: map['type'] as String,
      value: map['value'] as int,
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
