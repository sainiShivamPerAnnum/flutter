import 'dart:convert';

UserBootUp userBootUpFromJson(String str) =>
    UserBootUp.fromJson(json.decode(str));

String userBootUpToJson(UserBootUp data) => json.encode(data.toJson());

class UserBootUp {
  UserBootUp({
    this.message,
    this.data,
  });

  String message;
  Data data;

  factory UserBootUp.fromJson(Map<String, dynamic> json) => UserBootUp(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.cache,
    this.isBlocked,
    this.isAppUpdateRequired,
    this.isAppForcedUpdateRequired,
    this.notice,
    this.signOutUser,
  });

  Cache cache;
  bool isBlocked;
  bool isAppUpdateRequired;
  bool isAppForcedUpdateRequired;
  Notice notice;
  bool signOutUser;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cache: Cache.fromJson(json["cache"]),
        isBlocked: json["isBlocked"],
        isAppUpdateRequired: json["isAppUpdateRequired"],
        isAppForcedUpdateRequired: json["isAppForcedUpdateRequired"],
        notice: Notice.fromJson(json["notice"]),
        signOutUser: json["signOutUser"],
      );

  Map<String, dynamic> toJson() => {
        "cache": cache.toJson(),
        "isBlocked": isBlocked,
        "isAppUpdateRequired": isAppUpdateRequired,
        "isAppForcedUpdateRequired": isAppForcedUpdateRequired,
        "notice": notice.toJson(),
        "signOutUser": signOutUser,
      };
}

class Cache {
  Cache({
    this.before,
    this.keys,
  });

  Before before;
  List<dynamic> keys;

  factory Cache.fromJson(Map<String, dynamic> json) => Cache(
        before: Before.fromJson(json["before"]),
        keys: List<dynamic>.from(json["keys"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "before": before.toJson(),
        "keys": List<dynamic>.from(keys.map((x) => x)),
      };
}

class Before {
  Before({
    this.seconds,
    this.nanoseconds,
  });

  int seconds;
  int nanoseconds;

  factory Before.fromJson(Map<String, dynamic> json) => Before(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toJson() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };
}

class Notice {
  Notice({
    this.message,
    this.url,
    this.isFullScreen,
  });

  String message;
  String url;
  bool isFullScreen;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        message: json["message"],
        url: json["url"],
        isFullScreen: json["isFullScreen"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "url": url,
        "isFullScreen": isFullScreen,
      };
}
