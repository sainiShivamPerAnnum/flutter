class FelloBadgesModel {
  final String? message;
  final FelloBadgesData? data;

  FelloBadgesModel({
    this.message,
    this.data,
  });

  factory FelloBadgesModel.fromJson(Map<String, dynamic> json) =>
      FelloBadgesModel(
        message: json["message"],
        data: json["data"] == null
            ? null
            : FelloBadgesData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class FelloBadgesData {
  final String? title;
  final String? titleColor;
  final List<Level>? levels;
  final SuperFelloWorks? superFelloWorks;
  final int? currentLevel;

  FelloBadgesData({
    this.title,
    this.titleColor,
    this.levels,
    this.superFelloWorks,
    this.currentLevel,
  });

  factory FelloBadgesData.fromJson(Map<String, dynamic> json) =>
      FelloBadgesData(
        title: json["title"],
        titleColor: json["titleColor"],
        levels: json["levels"] == null
            ? []
            : List<Level>.from(json["levels"]!.map((x) => Level.fromJson(x))),
        superFelloWorks: json["superFelloWorks"] == null
            ? null
            : SuperFelloWorks.fromJson(json["superFelloWorks"]),
        currentLevel: 1,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "titleColor": titleColor,
        "levels": levels == null
            ? []
            : List<dynamic>.from(levels!.map((x) => x.toJson())),
        "superFelloWorks": superFelloWorks?.toJson(),
      };
}

class Level {
  final String? badgeurl;
  final List<String>? benefits;
  final List<LvlDatum>? lvlData;
  final bool? isCompleted;

  Level({
    this.badgeurl,
    this.benefits,
    this.lvlData,
    this.isCompleted,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        badgeurl: json["badgeurl"],
        benefits: json["benefits"] == null
            ? []
            : List<String>.from(json["benefits"]!.map((x) => x)),
        isCompleted: false,
        lvlData: json["lvl_data"] == null
            ? []
            : List<LvlDatum>.from(
                json["lvl_data"]!.map((x) => LvlDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "badgeurl": badgeurl,
        "benefits":
            benefits == null ? [] : List<dynamic>.from(benefits!.map((x) => x)),
        "isCompleted": isCompleted,
        "lvl_data": lvlData == null
            ? []
            : List<dynamic>.from(lvlData!.map((x) => x.toJson())),
      };
}

class LvlDatum {
  final double? achieve;
  final String? title;
  final String? barHeading;
  final String? badgeurl;
  final String? referText;
  final String? bottomSheetText;
  final String? bottomSheetCta;
  final String? ctaUrl;
  final DateTime? updatedAt;

  LvlDatum({
    this.achieve,
    this.title,
    this.barHeading,
    this.badgeurl,
    this.referText,
    this.bottomSheetText,
    this.bottomSheetCta,
    this.ctaUrl,
    this.updatedAt,
  });

  factory LvlDatum.fromJson(Map<String, dynamic> json) => LvlDatum(
        achieve: json["achieve"]?.toDouble(),
        title: json["title"],
        barHeading: json["barHeading"],
        badgeurl: json["badgeurl"],
        referText: json["referText"],
        bottomSheetText: json["bottomSheetText"],
        bottomSheetCta: json["bottomSheetCta"],
        ctaUrl: json["cta_url"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "achieve": achieve,
        "title": title,
        "barHeading": barHeading,
        "badgeurl": badgeurl,
        "referText": referText,
        "bottomSheetText": bottomSheetText,
        "bottomSheetCta": bottomSheetCta,
        "cta_url": ctaUrl,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class SuperFelloWorks {
  final String? mainText;
  final List<String>? subText;

  SuperFelloWorks({
    this.mainText,
    this.subText,
  });

  factory SuperFelloWorks.fromJson(Map<String, dynamic> json) =>
      SuperFelloWorks(
        mainText: json["main_text"],
        subText: json["sub_text"] == null
            ? []
            : List<String>.from(json["sub_text"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() =>
      {
        "main_text": mainText,
        "sub_text":
            subText == null ? [] : List<dynamic>.from(subText!.map((x) => x)),
      };
}
