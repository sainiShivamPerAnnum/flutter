import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/logger.dart';

class ReferralDetail {
  static Log log = new Log('ReferralDetail');
  final String _userName;
  final String _uid;
  final TimestampModel _timestamp;
  bool _isUserBonusUnlocked;
  bool _isRefereeBonusUnlocked;
  int _refCount;
  static final helper =
      HelperModel<ReferralDetail>((map) => ReferralDetail.fromMap(map));
  final Map<String, dynamic> _bonusMap;

  static const String fldUsrBonusFlag = 'usr_bonus_unlocked';
  static const String fldRefereeBonusFlag = 'referee_bonus_unlocked';
  static const String fldUserReferralCount = 'ref_count';

  ReferralDetail(this._userName, this._timestamp, this._isUserBonusUnlocked,
      this._isRefereeBonusUnlocked, this._refCount, this._bonusMap, this._uid);

  // ReferralDetail.fromMap(Map<String, dynamic> rMap)
  //     : this(
  //           rMap['usr_name'],
  //           rMap['timestamp'],
  //           rMap[fldUsrBonusFlag],
  //           rMap[fldRefereeBonusFlag],
  //           rMap[fldUserReferralCount],
  //           rMap['bonus_values']);

  factory ReferralDetail.fromMap(Map<String, dynamic> rMap) {
    return ReferralDetail(
      rMap['usr_name'] ?? '',
      TimestampModel.fromMap(rMap['timestamp']),
      rMap[fldUsrBonusFlag] ?? false,
      rMap[fldRefereeBonusFlag] ?? false,
      rMap[fldUserReferralCount] ?? 0,
      rMap['bonus_values'] ?? {},
      rMap['id'] ?? '',
    );
  }

  toJson() => {
        fldUsrBonusFlag: _isUserBonusUnlocked,
        fldRefereeBonusFlag: _isRefereeBonusUnlocked,
        fldUserReferralCount: _refCount
      };

  bool get isRefereeBonusUnlocked => _isRefereeBonusUnlocked;

  bool get isUserBonusUnlocked => _isUserBonusUnlocked;

  Timestamp get timestamp => _timestamp;

  String get userName => _userName;

  String get uid => _uid;

  int get refCount => _refCount;

  set refCount(int value) {
    _refCount = value;
  }

  Map<String, dynamic> get bonusMap => _bonusMap;

  set isRefereeBonusUnlocked(bool value) {
    _isRefereeBonusUnlocked = value;
  }

  set isUserBonusUnlocked(bool value) {
    _isUserBonusUnlocked = value;
  }
}
