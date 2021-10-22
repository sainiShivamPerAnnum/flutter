import 'package:cloud_firestore/cloud_firestore.dart';

class WinnersModel {
  List<Winners> winners;
  String code;
  String gametype;
  String freq;
  Timestamp timestamp;

  WinnersModel(
      {this.winners, this.code, this.gametype, this.freq, this.timestamp});

  WinnersModel.fromJson(Map<String, dynamic> json) {
    if (json['winners'] != null) {
      winners = <Winners>[];
      json['winners'].forEach((v) {
        winners.add(new Winners.fromJson(v));
      });
    }
    code = json['code'];
    gametype = json['gametype'];
    freq = json['freq'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.winners != null) {
      data['winners'] = this.winners.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['gametype'] = this.gametype;
    data['freq'] = this.freq;
    data['timestamp'] = this.timestamp;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'winners': winners?.map((x) => x.toMap())?.toList(),
      'code': code,
      'gametype': gametype,
      'freq': freq,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory WinnersModel.fromMap(Map<String, dynamic> map, String gameType) {
    return WinnersModel(
      winners:
          List<Winners>.from(map['winners']?.map((x) => Winners.fromMap(x,gameType))),
      code: map['code'],
      gametype: map['gametype'],
      freq: map['freq'],
      timestamp: map['timestamp'],
    );
  }

  @override
  String toString() {
    return 'WinnersModel(winners: $winners, code: $code, gametype: $gametype, freq: $freq, timestamp: $timestamp)';
  }
}

class Winners {
  int score;
  String userid;
  String username;
  String gameType;

  Winners({this.score, this.userid, this.username,this.gameType});

  Winners.fromJson(Map<String, dynamic> json) {
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

  factory Winners.fromMap(Map<String, dynamic> map, String gameType) {
    return Winners(
      score: map['score'],
      userid: map['userid'],
      username: map['username'],
      gameType: gameType,
    );
  }

  @override
  String toString() =>
      'Winners(score: $score, userid: $userid, username: $username, gameType: $gameType)';
}
