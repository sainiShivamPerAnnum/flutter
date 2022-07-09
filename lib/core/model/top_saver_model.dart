import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class TopSaverModal {
  TopSaverModal({
    this.id,
    this.gametype,
    this.code,
    this.lastupdated,
    this.scoreboard,
    this.freq,
  });

  String id;
  String gametype;
  String code;
  TimestampModel lastupdated;
  List<TopSaver> scoreboard;
  String freq;

  factory TopSaverModal.fromMap(Map<String, dynamic> map) => TopSaverModal(
        id: map["id"],
        gametype: map["gametype"],
        code: map["code"],
        lastupdated: map["lastupdated"] != null
            ? TimestampModel.fromMap(map["lastupdated"])
            : null,
        scoreboard: map["scoreboard"] == null
            ? []
            : List<TopSaver>.from(
                map["scoreboard"].map((x) => TopSaver.fromMap(x)),
              ),
        freq: map["freq"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "gametype": gametype,
        "code": code,
        "lastupdated": lastupdated.toMap(),
        "scoreboard": List<dynamic>.from(scoreboard.map((x) => x.toMap())),
        "freq": freq,
      };
}

class TopSaver {
  TopSaver({
    this.userid,
    this.username,
    this.score,
  });

  String userid;
  String username;
  double score;

  factory TopSaver.fromMap(Map<String, dynamic> map) => TopSaver(
        userid: map["userid"],
        username: map["username"],
        score: map["score"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "username": username,
        "score": score,
      };
}
