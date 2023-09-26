class BadgesLeaderBoardModel {
  final String? message;
  final BadgesLeaderBoardData? data;

  BadgesLeaderBoardModel({
    this.message,
    this.data,
  });

  factory BadgesLeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      BadgesLeaderBoardModel(
        message: json["message"],
        data: json["data"] == null
            ? null
            : BadgesLeaderBoardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class BadgesLeaderBoardData {
  final List<LeaderBoard>? leaderBoard;
  final SuperFelloWorks? superFelloWorks;
  final List<OtherBadge>? otherBadges;

  BadgesLeaderBoardData({
    this.leaderBoard,
    this.superFelloWorks,
    this.otherBadges,
  });

  factory BadgesLeaderBoardData.fromJson(Map<String, dynamic> json) =>
      BadgesLeaderBoardData(
        leaderBoard: json["leaderBoard"] == null
            ? []
            : List<LeaderBoard>.from(
                json["leaderBoard"]!.map((x) => LeaderBoard.fromJson(x))),
        superFelloWorks: json["superFelloWorks"] == null
            ? null
            : SuperFelloWorks.fromJson(json["superFelloWorks"]),
        otherBadges: json["otherBadges"] == null
            ? []
            : List<OtherBadge>.from(
                json["otherBadges"]!.map((x) => OtherBadge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "leaderBoard": leaderBoard == null
            ? []
            : List<dynamic>.from(leaderBoard!.map((x) => x.toJson())),
        "superFelloWorks": superFelloWorks?.toJson(),
        "otherBadges": otherBadges == null
            ? []
            : List<dynamic>.from(otherBadges!.map((x) => x.toJson())),
      };
}

class LeaderBoard {
  final String? name;
  final int? totalSaving;
  final String? uid;

  LeaderBoard({
    this.name,
    this.totalSaving,
    this.uid,
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) => LeaderBoard(
        name: json["name"],
        totalSaving: json["totalSaving"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "totalSaving": totalSaving,
        "uid": uid,
      };
}

class OtherBadge {
  final String? url;
  final String? title;
  final bool? enable;
  final String? description;
  final String? action;
  final String? buttonText;
  final String? referText;
  final String? bottomSheetText;
  final String? bottomSheetCta;
  final String? ctaUrl;

  OtherBadge({
    this.url,
    this.title,
    this.enable,
    this.description,
    this.action,
    this.buttonText,
    this.referText,
    this.bottomSheetText,
    this.bottomSheetCta,
    this.ctaUrl,
  });

  factory OtherBadge.fromJson(Map<String, dynamic> json) => OtherBadge(
        url: json["url"],
        title: json["title"],
        enable: json["enable"],
        description: json["description"],
        action: json["action"],
        buttonText: json["buttonText"],
        referText: json["referText"],
        bottomSheetText: json["bottomSheetText"],
        bottomSheetCta: json["bottomSheetCta"],
        ctaUrl: json["cta_url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "enable": enable,
        "description": description,
        "action": action,
        "buttonText": buttonText,
        "referText": referText,
        "bottomSheetText": bottomSheetText,
        "bottomSheetCta": bottomSheetCta,
        "cta_url": ctaUrl,
      };
}

class SuperFelloWorks {
  final String? title;
  final List<String>? list;

  SuperFelloWorks({
    this.title,
    this.list,
  });

  factory SuperFelloWorks.fromJson(Map<String, dynamic> json) =>
      SuperFelloWorks(
        title: json["title"],
        list: json["list"] == null
            ? []
            : List<String>.from(json["list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
      };
}

//BadgesLeaderBoardData
