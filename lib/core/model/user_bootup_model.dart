// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/constants.dart';
import 'package:flutter/foundation.dart';

class UserBootUpDetailsModel {
  final String? message;
  final Data? data;

  UserBootUpDetailsModel({
    required this.message,
    required this.data,
  });

  UserBootUpDetailsModel copyWith({
    String? message,
    Data? data,
  }) {
    return UserBootUpDetailsModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory UserBootUpDetailsModel.fromMap(Map<String, dynamic> map) {
    return UserBootUpDetailsModel(
      message: map['message'] as String,
      data: Data.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

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
  final List<String> marqueeMessages;
  final String marqueeColor;
  final Cache? cache;
  final bool? isBlocked;
  final bool isAppUpdateRequired;
  final bool? isAppForcedUpdateRequired;
  final Notice? notice;
  final bool? signOutUser;
  final BanMap? banMap;
  final bool? stateRestricted;
  final bool? isAppInMaintenance;
  final String blockTitle;
  final String blockSubtitle;

  Data({
    required this.marqueeMessages,
    required this.marqueeColor,
    required this.cache,
    required this.isBlocked,
    required this.isAppUpdateRequired,
    required this.isAppForcedUpdateRequired,
    required this.notice,
    required this.signOutUser,
    required this.banMap,
    required this.stateRestricted,
    required this.isAppInMaintenance,
    required this.blockTitle,
    required this.blockSubtitle,
  });

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      marqueeMessages: map["marqueeMessages"] != null
          ? (List<String>.from(
              map['marqueeMessages'].cast<String>() as List<String>))
          : [],
      cache: map['cache'] != null
          ? Cache.fromMap(map['cache'] as Map<String, dynamic>)
          : Cache.base(),
      isBlocked: map['isBlocked'] ?? false,
      isAppUpdateRequired: map['isAppUpdateRequired'] ?? false,
      isAppForcedUpdateRequired: map['isAppForcedUpdateRequired'] ?? false,
      notice: map['notice'] != null
          ? Notice.fromMap(map['notice'] as Map<String, dynamic>)
          : Notice.base(),
      signOutUser: map['signOutUser'] ?? false,
      banMap: map['banMap'] != null
          ? BanMap.fromMap(map['banMap'] as Map<String, dynamic>)
          : BanMap.base(),
      stateRestricted: map['stateRestricted'] ?? false,
      isAppInMaintenance: map['isAppInMaintenance'] ?? false,
      blockTitle: map['blockTitle'] ?? '',
      blockSubtitle: map["blockSubtitle"] ?? "",
      marqueeColor: map['marqueeColor'] ?? '#39498C',
    );
  }

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Data(cache: $cache, isBlocked: $isBlocked, isAppUpdateRequired: $isAppUpdateRequired, isAppForcedUpdateRequired: $isAppForcedUpdateRequired, notice: $notice, signOutUser: $signOutUser, banMap: $banMap, stateRestricted: $stateRestricted) blockTitle : $blockTitle, blockSubtitle: $blockSubtitle';
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
        other.banMap == banMap &&
        other.stateRestricted == stateRestricted;
  }

  @override
  int get hashCode {
    return cache.hashCode ^
        isBlocked.hashCode ^
        isAppUpdateRequired.hashCode ^
        isAppForcedUpdateRequired.hashCode ^
        notice.hashCode ^
        signOutUser.hashCode ^
        banMap.hashCode ^
        stateRestricted.hashCode;
  }
}

class Cache {
  TimestampModel? before;
  List<String>? keys;

  Cache({
    required this.before,
    required this.keys,
  });

  Cache copyWith({
    TimestampModel? before,
    List<String>? keys,
  }) {
    return Cache(
      before: before ?? this.before,
      keys: keys ?? this.keys,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'before': before!.toMap(),
      'keys': keys,
    };
  }

  factory Cache.fromMap(Map<String, dynamic> map) {
    return Cache(
        before: TimestampModel.fromMap(map['before']),
        keys: List<String>.from((map['keys'].cast<String>() as List<String>)));
  }

