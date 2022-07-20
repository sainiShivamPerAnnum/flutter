// import 'package:felloapp/core/model/timestamp_model.dart';

// class ReferralBoardModal {
//   ReferralBoardModal({
//     this.id,
//     this.freq,
//     this.gametype,
//     this.lastupdated,
//     this.scoreboard,
//     this.code,
//   });

//   String id;
//   String freq;
//   String gametype;
//   TimestampModel lastupdated;
//   List<ReferralBoard> scoreboard;
//   String code;

//   factory ReferralBoardModal.fromMap(Map<String, dynamic> map) =>
//       ReferralBoardModal(
//         id: map["id"],
//         freq: map["freq"],
//         gametype: map["gametype"],
//         lastupdated: TimestampModel.fromMap(map["lastupdated"]),
//         scoreboard: map["scoreboard"] == null
//             ? []
//             : List<ReferralBoard>.from(
//                 map["scoreboard"].map((x) => ReferralBoard.fromMap(x)),
//               ),
//         code: map["code"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "freq": freq,
//         "gametype": gametype,
//         "lastupdated": lastupdated.toMap(),
//         "scoreboard": List<dynamic>.from(scoreboard.map((x) => x.toMap())),
//         "code": code,
//       };
// }

// class ReferralBoard {
//   ReferralBoard({
//     this.username,
//     this.userid,
//     this.refCount,
//   });

//   String username;
//   String userid;
//   int refCount;

//   factory ReferralBoard.fromMap(Map<String, dynamic> map) => ReferralBoard(
//         username: map["username"],
//         userid: map["userid"],
//         refCount: map["refCount"],
//       );

//   Map<String, dynamic> toMap() => {
//         "username": username,
//         "userid": userid,
//         "refCount": refCount,
//       };
// }
