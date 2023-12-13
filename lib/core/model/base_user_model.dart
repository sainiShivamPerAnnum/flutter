import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/logger.dart';

class BaseUser {
  static Log log = const Log("User");
  String? uid;
  String? mobile;
  String? name;
  String? email;
  String? dob;
  String? gender; // 0: Male | 1: Female | -1: Rather Not to say
  String? username;
  String? verifiedName;
  String? client_token; //fetched from a subcollection
  bool? isInvested;
  bool? isIciciOnboarded;
  bool? isAugmontOnboarded;
  bool? isSimpleKycVerified;
  bool? isBlocked;
  int isKycVerified;
  String? kycName;
  String? pendingTxnId;
  bool? isIciciEnabled;
  bool? isAugmontEnabled;
  bool? isEmailVerified;
  UserPreferences userPreferences;
  TimestampModel createdOn;
  String? appFlyerId;
  String? avatarId;
  bool? isOldUser;
  List segments;
  SuperFelloLevel superFelloLevel = SuperFelloLevel.NEW_FELLO;
  static const String fldId = "mID";
  static const String fldMobile = "mMobile";
  static const String fldEmail = "mEmail";
  static const String fldName = "mName";
  static const String fldDob = "mDob";
  static const String fldGender = "mGender";
  static const String fldClient_token = "mClientToken";
  static const String fldICICIBalance = "mICBalance";
  static const String fldAugmontBalance = "mAugBalance";
  static const String fldAugmontQuantity = "mAugQuantity";
  static const String fldUsername = "mUsername";
  static const String fldIsEmailVerified = "mIsEmailVerified";
  static const String fldIsInvested = "mIsInvested";
  static const String fldIsIciciOnboarded = "mIsIciciOnboarded";
  static const String fldIsAugmontOnboarded = "mIsAugmontOnboarded";
  static const String fldIsSimpleKycVerified = "mIsSimpleKycVerified";
  static const String fldIsBlocked = "mIsBlocked";
  static const String fldIsKycVerified = "mIsKycVerified";
  static const String fldPendingTxnId = "mPendingTxnId";
  static const String fldIsIciciEnabled = "mIsIciciEnabled";
  static const String fldIsAugmontEnabled = "mIsAugmontEnabled";
  static const String fldUserPrefs = "mUserPrefs";
  static const String fldUserPrefsAl = "mUserPrefsAl";
  static const String fldUserPrefsTn = "mUserPrefsTn";
  static const String fldCreatedOn = "mCreatedOn";
  static const String fldKycName = "mKycName";
  static const String fldStateId = "stateId";
  static const String fldAppFlyerId = "mAppFlyerId";
  static const String fldAvatarId = "mAvatarId";
  static const String fldIsOldUser = "isOldUser";
  static const String fldReferralCode = "referralCode";
  static const String fieldSuperFelloLevel = 'superFelloLevel';

  static const _$UserBadgeLevelEnumMap = {
    'BEGINNER': SuperFelloLevel.BEGINNER,
    'INTERMEDIATE': SuperFelloLevel.INTERMEDIATE,
    'SUPER_FELLO': SuperFelloLevel.SUPER_FELLO,
    'NEW_FELLO': SuperFelloLevel.NEW_FELLO,
  };

  BaseUser(
    this.uid,
    this.mobile,
    this.email,
    this.name,
    this.dob,
    this.gender,
    this.client_token,
    this.isInvested,
    this.isIciciOnboarded,
    this.isAugmontOnboarded,
    this.isSimpleKycVerified,
    this.isKycVerified,
    this.kycName,
    this.pendingTxnId,
    this.isIciciEnabled,
    this.isAugmontEnabled,
    this.username,
    this.isEmailVerified,
    this.isBlocked,
    this.userPreferences,
    this.createdOn,
    this.appFlyerId,
    this.avatarId,
    this.isOldUser,
    this.segments, {
    this.superFelloLevel = SuperFelloLevel.BEGINNER,
  });

  BaseUser.newUser(String id, String mobile)
      : this(
          id,
          mobile,
          '',
          '',
          '',
          '',
          '',
          false,
          false,
          false,
          false,
          0,
          '',
          '',
          false,
          false,
          '',
          false,
          false,
          UserPreferences({}),
          TimestampModel.currentTimeStamp(),
          '',
          '',
          false,
          [],
        );

