class LastWeekModel {
  LastWeekModel({
    this.global,
    this.user,
  });

  final Global? global;
  final User? user;

  LastWeekModel copyWith({
    Global? global,
    User? user,
  }) =>
      LastWeekModel(
        global: global ?? this.global,
        user: user ?? this.user,
      );

  factory LastWeekModel.fromJson(Map<String, dynamic> json) => LastWeekModel(
        global: json["global"] == null ? null : Global.fromJson(json["global"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "global": global?.toJson(),
        "user": user?.toJson(),
      };

  @override
  String toString() {
    return 'LastWeekModel{global: $global, user: $user}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LastWeekModel &&
          runtimeType == other.runtimeType &&
          global == other.global &&
          user == other.user;

  @override
  int get hashCode => global.hashCode ^ user.hashCode;
}

class Global {
  Global({
    this.main,
    this.others,
  });

  final List<Main>? main;
  final List<Other>? others;

  Global copyWith({
    List<Main>? main,
    List<Other>? others,
  }) =>
      Global(
        main: main ?? this.main,
        others: others ?? this.others,
      );

  factory Global.fromJson(Map<String, dynamic> json) => Global(
        main: json["main"] == null
            ? []
            : List<Main>.from(json["main"]!.map((x) => Main.fromJson(x))),
        others: json["others"] == null
            ? []
            : List<Other>.from(json["others"]!.map((x) => Other.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main": main == null
            ? []
            : List<dynamic>.from(main!.map((x) => x.toJson())),
        "others": others == null
            ? []
            : List<dynamic>.from(others!.map((x) => x.toJson())),
      };
}

class Main {
  Main({
    this.numeric,
    this.desc,
    this.iconUrl,
  });

  final String? numeric;
  final String? desc;
  final String? iconUrl;

  Main copyWith({
    String? numeric,
    String? desc,
    String? iconUrl,
  }) =>
      Main(
        numeric: numeric ?? this.numeric,
        desc: desc ?? this.desc,
        iconUrl: iconUrl ?? this.iconUrl,
      );

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        numeric: json["numeric"],
        desc: json["desc"],
        iconUrl: json["iconUrl"],
      );

  Map<String, dynamic> toJson() => {
        "numeric": numeric,
        "desc": desc,
        "iconUrl": iconUrl,
      };
}

class Other {
  Other({
    this.iconUrl,
    this.desc,
  });

  final String? iconUrl;
  final String? desc;

  Other copyWith({
    String? iconUrl,
    String? desc,
  }) =>
      Other(
        iconUrl: iconUrl ?? this.iconUrl,
        desc: desc ?? this.desc,
      );

  factory Other.fromJson(Map<String, dynamic> json) => Other(
        iconUrl: json["iconUrl"],
        desc: json["desc"],
      );

  Map<String, dynamic> toJson() => {
        "iconUrl": iconUrl,
        "desc": desc,
      };
}

class User {
  User({
    this.main,
    this.others,
  });

  final List<Main>? main;
  final List<Main>? others;

  User copyWith({
    List<Main>? main,
    List<Main>? others,
  }) =>
      User(
        main: main ?? this.main,
        others: others ?? this.others,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        main: json["main"] == null
            ? []
            : List<Main>.from(json["main"]!.map((x) => Main.fromJson(x))),
        others: json["others"] == null
            ? []
            : List<Main>.from(json["others"]!.map((x) => Main.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main": main == null
            ? []
            : List<dynamic>.from(main!.map((x) => x.toJson())),
        "others": others == null
            ? []
            : List<dynamic>.from(others!.map((x) => x.toJson())),
      };
}
