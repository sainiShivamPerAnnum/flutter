import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/logger.dart';

class ReferralDetail {
  static Log log = const Log('ReferralDetail');
  String? _userName;
  String? _uid;
  TimestampModel? _timestamp;
  bool? _isUserBonusUnlocked;
  bool? _isRefereeBonusUnlocked;
  int? _refCount;
  String? mobile;
  RevampedInfo? revampedInfo;
  String? shareMsg;
  static final helper =
      HelperModel<ReferralDetail>((map) => ReferralDetail.fromMap(map));
  Map<String, dynamic>? _bonusMap;

  static const String fldUsrBonusFlag = 'usr_bonus_unlocked';
  static const String fldRefereeBonusFlag = 'referee_bonus_unlocked';
  static const String fldUserReferralCount = 'ref_count';

  ReferralDetail(
      this._userName,
      this._timestamp,
      this._isUserBonusUnlocked,
      this._isRefereeBonusUnlocked,
      this._refCount,
      this._bonusMap,
      this._uid,
      this.mobile,
      this.revampedInfo,
      this.shareMsg);

  ReferralDetail.base() {
    _userName = '';
    _uid = '';
    _timestamp = TimestampModel(seconds: 0, nanoseconds: 0);
    _isRefereeBonusUnlocked = false;
    _isUserBonusUnlocked = false;
    _refCount = 0;
    _bonusMap = {};
  }

  factory ReferralDetail.fromMap(Map<String, dynamic> rMap) {
    return ReferralDetail(
      rMap['usr_name'] ?? '',
      TimestampModel.fromMap(rMap['timestamp']),
      rMap[fldUsrBonusFlag] ?? false,
      rMap[fldRefereeBonusFlag] ?? false,
      rMap[fldUserReferralCount] ?? 0,
      rMap['bonus_values'] ?? {},
      rMap['id'] ?? '',
      rMap["mobile"],
      rMap["revampedInfo"] == null
          ? null
          : RevampedInfo.fromJson(rMap["revampedInfo"]),
      rMap["shareMsg"],
    );
  }

  toJson() => {
        fldUsrBonusFlag: _isUserBonusUnlocked,
        fldRefereeBonusFlag: _isRefereeBonusUnlocked,
        fldUserReferralCount: _refCount
      };

  bool get isRefereeBonusUnlocked => _isRefereeBonusUnlocked!;

  bool get isUserBonusUnlocked => _isUserBonusUnlocked!;

  Timestamp get timestamp => _timestamp!;

  String get userName => _userName!;

  String get uid => _uid!;

  int get refCount => _refCount!;

  set refCount(int value) {
    _refCount = value;
  }

  Map<String, dynamic> get bonusMap => _bonusMap!;

  set isRefereeBonusUnlocked(bool value) {
    _isRefereeBonusUnlocked = value;
  }

  set isUserBonusUnlocked(bool value) {
    _isUserBonusUnlocked = value;
  }

  @override
  String toString() {
    return 'ReferralDetail{_userName: $_userName, _uid: $_uid, _timestamp: $_timestamp, _isUserBonusUnlocked: $_isUserBonusUnlocked, _isRefereeBonusUnlocked: $_isRefereeBonusUnlocked, _refCount: $_refCount, mobile: $mobile, revampedInfo: $revampedInfo, _bonusMap: $_bonusMap}';
  }
}

class RevampedInfo {
  final String? subtitle;
  final List<Stage>? stages;
  final bool? isFullyComplete;

  RevampedInfo({
    this.subtitle,
    this.stages,
    this.isFullyComplete,
  });

  factory RevampedInfo.fromJson(Map<String, dynamic> json) => RevampedInfo(
        subtitle: json["subtitle"],
        stages: json["stages"] == null
            ? []
            : List<Stage>.from(json["stages"]!.map((x) => Stage.fromJson(x))),
        isFullyComplete: json["isFullyComplete"],
      );

  Map<String, dynamic> toJson() => {
        "subtitle": subtitle,
        "stages": stages == null
            ? []
            : List<dynamic>.from(stages!.map((x) => x.toJson())),
        "isFullyComplete": isFullyComplete,
      };
}

class Stage {
  final String? title;
  final bool? isComplete;
  final String? tooltipContent;

  Stage({
    this.title,
    this.isComplete,
    this.tooltipContent,
  });

  factory Stage.fromJson(Map<String, dynamic> json) => Stage(
        title: json["title"],
        isComplete: json["isComplete"],
        tooltipContent: json["tooltipContent"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "isComplete": isComplete,
        "tooltipContent": tooltipContent,
      };
}
