import 'package:cloud_firestore/cloud_firestore.dart';

class TopSaversModel {
  String code;
  String gametype;
  // String freq;
  Timestamp lastupdated;
  List<TopSavers> scoreboard;

  TopSaversModel({
    this.code,
    this.gametype,
    // this.freq,
    this.lastupdated,
    this.scoreboard,
  });

  TopSaversModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    gametype = json['gametype'];
    // freq = json['freq'];
    lastupdated = json['lastupdated'];
    if (json['scoreboard'] != null) {
      scoreboard = <TopSavers>[];
      json['scoreboard'].forEach((v) {
        scoreboard.add(new TopSavers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['gametype'] = this.gametype;
    // data['freq'] = this.freq;
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
      // 'freq': freq,
      'lastupdated': lastupdated.millisecondsSinceEpoch,
      'scoreboard': scoreboard?.map((x) => x.toMap())?.toList(),
    };
  }

  factory TopSaversModel.fromMap(Map<String, dynamic> map) {
    return TopSaversModel(
      code: map['code'],
      gametype: map['gametype'],
      // freq: map['freq'],
      lastupdated: map['lastupdated'],
      scoreboard: List<TopSavers>.from(
          map['scoreboard']?.map((x) => TopSavers.fromMap(x))),
    );
  }
}

class TopSavers {
  int score;
  String userid;
  String username;

  TopSavers({this.score, this.userid, this.username});

  TopSavers.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    userid = json['userid'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    data['userid'] = this.userid;
    data['username'] = this.username;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'userid': userid,
      'username': username,
    };
  }

  factory TopSavers.fromMap(Map<String, dynamic> map) {
    return TopSavers(
      score: map['score'],
      userid: map['userid'],
      username: map['username'],
    );
  }
}
