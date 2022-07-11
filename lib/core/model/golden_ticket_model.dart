import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class GoldenTicket {
  String gtId;
  bool canTransfer;
  String eventType;
  String gtType;
  bool isRewarding;
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
    prizeSubtype = json['prizeSubtype'];
    note = json['note'];
    canTransfer = json['canTransfer'];
    isRewarding = json['isRewarding'];
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

  Reward.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  static List<Reward> objArray(List<dynamic> list) {
    List<Reward> rewards = [];
    list.forEach((e) {
      rewards.add(Reward.fromJson(e));
    });
    return rewards;
  }

  toString() {
    return "Type: $type || Value: $value";
  }
}

// Why a reward map, why not directly a reward array
// with reward class object
