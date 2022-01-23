import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:felloapp/util/logger.dart';

class BaseUser {
  static Log log = new Log("User");
  String uid;
  String mobile;
  String name;
  String email;
  String dob;
  String gender; // 0: Male | 1: Female | -1: Rather Not to say
  String username;
  String verifiedName;
  String client_token; //fetched from a subcollection
  bool isInvested;
  bool isIciciOnboarded;
  bool isAugmontOnboarded;
  bool isSimpleKycVerified;
  bool isBlocked;
  int isKycVerified;
  String kycName;
  String pendingTxnId;
  bool isIciciEnabled;
  bool isAugmontEnabled;
  bool isEmailVerified;
  UserPreferences userPreferences;
  Timestamp createdOn;

  static final String fldId = "mID";
  static final String fldMobile = "mMobile";
  static final String fldEmail = "mEmail";
  static final String fldName = "mName";
  static final String fldDob = "mDob";
  static final String fldGender = "mGender";
  static final String fldClient_token = "mClientToken";
  static final String fldICICIBalance = "mICBalance";
  static final String fldAugmontBalance = "mAugBalance";
  static final String fldAugmontQuantity = "mAugQuantity";
  static final String fldUsername = "mUsername";
  static final String fldIsEmailVerified = "mIsEmailVerified";
  static final String fldIsInvested = "mIsInvested";
  static final String fldIsIciciOnboarded = "mIsIciciOnboarded";
  static final String fldIsAugmontOnboarded = "mIsAugmontOnboarded";
  static final String fldIsSimpleKycVerified = "mIsSimpleKycVerified";
  static final String fldIsBlocked = "mIsBlocked";
  static final String fldIsKycVerified = "mIsKycVerified";
  static final String fldPendingTxnId = "mPendingTxnId";
  static final String fldIsIciciEnabled = "mIsIciciEnabled";
  static final String fldIsAugmontEnabled = "mIsAugmontEnabled";
  static final String fldUserPrefs = "mUserPrefs";
  static final String fldCreatedOn = "mCreatedOn";
  static final String fldKycName = "mKycName";

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
      this.createdOn);

  BaseUser.newUser(String id, String mobile)
      : this(
            id,
            mobile,
            null,
            null,
            null,
            null,
            null,
            false,
            null,
            false,
            false,
            null,
            null,
            null,
            null,
            null,
            "",
            false,
            false,
            UserPreferences(null),
            Timestamp.now());

  BaseUser.fromMap(Map<String, dynamic> data, String id, [String client_token])
      : this(
            id,
            data[fldMobile],
            data[fldEmail],
            data[fldName],
            data[fldDob],
            data[fldGender],
            client_token,
            data[fldIsInvested] ?? false,
            data[fldIsIciciOnboarded],
            data[fldIsAugmontOnboarded] ?? false,
            data[fldIsSimpleKycVerified],
            data[fldIsKycVerified],
            data[fldKycName],
            data[fldPendingTxnId],
            data[fldIsIciciEnabled],
            data[fldIsAugmontEnabled],
            data[fldUsername],
            data[fldIsEmailVerified],
            data[fldIsBlocked] ?? false,
            UserPreferences(data[fldUserPrefs]),
            data[fldCreatedOn]);

  //to send user object to server
  toJson() {
    var userObj = {
      fldMobile: mobile,
      fldName: name,
      fldEmail: email,
      fldDob: dob,
      fldGender: gender,
      fldIsInvested: isInvested,
      fldIsAugmontOnboarded: isAugmontOnboarded,
      fldIsSimpleKycVerified: isSimpleKycVerified,
      fldUsername: username,
      fldIsEmailVerified: isEmailVerified,
      fldCreatedOn: createdOn
    };
    if (isKycVerified != null) userObj[fldIsKycVerified] = isKycVerified;
    if (kycName != null) userObj[fldKycName] = kycName;
    if (isIciciOnboarded != null)
      userObj[fldIsIciciOnboarded] = isIciciOnboarded;
    if (isIciciEnabled != null) userObj[fldIsIciciEnabled] = isIciciEnabled;
    if (isAugmontEnabled != null)
      userObj[fldIsAugmontEnabled] = isAugmontEnabled;
    if (userPreferences != null)
      userObj[fldUserPrefs] = userPreferences.toJson();
    if (isBlocked != null) userObj[fldIsBlocked] = isBlocked;
    return userObj;
  }

  bool hasIncompleteDetails() {
    //return ((_mobile?.isEmpty??true) || (_name?.isEmpty??true) || (_email?.isEmpty??true));
    return (((mobile?.isEmpty ?? true) || (name?.isEmpty ?? true)));
  }

  @override
  String toString() {
    return 'BaseUser(uid: $uid, mobile: $mobile, name: $name, email: $email, dob: $dob, gender: $gender, username: $username, verifiedName: $verifiedName, client_token: $client_token, isInvested: $isInvested, isIciciOnboarded: $isIciciOnboarded, isAugmontOnboarded: $isAugmontOnboarded, isSimpleKycVerified: $isSimpleKycVerified, isBlocked: $isBlocked, isKycVerified: $isKycVerified, kycName: $kycName, pendingTxnId: $pendingTxnId, isIciciEnabled: $isIciciEnabled, isAugmontEnabled: $isAugmontEnabled, isEmailVerified: $isEmailVerified, userPreferences: $userPreferences, createdOn: $createdOn)';
  }
}

enum Preferences { TAMBOLANOTIFICATIONS, APPLOCK }

class UserPreferences {
  //setup index with firebase keys
  static const Map<Preferences, String> _index = {
    Preferences.TAMBOLANOTIFICATIONS: 'tn',
    Preferences.APPLOCK: 'al'
  };

  //setup defaults
  final Map<Preferences, int> _defValues = {
    Preferences.TAMBOLANOTIFICATIONS: 1,
    Preferences.APPLOCK: 0
  };

  //current values
  Map<String, int> _activePrefs = {};

  UserPreferences(Map<dynamic, dynamic> remValues) {
    for (Preferences p in Preferences.values) {
      String _fKey = _index[p];
      int _defValue = _defValues[p];
      _activePrefs[_fKey] = (remValues != null &&
              remValues[_fKey] != null &&
              remValues[_fKey] is int)
          ? remValues[_fKey]
          : _defValue;
    }
  }

  int getPreference(Preferences p) => _activePrefs[_index[p]];

  setPreference(Preferences p, int val) => _activePrefs[_index[p]] = val;

  toJson() => _activePrefs;
}
