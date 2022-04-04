import 'package:cloud_firestore/cloud_firestore.dart';

class GoldenTicket {
  String gtId;
  bool canTransfer;
  String eventType;
  String gtType;
  bool isRewarding;
  String note;
  String prizeSubtype;
  Timestamp redeemedTimestamp;
  List<Reward> rewardArr;
  Timestamp timestamp;
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
    timestamp = json['timestamp'];
    eventType = json['eventType'];
    gtType = json['gtType'];
    prizeSubtype = json['prizeSubtype'];
    note = json['note'];
    canTransfer = json['canTransfer'];
    isRewarding = json['isRewarding'];
    redeemedTimestamp = json['redeemedTimestamp'];
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