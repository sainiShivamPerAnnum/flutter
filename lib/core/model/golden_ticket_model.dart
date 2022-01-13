import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GoldenTicket {
  String gtId;
  String ticketId;
  Timestamp createdOn;
  Timestamp redeemedTimestamp;
  Timestamp revealedTimestamp;
  String eventType;
  String gtType;
  bool isTransferrable;
  String version;
  List<Reward> rewards;
  Map<String, dynamic> ownershipMap;

  GoldenTicket({
    this.gtId,
    this.createdOn,
    this.eventType,
    this.gtType,
    this.isTransferrable,
    this.ownershipMap,
    this.rewards,
    this.ticketId,
    this.redeemedTimestamp,
    this.revealedTimestamp,
    this.version,
  });

  GoldenTicket.fromJson(Map<String, dynamic> json, String docId) {
    gtId = docId;
    createdOn = json['createdTimestamp'];
    eventType = json['eventType'];
    gtType = json['gtType'];
    isTransferrable = json['isTransferrable'];
    redeemedTimestamp = json['redeemedTimestamp'];
    revealedTimestamp = json['revealedTimestamp'];
    ownershipMap = json['ownershipMap'] ?? [];
    rewards = json['rewards'] != null ? Reward.objArray(json['rewards']) : [];
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
}


// Why a reward map, why not directly a reward array
// with reward class object