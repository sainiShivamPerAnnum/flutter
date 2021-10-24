import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:felloapp/util/constants.dart';
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
      this.pendingTxnId,
      this.isIciciEnabled,
      this.isAugmontEnabled,
      this.username,
      this.isEmailVerified,
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
            "",
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
            data[fldIsAugmontOnboarded],
            data[fldIsSimpleKycVerified],
            data[fldIsKycVerified],
            data[fldPendingTxnId],
            data[fldIsIciciEnabled],
            data[fldIsAugmontEnabled],
            data[fldUsername],
            data[fldIsEmailVerified],
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
    if(kycName != null) userObj[fldKycName] = kycName;
    if (isIciciOnboarded != null)
      userObj[fldIsIciciOnboarded] = isIciciOnboarded;
    if (isIciciEnabled != null) userObj[fldIsIciciEnabled] = isIciciEnabled;
    if (isAugmontEnabled != null)
      userObj[fldIsAugmontEnabled] = isAugmontEnabled;
    if (userPreferences != null)
      userObj[fldUserPrefs] = userPreferences.toJson();

    return userObj;
  }

  static String _decryptPan(String encde) {
    if (encde == null || encde.isEmpty) {
      return null;
    }
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (!panCheck.hasMatch(encde) || encde.length != 10) {
      //this is encrypted
      final key = encrypt.Key.fromUtf8(Constants.PAN_AES_KEY);
      final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decrypted = encrypter.decrypt64(encde, iv: iv);
      log.debug('Decrypted PAN: $decrypted');
      return decrypted;
    } else {
      //not yet encrypted
      return encde;
    }
  }

  static String _encryptPan(String decde) {
    if (decde == null || decde.isEmpty) return null;
    final key = encrypt.Key.fromUtf8(Constants.PAN_AES_KEY);
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(decde, iv: iv);

    String cde = encrypted.base64;
    log.debug('Encrypted PAN: $cde');
    return cde;
  }

  bool hasIncompleteDetails() {
    //return ((_mobile?.isEmpty??true) || (_name?.isEmpty??true) || (_email?.isEmpty??true));
    return (((mobile?.isEmpty ?? true) || (name?.isEmpty ?? true)));
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
