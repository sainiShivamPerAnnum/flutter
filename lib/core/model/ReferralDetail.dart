import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class ReferralDetail {
  static Log log = new Log('ReferralDetail');
  final String _userName;
  final Timestamp _timestamp;
  bool _isUserBonusUnlocked;
  bool _isRefereeBonusUnlocked;
  final int _refCount;
  final Map<String, dynamic> _bonusMap;

  ReferralDetail(this._userName, this._timestamp, this._isUserBonusUnlocked,
      this._isRefereeBonusUnlocked, this._refCount, this._bonusMap);

  ReferralDetail.fromMap(Map<String, dynamic> rMap) :this(
      rMap['usr_name'], rMap['timestamp'], rMap['usr_bonus_unlocked'],
      rMap['referee_bonus_unlocked'],rMap['ref_count'], rMap['bonus_values']);

  toJson() => {
    'usr_bonus_unlocked': _isUserBonusUnlocked,
    'referee_bonus_unlocked': _isRefereeBonusUnlocked
  };

  bool get isRefereeBonusUnlocked => _isRefereeBonusUnlocked;

  bool get isUserBonusUnlocked => _isUserBonusUnlocked;

  Timestamp get timestamp => _timestamp;

  String get userName => _userName;

  int get refCount => _refCount;

  Map<String, dynamic> get bonusMap => _bonusMap;

  set isRefereeBonusUnlocked(bool value) {
    _isRefereeBonusUnlocked = value;
  }

  set isUserBonusUnlocked(bool value) {
    _isUserBonusUnlocked = value;
  }
}