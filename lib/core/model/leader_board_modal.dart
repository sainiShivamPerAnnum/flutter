// import 'package:felloapp/core/model/timestamp_model.dart';

// class LeaderBoardModal {
//   LeaderBoardModal({
//     this.id,
//     this.freq,
//     this.gametype,
//     this.code,
//     this.scoreboard,
//     this.lastupdated,
//   });

//   String id;
//   String freq;
//   String gametype;
//   String code;
//   List<LeaderBoard> scoreboard;
//   TimestampModel lastupdated;

//   factory LeaderBoardModal.fromMap(Map<String, dynamic> map) =>
//       LeaderBoardModal(
//         id: map["id"],
//         freq: map["freq"],
//         gametype: map["gametype"],
//         code: map["code"],
//         scoreboard: List<LeaderBoard>.from(
//             map["scoreboard"].map((x) => LeaderBoard.fromMap(x))),
//         lastupdated: TimestampModel.fromMap(map["lastupdated"]),
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "freq": freq,
//         "gametype": gametype,
//         "code": code,
//         "scoreboard": List<dynamic>.from(scoreboard.map((x) => x.toMap())),
//         "lastupdated": lastupdated.toMap(),
//       };
// }

// class LeaderBoard {
//   LeaderBoard({
//     this.isUserEligible,
//     this.timestamp,
//     this.userid,
//     this.username,
//     this.score,
//     this.gameDuration,
//   });

//   bool isUserEligible;
//   TimestampModel timestamp;
//   String userid;
//   String username;
//   int score;
//   int gameDuration;

//   factory LeaderBoard.fromMap(Map<String, dynamic> map) => LeaderBoard(
//         isUserEligible: map["isUserEligible"],
//         timestamp: TimestampModel.fromMap(map["timestamp"]),
//         userid: map["userid"],
//         username: map["username"],
//         score: map["score"],
//         gameDuration: map["gameDuration"],
//       );

//   Map<String, dynamic> toMap() => {
//         "isUserEligible": isUserEligible,
//         "timestamp": timestamp.toMap(),
//         "userid": userid,
//         "username": username,
//         "score": score,
//         "gameDuration": gameDuration,
//       };
// }
