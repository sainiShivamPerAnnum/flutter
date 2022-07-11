// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:felloapp/core/model/helper_model.dart';
// import 'package:felloapp/core/model/timestamp_model.dart';

// class WinnersModel {
//   List<Winners> winners;
//   String code;
//   String gametype;
//   String freq;
//   TimestampModel timestamp;
//   static final helper = HelperModel<WinnersModel>(
//     (map) => WinnersModel.fromMap(map, map['gametype']),
//   );

//   WinnersModel({
//     this.winners,
//     this.code,
//     this.gametype,
//     this.freq,
//     this.timestamp,
//   });

//   WinnersModel.fromJson(Map<String, dynamic> json) {
//     if (json['winners'] != null) {
//       winners = <Winners>[];
//       json['winners'].forEach((v) {
//         winners.add(new Winners.fromJson(v));
//       });
//     }
//     code = json['code'];
//     gametype = json['gametype'];
//     freq = json['freq'];
//     timestamp = TimestampModel.fromMap(json['timestamp']);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'winners': winners?.map((x) => x.toMap())?.toList(),
//       'code': code,
//       'gametype': gametype,
//       'freq': freq,
//       'timestamp': timestamp.toMap(),
//     };
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'winners': winners?.map((x) => x.toMap())?.toList(),
//       'code': code,
//       'gametype': gametype,
//       'freq': freq,
//       'timestamp': timestamp,
//     };
//   }

//   factory WinnersModel.fromMap(Map<String, dynamic> map, String gameType) {
//     return WinnersModel(
//       winners: map['winners'] == null
//           ? []
//           : List<Winners>.from(
//               map['winners']?.map((x) => Winners.fromMap(x, gameType))),
//       code: map['code'],
//       gametype: map['gametype'],
//       freq: map['freq'],
//       timestamp: TimestampModel.fromMap(map['timestamp']),
//     );
//   }

//   @override
//   String toString() {
//     return 'WinnersModel(winners: $winners, code: $code, gametype: $gametype, freq: $freq, timestamp: $timestamp)';
//   }
// }

// class Winners {
//   double score;
//   int amount;
//   bool isMockUser;
//   int flc;
//   String userid;
//   String username;
//   String gameType;

//   Winners(
//       {this.score,
//       this.userid,
//       this.username,
//       this.gameType,
//       this.isMockUser,
//       this.amount,
//       this.flc});

//   Winners.fromJson(Map<String, dynamic> json) {
//     score = (json['score'] ?? 0).toDouble();
//     userid = json['userid'];
//     username = json['username'];
//     isMockUser = json['isMockUser'];
//     amount = json['amount'];
//     flc = json['flc'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['score'] = this.score;
//     data['userid'] = this.userid;
//     data['username'] = this.username;
//     data['amount'] = this.amount;
//     data['isMockUser'] = this.isMockUser;
//     data['flc'] = this.flc;
//     return data;
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'score': score,
//       'userid': userid,
//       'username': username,
//       'amount': amount,
//       'isMockUser': isMockUser,
//     };
//   }

//   factory Winners.fromMap(Map<String, dynamic> map, String gameType) {
//     return Winners(
//       score: (map['score'] ?? 0).toDouble(),
//       userid: map['userid'],
//       username: map['username'],
//       gameType: gameType,
//       amount: map['amount'],
//       flc: map['flc'],
//       isMockUser: map['isMockUser'],
//     );
//   }

//   @override
//   String toString() =>
//       'Winners(score: $score, userid: $userid, username: $username, gameType: $gameType, amount: $amount, isMockUser: $isMockUser)';
// }

import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class WinnersModel {
  final String id;
  final String freq;
  final List<Winners> winners;
  final String code;
  final TimestampModel timestamp;
  final String gametype;
  static final helper = HelperModel<WinnersModel>(
    (map) => WinnersModel.fromMap(map),
  );

  WinnersModel({
    this.id,
    this.freq,
    this.winners,
    this.code,
    this.timestamp,
    this.gametype,
  });

  WinnersModel copyWith({
    String id,
    String freq,
    List<Winners> winners,
    String code,
    TimestampModel timestamp,
    String gametype,
  }) {
    return WinnersModel(
      id: id ?? this.id,
      freq: freq ?? this.freq,
      winners: winners ?? this.winners,
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      gametype: gametype ?? this.gametype,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id ?? '',
      'freq': freq ?? '',
      'winners': winners.map((x) => x.toMap()).toList(),
      'code': code ?? '',
      'timestamp': timestamp.toMap(),
      'gametype': gametype ?? '',
    };
  }

  factory WinnersModel.fromMap(Map<String, dynamic> map) {
    return WinnersModel(
      id: map['id'] as String,
      freq: map['freq'] as String,
      winners: List<Winners>.from(
        map["winners"].map(
          (x) => Winners.fromMap(x, map['gametype']),
        ),
      ),
      code: map['code'] as String,
      timestamp: TimestampModel.fromMap(map['timestamp']),
      gametype: map['gametype'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WinnersModel.fromJson(String source) =>
      WinnersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WinnersModel(id: $id, freq: $freq, winners: $winners, code: $code, timestamp: $timestamp, gametype: $gametype)';
  }
}

class Winners {
  final int amount;
  final bool isMockUser;
  final String username;
  final int flc;
  final String userid;
  final String gameType;
  final int score;
  Winners({
    this.amount,
    this.isMockUser,
    this.username,
    this.flc,
    this.userid,
    this.score,
    this.gameType,
  });

  Winners copyWith(
      {int amount,
      bool isMockUser,
      String username,
      int flc,
      String userid,
      int score,
      String gameType}) {
    return Winners(
      amount: amount ?? this.amount,
      isMockUser: isMockUser ?? this.isMockUser,
      username: username ?? this.username,
      flc: flc ?? this.flc,
      userid: userid ?? this.userid,
      score: score ?? this.score,
      gameType: gameType ?? this.gameType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'isMockUser': isMockUser,
      'username': username,
      'flc': flc,
      'userid': userid,
      'score': score,
      'gameType': gameType,
    };
  }

  factory Winners.fromMap(Map<String, dynamic> map, String gameType) {
    return Winners(
      amount: map['amount'] ?? 0,
      isMockUser: map['isMockUser'] ?? false,
      username: map['username'] ?? '',
      flc: map['flc'] ?? 0,
      userid: map['userid'] ?? '',
      score: map['score'] ?? 0,
      gameType: gameType ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Winners.fromJson(String source, String gameType) =>
      Winners.fromMap(json.decode(source) as Map<String, dynamic>, gameType);

  @override
  String toString() {
    return 'Winners(amount: $amount, isMockUser: $isMockUser, username: $username, flc: $flc, userid: $userid, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Winners &&
        other.amount == amount &&
        other.isMockUser == isMockUser &&
        other.username == username &&
        other.flc == flc &&
        other.userid == userid &&
        other.score == score &&
        other.gameType == gameType;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        isMockUser.hashCode ^
        username.hashCode ^
        flc.hashCode ^
        userid.hashCode ^
        score.hashCode ^
        gameType.hashCode;
  }
}
