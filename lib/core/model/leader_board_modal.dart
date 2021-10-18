import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderBoardModal {
  String code;
  String gametype;
  String freq;
  Timestamp lastupdated;
  List<Scoreboard> scoreboard;

  LeaderBoardModal(
      {this.code, this.gametype, this.freq, this.lastupdated, this.scoreboard});

  LeaderBoardModal.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    gametype = json['gametype'];
    freq = json['freq'];
    lastupdated = json['lastupdated'];
    if (json['scoreboard'] != null) {
      scoreboard = <Scoreboard>[];
      json['scoreboard'].forEach((v) {
        scoreboard.add(new Scoreboard.fromJson(v));
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

  factory LeaderBoardModal.fromMap(Map<String, dynamic> map) {
    return LeaderBoardModal(
      code: map['code'],
      gametype: map['gametype'],
      freq: map['freq'],
      lastupdated: map['lastupdated'],
      scoreboard: List<Scoreboard>.from(
          map['scoreboard']?.map((x) => Scoreboard.fromMap(x))),
    );
  }
}

class Scoreboard {
  int score;
  int gametime;
  String userid;
  Timestamp timestamp;
  String username;

  Scoreboard(
      {this.score, this.gametime, this.userid, this.timestamp, this.username});

  Scoreboard.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    gametime = json['gametime'];
    userid = json['userid'];
    timestamp = json['timestamp'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['gametime'] = this.gametime;
    data['userid'] = this.userid;
    data['timestamp'] = this.timestamp;
    data['username'] = this.username;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'gametime': gametime,
      'userid': userid,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'username': username,
    };
  }

  factory Scoreboard.fromMap(Map<String, dynamic> map) {
    return Scoreboard(
      score: map['score'],
      gametime: map['gametime'],
      userid: map['userid'],
      timestamp: map['timestamp'],
      username: map['username'],
    );
  }
}
