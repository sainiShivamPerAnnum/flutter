// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:felloapp/util/constants.dart';
import 'package:flutter/foundation.dart';

import 'package:felloapp/core/model/timestamp_model.dart';

class UserBootUpDetailsModel {
  final String message;
  final Data data;
  UserBootUpDetailsModel({
    @required this.message,
    @required this.data,
  });

  UserBootUpDetailsModel copyWith({
    String message,
    Data data,
  }) {
    return UserBootUpDetailsModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'data': data.toMap(),
    };
  }

  factory UserBootUpDetailsModel.fromMap(Map<String, dynamic> map) {
    return UserBootUpDetailsModel(
      message: map['message'] as String,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBootUpDetailsModel.fromJson(String source) =>
      UserBootUpDetailsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserBootUpDetailsModel(message: $message, data: $data)';

  @override
  bool operator ==(covariant UserBootUpDetailsModel other) {
    if (identical(this, other)) return true;

    return other.message == message && other.data == data;
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class Data {
  final Cache cache;
  final bool isBlocked;
  final bool isAppUpdateRequired;
  final bool isAppForcedUpdateRequired;
  final Notice notice;
  final bool signOutUser;
  final BanMap banMap;
  Data({
    @required this.cache,
    @required this.isBlocked,
    @required this.isAppUpdateRequired,
    @required this.isAppForcedUpdateRequired,
    @required this.notice,
    @required this.signOutUser,
    @required this.banMap,
  });

  Data copyWith({
    Cache cache,
    bool isBlocked,
    bool isAppUpdateRequired,
    bool isAppForcedUpdateRequired,
    Notice notice,
    bool signOutUser,
    BanMap banMap,
  }) {
    return Data(
      cache: cache ?? this.cache,
      isBlocked: isBlocked ?? this.isBlocked,
      isAppUpdateRequired: isAppUpdateRequired ?? this.isAppUpdateRequired,
      isAppForcedUpdateRequired:
          isAppForcedUpdateRequired ?? this.isAppForcedUpdateRequired,
      notice: notice ?? this.notice,
      signOutUser: signOutUser ?? this.signOutUser,
      banMap: banMap ?? this.banMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cache': cache.toMap(),
      'isBlocked': isBlocked,
      'isAppUpdateRequired': isAppUpdateRequired,
      'isAppForcedUpdateRequired': isAppForcedUpdateRequired,
      'notice': notice.toMap(),
      'signOutUser': signOutUser,
      'banMap': banMap.toMap(),
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      cache: map['cache'] != null
          ? Cache.fromMap(map['cache'] as Map<String, dynamic>)
          : null,
      isBlocked: map['isBlocked'] ?? false,
      isAppUpdateRequired: map['isAppUpdateRequired'] ?? false,
      isAppForcedUpdateRequired: map['isAppForcedUpdateRequired'] ?? false,
      notice: map['notice'] != null
          ? Notice.fromMap(map['notice'] as Map<String, dynamic>)
          : null,
      signOutUser: map['signOutUser'] ?? false,
      banMap: map['banMap'] != null
          ? BanMap.fromMap(map['banMap'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(cache: $cache, isBlocked: $isBlocked, isAppUpdateRequired: $isAppUpdateRequired, isAppForcedUpdateRequired: $isAppForcedUpdateRequired, notice: $notice, signOutUser: $signOutUser, banMap: $banMap)';
  }

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.cache == cache &&
        other.isBlocked == isBlocked &&
        other.isAppUpdateRequired == isAppUpdateRequired &&
        other.isAppForcedUpdateRequired == isAppForcedUpdateRequired &&
        other.notice == notice &&
        other.signOutUser == signOutUser &&
        other.banMap == banMap;
  }

  @override
  int get hashCode {
    return cache.hashCode ^
        isBlocked.hashCode ^
        isAppUpdateRequired.hashCode ^
        isAppForcedUpdateRequired.hashCode ^
        notice.hashCode ^
        signOutUser.hashCode ^
        banMap.hashCode;
  }
}

class Cache {
  TimestampModel before;
  List<dynamic> keys;
  Cache({
    @required this.before,
    @required this.keys,
  });

  Cache copyWith({
    TimestampModel before,
    List<dynamic> keys,
  }) {
    return Cache(
      before: before ?? this.before,
      keys: keys ?? this.keys,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'before': before.toMap(),
      'keys': keys,
    };
  }

  factory Cache.fromMap(Map<String, dynamic> map) {
    return Cache(
        before: TimestampModel.fromMap(map['before'] as Map<String, dynamic>),
        keys: List<dynamic>.from(
          (map['keys'] as List<dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Cache.fromJson(String source) =>
      Cache.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Cache(before: $before, keys: $keys)';

  @override
  bool operator ==(covariant Cache other) {
    if (identical(this, other)) return true;

    return other.before == before && listEquals(other.keys, keys);
  }

  @override
  int get hashCode => before.hashCode ^ keys.hashCode;
}

class Notice {
  String message;
  String url;
  bool isFullScreen;
  Notice({
    @required this.message,
    @required this.url,
    @required this.isFullScreen,
  });

  Notice copyWith({
    String message,
    String url,
    bool isFullScreen,
  }) {
    return Notice(
      message: message ?? this.message,
      url: url ?? this.url,
      isFullScreen: isFullScreen ?? this.isFullScreen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'url': url,
      'isFullScreen': isFullScreen,
    };
  }

  factory Notice.fromMap(Map<String, dynamic> map) {
    return Notice(
      message: map['message'] as String,
      url: map['url'] as String,
      isFullScreen: map['isFullScreen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notice.fromJson(String source) =>
      Notice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Notice(message: $message, url: $url, isFullScreen: $isFullScreen)';

  @override
  bool operator ==(covariant Notice other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.url == url &&
        other.isFullScreen == isFullScreen;
  }

  @override
  int get hashCode => message.hashCode ^ url.hashCode ^ isFullScreen.hashCode;
}

class BanMap {
  final GamesBanMap games;
  final InvestmentsBanMap investments;
  BanMap({
    @required this.games,
    @required this.investments,
  });

  BanMap copyWith({
    GamesBanMap games,
    InvestmentsBanMap investments,
  }) {
    return BanMap(
      games: games ?? this.games,
      investments: investments ?? this.investments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'games': games.toMap(),
      'investments': investments.toMap(),
    };
  }

  factory BanMap.fromMap(Map<String, dynamic> map) {
    return BanMap(
      games: map['games'] != null
          ? GamesBanMap.fromMap(map['games'] as Map<String, dynamic>)
          : null,
      investments: map['investments'] != null
          ? InvestmentsBanMap.fromMap(
              map['investments'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BanMap.fromJson(String source) =>
      BanMap.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BanMap(games: $games, investments: $investments)';

  @override
  bool operator ==(covariant BanMap other) {
    if (identical(this, other)) return true;

    return other.games == games && other.investments == investments;
  }

  @override
  int get hashCode => games.hashCode ^ investments.hashCode;
}

class InvestmentsBanMap {
  final InvestmentTypeBanMap deposit;
  final InvestmentTypeBanMap withdrawal;
  InvestmentsBanMap({
    @required this.deposit,
    @required this.withdrawal,
  });

  InvestmentsBanMap copyWith({
    InvestmentTypeBanMap deposit,
    InvestmentTypeBanMap withdrawal,
  }) {
    return InvestmentsBanMap(
      deposit: deposit ?? this.deposit,
      withdrawal: withdrawal ?? this.withdrawal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deposit': deposit.toMap(),
      'withdrawal': withdrawal.toMap(),
    };
  }

  factory InvestmentsBanMap.fromMap(Map<String, dynamic> map) {
    return InvestmentsBanMap(
      deposit: map['deposit'] != null
          ? InvestmentTypeBanMap.fromMap(map['deposit'] as Map<String, dynamic>)
          : null,
      withdrawal: map['withdrawal'] != null
          ? InvestmentTypeBanMap.fromMap(
              map['withdrawal'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestmentsBanMap.fromJson(String source) =>
      InvestmentsBanMap.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'InvestmentsBanMap(deposit: $deposit, withdrawal: $withdrawal)';

  @override
  bool operator ==(covariant InvestmentsBanMap other) {
    if (identical(this, other)) return true;

    return other.deposit == deposit && other.withdrawal == withdrawal;
  }

  @override
  int get hashCode => deposit.hashCode ^ withdrawal.hashCode;
}

class InvestmentTypeBanMap {
  final AssetBanMap augmont;
  final AssetBanMap lendBox;
  InvestmentTypeBanMap({
    @required this.augmont,
    @required this.lendBox,
  });

  InvestmentTypeBanMap copyWith({
    AssetBanMap augmont,
    AssetBanMap lendBox,
  }) {
    return InvestmentTypeBanMap(
      augmont: augmont ?? this.augmont,
      lendBox: lendBox ?? this.lendBox,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'augmont': augmont.toMap(),
      'lendBox': lendBox.toMap(),
    };
  }

  factory InvestmentTypeBanMap.fromMap(Map<String, dynamic> map) {
    return InvestmentTypeBanMap(
      augmont: map[Constants.ASSET_TYPE_AUGMONT] != null
          ? AssetBanMap.fromMap(
              map[Constants.ASSET_TYPE_AUGMONT] as Map<String, dynamic>,
              Constants.ASSET_TYPE_AUGMONT)
          : null,
      lendBox: map[Constants.ASSET_TYPE_LENDBOX] != null
          ? AssetBanMap.fromMap(
              map[Constants.ASSET_TYPE_LENDBOX] as Map<String, dynamic>,
              Constants.ASSET_TYPE_LENDBOX)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvestmentTypeBanMap.fromJson(String source) =>
      InvestmentTypeBanMap.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'InvestmentTypeBanMap(augmont: $augmont, lendBox: $lendBox)';

  @override
  bool operator ==(covariant InvestmentTypeBanMap other) {
    if (identical(this, other)) return true;

    return other.augmont == augmont && other.lendBox == lendBox;
  }

  @override
  int get hashCode => augmont.hashCode ^ lendBox.hashCode;
}

class GamesBanMap {
  final AssetBanMap cricketMap;
  final AssetBanMap tambolaMap;
  final AssetBanMap poolClubMap;
  final AssetBanMap footballMap;
  final AssetBanMap candyFiestaMap;
  GamesBanMap({
    @required this.cricketMap,
    @required this.tambolaMap,
    @required this.poolClubMap,
    @required this.footballMap,
    @required this.candyFiestaMap,
  });

  GamesBanMap copyWith({
    AssetBanMap cricketMap,
    AssetBanMap tambolaMap,
    AssetBanMap poolClubMap,
    AssetBanMap footballMap,
    AssetBanMap candyFiestaMap,
  }) {
    return GamesBanMap(
      cricketMap: cricketMap ?? this.cricketMap,
      tambolaMap: tambolaMap ?? this.tambolaMap,
      poolClubMap: poolClubMap ?? this.poolClubMap,
      footballMap: footballMap ?? this.footballMap,
      candyFiestaMap: candyFiestaMap ?? this.candyFiestaMap,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cricketMap': cricketMap.toMap(),
      'tambolaMap': tambolaMap.toMap(),
      'poolClubMap': poolClubMap.toMap(),
      'footballMap': footballMap.toMap(),
      'candyFiestaMap': candyFiestaMap.toMap(),
    };
  }

  factory GamesBanMap.fromMap(Map<String, dynamic> map) {
    return GamesBanMap(
      cricketMap: map[Constants.GAME_TYPE_CRICKET] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_CRICKET] as Map<String, dynamic>,
              Constants.GAME_TYPE_CRICKET)
          : null,
      tambolaMap: map[Constants.GAME_TYPE_TAMBOLA] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_TAMBOLA] as Map<String, dynamic>,
              Constants.GAME_TYPE_TAMBOLA)
          : null,
      poolClubMap: map[Constants.GAME_TYPE_POOLCLUB] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_POOLCLUB] as Map<String, dynamic>,
              Constants.GAME_TYPE_POOLCLUB)
          : null,
      footballMap: map[Constants.GAME_TYPE_FOOTBALL] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_FOOTBALL] as Map<String, dynamic>,
              Constants.GAME_TYPE_FOOTBALL)
          : null,
      candyFiestaMap: map[Constants.GAME_TYPE_CANDYFIESTA] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_CANDYFIESTA] as Map<String, dynamic>,
              Constants.GAME_TYPE_CANDYFIESTA)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GamesBanMap.fromJson(String source) =>
      GamesBanMap.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GamesBanMap(cricketMap: $cricketMap, tambolaMap: $tambolaMap, poolClubMap: $poolClubMap, footballMap: $footballMap, candyFiestaMap: $candyFiestaMap)';
  }

  @override
  bool operator ==(covariant GamesBanMap other) {
    if (identical(this, other)) return true;

    return other.cricketMap == cricketMap &&
        other.tambolaMap == tambolaMap &&
        other.poolClubMap == poolClubMap &&
        other.footballMap == footballMap &&
        other.candyFiestaMap == candyFiestaMap;
  }

  @override
  int get hashCode {
    return cricketMap.hashCode ^
        tambolaMap.hashCode ^
        poolClubMap.hashCode ^
        footballMap.hashCode ^
        candyFiestaMap.hashCode;
  }
}

class AssetBanMap {
  final String reason;
  final bool isBanned;
  final String asset;
  AssetBanMap({
    @required this.reason,
    @required this.isBanned,
    @required this.asset,
  });

  AssetBanMap copyWith({
    String reason,
    bool isBanned,
    String asset,
  }) {
    return AssetBanMap(
      reason: reason ?? this.reason,
      isBanned: isBanned ?? this.isBanned,
      asset: asset ?? this.asset,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reason': reason,
      'isBanned': isBanned,
      'asset': asset,
    };
  }

  factory AssetBanMap.fromMap(Map<String, dynamic> map, String asset) {
    return AssetBanMap(
      reason: map['reason'] as String,
      isBanned: map['isBanned'] as bool,
      asset: asset,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetBanMap.fromJson(String source, String asset) =>
      AssetBanMap.fromMap(json.decode(source) as Map<String, dynamic>, asset);

  @override
  String toString() =>
      'AssetBanMap(reason: $reason, isBanned: $isBanned, asset: $asset)';

  @override
  bool operator ==(covariant AssetBanMap other) {
    if (identical(this, other)) return true;

    return other.reason == reason &&
        other.isBanned == isBanned &&
        other.asset == asset;
  }

  @override
  int get hashCode => reason.hashCode ^ isBanned.hashCode ^ asset.hashCode;
}