  BaseUser.fromMap(Map<String, dynamic> data, String id, [String? client_token])
      : this(
          id,
          data[fldMobile]?.toString() ?? '',
          data[fldEmail]?.toString() ?? '',
          data[fldName]?.toString() ?? '',
          data[fldDob]?.toString() ?? '',
          data[fldGender]?.toString().toUpperCase() ?? '',
          client_token?.toString() ?? '',
          data[fldIsInvested] ?? false,
          data[fldIsIciciOnboarded],
          data[fldIsAugmontOnboarded] ?? false,
          data[fldIsSimpleKycVerified] ?? false,
          data[fldIsKycVerified] ?? 0,
          data[fldKycName] ?? '',
          data[fldPendingTxnId] ?? '',
          data[fldIsIciciEnabled] ?? false,
          data[fldIsAugmontEnabled] ?? false,
          data[fldUsername]?.toString() ?? '',
          data[fldIsEmailVerified] ?? false,
          data[fldIsBlocked] ?? false,
          UserPreferences(data[fldUserPrefs]),
          TimestampModel.fromMap(data[fldCreatedOn]),
          data[fldAppFlyerId] ?? '',
          data[fldAvatarId] ?? '',
          data[fldIsOldUser] ?? false,
          data['mSegments'] ?? [],
          superFelloLevel: data[fieldSuperFelloLevel] != null
              ? _$UserBadgeLevelEnumMap[data[fieldSuperFelloLevel]]!
              : SuperFelloLevel.BEGINNER,
        );

  bool hasIncompleteDetails() {
    //return ((_mobile?.isEmpty??true) || (_name?.isEmpty??true) || (_email?.isEmpty??true));
    return (mobile?.isEmpty ?? true) || (name?.isEmpty ?? true);
  }

  @override
  String toString() {
    return 'BaseUser(uid: $uid, mobile: $mobile, name: $name, email: $email, dob: $dob, gender: $gender, username: $username, verifiedName: $verifiedName, client_token: $client_token, isInvested: $isInvested, isIciciOnboarded: $isIciciOnboarded, isAugmontOnboarded: $isAugmontOnboarded, isSimpleKycVerified: $isSimpleKycVerified, isBlocked: $isBlocked, isKycVerified: $isKycVerified, kycName: $kycName, pendingTxnId: $pendingTxnId, isIciciEnabled: $isIciciEnabled, isAugmontEnabled: $isAugmontEnabled, isEmailVerified: $isEmailVerified, userPreferences: ${userPreferences.toString()}, createdOn: $createdOn, appFlyerId: $appFlyerId, avatarId: $avatarId)';
  }
}

enum Preferences {
  TAMBOLANOTIFICATIONS,
  APPLOCK,
  FLOINVOICEMAIL,
  TAMBOLAONBOARDING
}

class UserPreferences {
  //setup index with firebase keys
  static const Map<Preferences, String> _index = {
    Preferences.TAMBOLANOTIFICATIONS: 'tn',
    Preferences.APPLOCK: 'al',
    Preferences.FLOINVOICEMAIL: "er",
    Preferences.TAMBOLAONBOARDING: "to"
  };

  //setup defaults
  final Map<Preferences, int> _defValues = {
    Preferences.TAMBOLANOTIFICATIONS: 1,
    Preferences.APPLOCK: 0,
    Preferences.FLOINVOICEMAIL: 0,
    Preferences.TAMBOLAONBOARDING: 0
  };

  //current values
  final Map<String?, int?> _activePrefs = {};

  UserPreferences(Map<dynamic, dynamic>? remValues) {
    for (final Preferences p in Preferences.values) {
      String? fKey = _index[p];
      int? defValue = _defValues[p];
      _activePrefs[fKey] = (remValues != {} &&
              remValues![fKey] != null &&
              (remValues[fKey] is int || remValues[fKey] is bool))
          ? ((remValues[fKey].runtimeType == bool)
              ? (remValues[fKey] == true ? 1 : 0)
              : remValues[fKey])
          : defValue;
    }
  }

  int? getPreference(Preferences p) => _activePrefs[_index[p]];

  int setPreference(Preferences p, int val) => _activePrefs[_index[p]] = val;

  Map<String?, int?> toJson() => _activePrefs;

  @override
  String toString() {
    return "$_activePrefs";
  }
}
