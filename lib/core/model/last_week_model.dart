class LastWeekModel {
  LastWeekModel({
    this.message,
    this.data,
  });

  final String? message;
  final LastWeekData? data;

  LastWeekModel copyWith({
    String? message,
    LastWeekData? data,
  }) =>
      LastWeekModel(
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory LastWeekModel.fromJson(Map<String, dynamic> json) => LastWeekModel(
        message: json["message"],
        data: json["data"] == null ? null : LastWeekData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class LastWeekData {
  LastWeekData({
    this.main,
    this.user,
    this.misc,
    this.cta,
    this.isTopSaver,
  });

  final Main? main;
  final UserLastWeekData? user;
  final List<Misc>? misc;
  final Cta? cta;
  final bool? isTopSaver;

  factory LastWeekData.fromJson(Map<String, dynamic> json) => LastWeekData(
        main: json["global"] == null ? null : Main.fromJson(json["global"]),
        user: json["user"] == null
            ? null
            : UserLastWeekData.fromJson(json["user"]),
        misc: json["misc"] == null
            ? []
            : List<Misc>.from(json["misc"]!.map((x) => Misc.fromJson(x))),
        isTopSaver: json["isTopSaver"],
        cta: json["cta"] == null ? null : Cta.fromJson(json["cta"]),
      );

  Map<String, dynamic> toJson() => {
        "main": main?.toJson(),
        "user": user,
        "misc": misc == null
            ? []
            : List<dynamic>.from(misc!.map((x) => x.toJson())),
        "isTopSaver": isTopSaver,
        "cta": cta?.toJson(),
      };
}

class Main {
  Main({
    this.investments,
    this.returns,
    this.tambolaPrizeAmt,
  });

  final Investments? investments;
  final Investments? returns;
  final int? tambolaPrizeAmt;

  Main copyWith({
    Investments? investments,
    Investments? returns,
    int? tambolaPrizeAmt,
  }) =>
      Main(
        investments: investments ?? this.investments,
        returns: returns ?? this.returns,
        tambolaPrizeAmt: tambolaPrizeAmt ?? this.tambolaPrizeAmt,
      );

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        investments: json["investments"] == null
            ? null
            : Investments.fromJson(json["investments"]),
        returns: json["returns"] == null
            ? null
            : Investments.fromJson(json["returns"]),
        tambolaPrizeAmt: json["tambolaPrizeAmt"],
      );

  Map<String, dynamic> toJson() => {
        "investments": investments?.toJson(),
        "returns": returns?.toJson(),
        "tambolaPrizeAmt": tambolaPrizeAmt,
      };
}

class Investments {
  Investments({
    this.auggold99,
    this.lendboxp2P,
  });

  final double? auggold99;
  final double? lendboxp2P;

  Investments copyWith({
    double? auggold99,
    double? lendboxp2P,
  }) =>
      Investments(
        auggold99: auggold99 ?? this.auggold99,
        lendboxp2P: lendboxp2P ?? this.lendboxp2P,
      );

  factory Investments.fromJson(Map<String, dynamic> json) => Investments(
        auggold99: json["AUGGOLD99"]?.toDouble(),
        lendboxp2P: json["LENDBOXP2P"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "AUGGOLD99": auggold99,
        "LENDBOXP2P": lendboxp2P,
      };
}

class Misc {
  Misc({
    this.iconUrl,
    this.title,
    this.subtitle,
    this.numeric,
    this.bgHex,
  });

  final String? iconUrl;
  final String? title;
  final String? subtitle;
  final String? numeric;
  final String? bgHex;

  Misc copyWith({
    String? iconUrl,
    String? title,
    String? subtitle,
    String? numeric,
    String? bgHex,
  }) =>
      Misc(
        iconUrl: iconUrl ?? this.iconUrl,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        numeric: numeric ?? this.numeric,
        bgHex: bgHex ?? this.bgHex,
      );

  factory Misc.fromJson(Map<String, dynamic> json) => Misc(
        iconUrl: json["iconUrl"],
        title: json["title"],
        subtitle: json["subtitle"],
        numeric: json["numeric"],
        bgHex: json["bgHex"],
      );

  Map<String, dynamic> toJson() => {
        "iconUrl": iconUrl,
        "title": title,
        "subtitle": subtitle,
        "numeric": numeric,
        "bgHex": bgHex,
      };
}

class UserLastWeekData {
  UserLastWeekData({
    this.gainsPerc,
    this.invested,
    this.returns,
  });

  final double? gainsPerc;
  final int? invested;
  final double? returns;

  UserLastWeekData copyWith({
    double? gainsPerc,
    int? invested,
    double? returns,
  }) =>
      UserLastWeekData(
        gainsPerc: gainsPerc ?? this.gainsPerc,
        invested: invested ?? this.invested,
        returns: returns ?? this.returns,
      );

  factory UserLastWeekData.fromJson(Map<String, dynamic> json) =>
      UserLastWeekData(
        gainsPerc: json["gainsPerc"]?.toDouble(),
        invested: json["invested"],
        returns: json["returns"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "gainsPerc": gainsPerc,
        "invested": invested,
        "returns": returns,
      };
}

class Cta {
  Cta({
    this.text,
    this.iconUrl,
  });

  final String? text;
  final String? iconUrl;

  Cta copyWith({
    String? text,
    String? iconUrl,
  }) =>
      Cta(
        text: text ?? this.text,
        iconUrl: iconUrl ?? this.iconUrl,
      );

  factory Cta.fromJson(Map<String, dynamic> json) => Cta(
        text: json["text"],
        iconUrl: json["iconUrl"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "iconUrl": iconUrl,
      };
}