  Cache.base() {
    before = TimestampModel(nanoseconds: 0, seconds: 0);
    keys = [];
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
  String? message;
  String? url;
  bool? isFullScreen;

  Notice({
    required this.message,
    required this.url,
    required this.isFullScreen,
  });

  Notice.base() {
    message = '';
    url = '';
    isFullScreen = false;
  }

  Notice copyWith({
    String? message,
    String? url,
    bool? isFullScreen,
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
      message: map['message'] as String? ?? '',
      url: map['url'] as String? ?? '',
      isFullScreen: map['isFullScreen'] as bool? ?? false,
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
  GamesBanMap? games;
  InvestmentsBanMap? investments;

  BanMap({
    required this.games,
    required this.investments,
  });

  BanMap.base() {
    games = GamesBanMap.base();
    investments = InvestmentsBanMap.base();
  }

  BanMap copyWith({
    GamesBanMap? games,
    InvestmentsBanMap? investments,
  }) {
    return BanMap(
      games: games ?? this.games,
      investments: investments ?? this.investments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'games': games!.toMap(),
      'investments': investments!.toMap(),
    };
  }

  factory BanMap.fromMap(Map<String, dynamic> map) {
    return BanMap(
      games: map['games'] != null
          ? GamesBanMap.fromMap(map['games'] as Map<String, dynamic>)
          : GamesBanMap.base(),
      investments: map['investments'] != null
          ? InvestmentsBanMap.fromMap(
              map['investments'] as Map<String, dynamic>)
          : InvestmentsBanMap.base(),
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
  InvestmentTypeBanMap? deposit;
  InvestmentTypeBanMap? withdrawal;

  InvestmentsBanMap({
    required this.deposit,
    required this.withdrawal,
  });

  InvestmentsBanMap.base() {
    deposit = InvestmentTypeBanMap.base();
    withdrawal = InvestmentTypeBanMap.base();
  }

  InvestmentsBanMap copyWith({
    InvestmentTypeBanMap? deposit,
    InvestmentTypeBanMap? withdrawal,
  }) {
    return InvestmentsBanMap(
      deposit: deposit ?? this.deposit,
      withdrawal: withdrawal ?? this.withdrawal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deposit': deposit!.toMap(),
      'withdrawal': withdrawal!.toMap(),
    };
  }

  factory InvestmentsBanMap.fromMap(Map<String, dynamic> map) {
    return InvestmentsBanMap(
      deposit: map['deposit'] != null
          ? InvestmentTypeBanMap.fromMap(map['deposit'] as Map<String, dynamic>)
          : InvestmentTypeBanMap.base(),
      withdrawal: map['withdrawal'] != null
          ? InvestmentTypeBanMap.fromMap(
              map['withdrawal'] as Map<String, dynamic>)
          : InvestmentTypeBanMap.base(),
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
  AssetBanMap? augmont;
  AssetBanMap? goldPro;
  AssetBanMap? lendBox;
  AssetBanMap? lendBoxFd1;
  AssetBanMap? lendBoxFd2;

  InvestmentTypeBanMap({
    required this.augmont,
    required this.goldPro,
    @required this.lendBox,
    required this.lendBoxFd1,
    required this.lendBoxFd2,
  });

  InvestmentTypeBanMap copyWith({
    AssetBanMap? augmont,
    AssetBanMap? goldPro,
    AssetBanMap? lendBox,
    AssetBanMap? lendBoxFd1,
    AssetBanMap? lendBoxFd2,
  }) {
    return InvestmentTypeBanMap(
      augmont: augmont ?? this.augmont,
      goldPro: goldPro ?? this.goldPro,
      lendBox: lendBox ?? this.lendBox,
      lendBoxFd1: lendBoxFd1 ?? this.lendBoxFd1,
      lendBoxFd2: lendBoxFd2 ?? this.lendBoxFd2,
    );
  }

  InvestmentTypeBanMap.base() {
    augmont = AssetBanMap.base();
    goldPro = AssetBanMap.base();
    lendBox = AssetBanMap.base();
    lendBoxFd1 = AssetBanMap.base();
    lendBoxFd2 = AssetBanMap.base();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'augmont': augmont!.toMap(),
      'goldPro': goldPro!.toMap(),
      'lendBox': lendBox!.toMap(),
      'lendboxFd1': lendBoxFd1!.toMap(),
      'lendboxFd2': lendBoxFd2!.toMap(),
    };
  }

  factory InvestmentTypeBanMap.fromMap(Map<String, dynamic> map) {
    return InvestmentTypeBanMap(
      augmont: map[Constants.ASSET_TYPE_AUGMONT] != null
          ? AssetBanMap.fromMap(
              map[Constants.ASSET_TYPE_AUGMONT] as Map<String, dynamic>,
              Constants.ASSET_TYPE_AUGMONT)
          : AssetBanMap.base(),
      goldPro: map[Constants.ASSET_TYPE_AUGMONT_FD] != null
          ? AssetBanMap.fromMap(
              map[Constants.ASSET_TYPE_AUGMONT_FD] as Map<String, dynamic>,
              Constants.ASSET_TYPE_AUGMONT_FD)
          : AssetBanMap.base(),
      lendBox: map[Constants.ASSET_TYPE_LENDBOX] != null
          ? AssetBanMap.fromMap(
              map[Constants.ASSET_TYPE_LENDBOX] as Map<String, dynamic>,
              Constants.ASSET_TYPE_LENDBOX)
          : AssetBanMap.base(),
      lendBoxFd1: map[Constants.ASSET_TYPE_LENDBOX_FD1] != null
          ? AssetBanMap.fromMap(
              map[Constants.ASSET_TYPE_LENDBOX_FD1] as Map<String, dynamic>,
              Constants.ASSET_TYPE_LENDBOX_FD1)
          : AssetBanMap.base(),
      lendBoxFd2: map[Constants.ASSET_TYPE_LENDBOX_FD2] != null
          ? AssetBanMap.fromMap(
              map[Constants.ASSET_TYPE_LENDBOX_FD2] as Map<String, dynamic>,
              Constants.ASSET_TYPE_LENDBOX_FD2)
          : AssetBanMap.base(),
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
  AssetBanMap? cricketMap;
  AssetBanMap? tambolaMap;
  AssetBanMap? poolClubMap;
  AssetBanMap? footballMap;
  AssetBanMap? candyFiestaMap;
  AssetBanMap? bowlingMap;
  AssetBanMap? bottleFlipMap;
  AssetBanMap? rollyVortex;
  AssetBanMap? knifeHit;
  AssetBanMap? fruitMania;
  AssetBanMap? twoDots;

  GamesBanMap({
    required this.cricketMap,
    required this.tambolaMap,
    required this.poolClubMap,
    required this.footballMap,
    required this.candyFiestaMap,
    required this.bowlingMap,
    required this.bottleFlipMap,
    required this.rollyVortex,
    required this.knifeHit,
    required this.fruitMania,
    required this.twoDots,
  });

  GamesBanMap.base() {
    cricketMap = AssetBanMap.base();
    tambolaMap = AssetBanMap.base();
    poolClubMap = AssetBanMap.base();
    footballMap = AssetBanMap.base();
    candyFiestaMap = AssetBanMap.base();
    bowlingMap = AssetBanMap.base();
    bottleFlipMap = AssetBanMap.base();
    rollyVortex = AssetBanMap.base();
    knifeHit = AssetBanMap.base();
    fruitMania = AssetBanMap.base();
    twoDots = AssetBanMap.base();
  }

  GamesBanMap copyWith(
      {AssetBanMap? cricketMap,
      AssetBanMap? tambolaMap,
      AssetBanMap? poolClubMap,
      AssetBanMap? footballMap,
      AssetBanMap? candyFiestaMap,
      AssetBanMap? bowlingMap,
      AssetBanMap? bottleFlipMap,
      AssetBanMap? rollyVortex,
      AssetBanMap? knifeHit}) {
    return GamesBanMap(
        cricketMap: cricketMap ?? this.cricketMap,
        tambolaMap: tambolaMap ?? this.tambolaMap,
        poolClubMap: poolClubMap ?? this.poolClubMap,
        footballMap: footballMap ?? this.footballMap,
        candyFiestaMap: candyFiestaMap ?? this.candyFiestaMap,
        bowlingMap: bowlingMap ?? this.bowlingMap,
        bottleFlipMap: bottleFlipMap ?? this.bottleFlipMap,
        rollyVortex: rollyVortex ?? this.rollyVortex,
        knifeHit: knifeHit ?? this.knifeHit,
        fruitMania: fruitMania ?? fruitMania,
        twoDots: twoDots ?? twoDots);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cricketMap': cricketMap!.toMap(),
      'tambolaMap': tambolaMap!.toMap(),
      'poolClubMap': poolClubMap!.toMap(),
      'footballMap': footballMap!.toMap(),
      'candyFiestaMap': candyFiestaMap!.toMap(),
      'bowlingMap': bowlingMap!.toMap(),
      'bottleFlipMap': bottleFlipMap!.toMap(),
      'rollyVortex': rollyVortex!.toMap(),
      'knifeHit': knifeHit!.toMap(),
      'fruitMania': fruitMania!.toMap(),
      'twoDots': twoDots!.toMap(),
    };
  }

  factory GamesBanMap.fromMap(Map<String, dynamic> map) {
    return GamesBanMap(
      cricketMap: map[Constants.GAME_TYPE_CRICKET] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_CRICKET] as Map<String, dynamic>,
              Constants.GAME_TYPE_CRICKET)
          : AssetBanMap.base(),
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
      bowlingMap: map[Constants.GAME_TYPE_BOWLING] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_BOWLING] as Map<String, dynamic>,
              Constants.GAME_TYPE_BOWLING)
          : null,
      bottleFlipMap: map[Constants.GAME_TYPE_BOTTLEFLIP] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_BOTTLEFLIP] as Map<String, dynamic>,
              Constants.GAME_TYPE_BOTTLEFLIP)
          : null,
      rollyVortex: map[Constants.GAME_TYPE_ROLLYVORTEX] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_ROLLYVORTEX] as Map<String, dynamic>,
              Constants.GAME_TYPE_ROLLYVORTEX)
          : null,
      knifeHit: map[Constants.GAME_TYPE_KNIFEHIT] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_KNIFEHIT] as Map<String, dynamic>,
              Constants.GAME_TYPE_KNIFEHIT)
          : null,
      fruitMania: map[Constants.GAME_TYPE_FRUITMAINA] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_FRUITMAINA] as Map<String, dynamic>,
              Constants.GAME_TYPE_FRUITMAINA)
          : null,
      twoDots: map[Constants.GAME_TYPE_TWODOTS] != null
          ? AssetBanMap.fromMap(
              map[Constants.GAME_TYPE_TWODOTS] as Map<String, dynamic>,
              Constants.GAME_TYPE_TWODOTS)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GamesBanMap.fromJson(String source) =>
      GamesBanMap.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GamesBanMap(cricketMap: $cricketMap, tambolaMap: $tambolaMap, poolClubMap: $poolClubMap, footballMap: $footballMap, candyFiestaMap: $candyFiestaMap, bowlingMap: $bowlingMap, bottleFlipMap: $bottleFlipMap)';
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
  String? reason;
  bool? isBanned;
  String? asset;

  AssetBanMap({
    required this.reason,
    required this.isBanned,
    required this.asset,
  });

  AssetBanMap.base() {
    reason = '';
    isBanned = false;
    asset = '';
  }

  AssetBanMap copyWith({
    String? reason,
    bool? isBanned,
    String? asset,
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
      reason: map['reason'] as String?,
      isBanned: map['isBanned'] as bool?,
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
