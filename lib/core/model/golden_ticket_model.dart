import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GoldenTicket {
  String gtId;
  String userId;
  String ticketId;
  Timestamp timestamp;
  Timestamp redeemedTimestamp;
  Timestamp revealedTimestamp;
  String eventType;
  String gtType;
  bool canTransfer;
  bool isRewarding;
  String version;
  List<Reward> rewardArr;
  //Map<String, dynamic> ownershipMap;

  GoldenTicket({
    this.gtId,
    this.userId,
    this.timestamp,
    this.eventType,
    this.gtType,
    this.canTransfer,
    //this.ownershipMap,
    this.isRewarding,
    this.rewardArr,
    this.ticketId,
    this.redeemedTimestamp,
    this.revealedTimestamp,
    this.version,
  });

  GoldenTicket.fromJson(Map<String, dynamic> json, String docId) {
    gtId = docId;
    userId = json['userId'];
    timestamp = json['timestamp'];
    eventType = json['eventType'];
    gtType = json['gtType'];
    canTransfer = json['canTransfer'];
    isRewarding = json['isRewarding'];
    redeemedTimestamp = json['redeemedTimestamp'];
    revealedTimestamp = json['revealedTimestamp'];
    //ownershipMap = json['ownershipMap'] ?? [];
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