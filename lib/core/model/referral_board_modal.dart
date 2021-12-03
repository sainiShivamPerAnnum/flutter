import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralBoardModal {
  String code;
  String gametype;
  String freq;
  Timestamp lastupdated;
  List<ReferralBoard> scoreboard;

  ReferralBoardModal({
    this.code,
    this.gametype,
    this.freq,
    this.lastupdated,
    this.scoreboard,
  });

  ReferralBoardModal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    gametype = json['gametype'];
    freq = json['freq'];
    lastupdated = json['lastupdated'];
    if (json['scoreboard'] != null) {
      scoreboard = <ReferralBoard>[];
      json['scoreboard'].forEach((v) {
        scoreboard.add(new ReferralBoard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['gametype'] = this.gametype;
    data['freq'] = this.freq;
    data['lastupdated'] = this.lastupdated;
    if (this.scoreboard != null) {
      data['scoreboard'] = this.scoreboard.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'gametype': gametype,
      'freq': freq,
      'lastupdated': lastupdated.millisecondsSinceEpoch,
      'scoreboard': scoreboard?.map((x) => x.toMap())?.toList(),
    };
  }

  factory ReferralBoardModal.fromMap(Map<String, dynamic> map) {
    return ReferralBoardModal(
      code: map['code'],
      gametype: map['gametype'],
      freq: map['freq'],
      lastupdated: map['lastupdated'],
      scoreboard: List<ReferralBoard>.from(
          map['scoreboard']?.map((x) => ReferralBoard.fromMap(x))),
    );
  }
}

class ReferralBoard {
  int refCount;
  bool isUserEligible;
  String userid;
  Timestamp timestamp;
  String username;

  ReferralBoard(
      {this.refCount,
      this.isUserEligible,
      this.userid,
      this.timestamp,
      this.username});

  ReferralBoard.fromJson(Map<String, dynamic> json) {
    refCount = json['refCount'];
    isUserEligible = json['isUserEligible'];
    userid = json['userid'];
    timestamp = json['timestamp'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refCount'] = this.refCount;
    data['isUserEligible'] = this.isUserEligible;
    data['userid'] = this.userid;
    data['timestamp'] = this.timestamp;
    data['username'] = this.username;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'refCount': refCount,
      'isUserEligible': isUserEligible,
      'userid': userid,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'username': username,
    };
  }

  factory ReferralBoard.fromMap(Map<String, dynamic> map) {
    return ReferralBoard(
      refCount: map['refCount'],
      isUserEligible: map['isUserEligible'],
      userid: map['userid'],
      timestamp: map['timestamp'],
      username: map['username'],
    );
  }
}
