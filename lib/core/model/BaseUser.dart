import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';

class BaseUser {
  static Log log = new Log("User");
  String _uid;
  String _mobile;
  String _name;
  String _email;
  String _dob;
  String _gender; // 0: Male | 1: Female | -1: Rather Not to say
  String _username;
  String _client_token; //fetched from a subcollection
  int _ticket_count;
  int _account_balance;
  int _deposit_balance;
  int _prize_balance;
  double _icici_balance;
  double _augmont_balance;
  double _augmont_quantity;
  int _lifetime_winnings;
  String _pan;
  String _age;
  bool _isInvested;
  bool _isIciciOnboarded;
  bool _isAugmontOnboarded;
  bool _isSimpleKycVerified;
  int _isKycVerified;
  String _pendingTxnId;
  bool _isIciciEnabled;
  bool _isAugmontEnabled;
  bool _isemailVerified;
  UserPreferences _userPreferences;

  static final String fldId = "mID";
  static final String fldMobile = "mMobile";
  static final String fldEmail = "mEmail";
  static final String fldName = "mName";
  static final String fldDob = "mDob";
  static final String fldGender = "mGender";
  static final String fldClient_token = "mClientToken";
  static final String fldTicket_count = "mTicketCount";
  static final String fldAcctBalance = "mAcctBalance";
  static final String fldDepositBalance = "mDepBalance";
  static final String fldPriBalance = "mPriBalance";
  static final String fldICICIBalance = "mICBalance";
  static final String fldAugmontBalance = "mAugBalance";
  static final String fldAugmontQuantity = "mAugQuantity";
  static final String fldLifeTimeWinnings = "mLifeTimeWin";
  static final String fldPan = "mPan";
  static final String fldAge = "mAge";
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

  BaseUser(
      this._uid,
      this._mobile,
      this._email,
      this._name,
      this._dob,
      this._gender,
      this._client_token,
      this._prize_balance,
      this._lifetime_winnings,
      this._pan,
      this._age,
      this._isInvested,
      this._isIciciOnboarded,
      this._isAugmontOnboarded,
      this._isSimpleKycVerified,
      this._isKycVerified,
      this._pendingTxnId,
      this._isIciciEnabled,
      this._isAugmontEnabled,
      this._username,
      this._isemailVerified,
      this._userPreferences);

  BaseUser.newUser(String id, String mobile)
      : this(
            id,
            mobile,
            null,
            null,
            null,
            null,
            null,
            0,
            0,
            null,
            null,
            false,
            false,
            false,
            false,
            Constants.KYC_UNTESTED,
            null,
            false,
            true,
            "",
            false,
            UserPreferences(null));

  BaseUser.fromMap(Map<String, dynamic> data, String id, [String client_token])
      : this(
            id,
            data[fldMobile],
            data[fldEmail],
            data[fldName],
            data[fldDob],
            data[fldGender],
            client_token,
            data[fldPriBalance] ?? 0,
            data[fldLifeTimeWinnings] ?? 0,
            _decryptPan(data[fldPan]),
            data[fldAge],
            data[fldIsInvested] ?? false,
            data[fldIsIciciOnboarded] ?? false,
            data[fldIsAugmontOnboarded] ?? false,
            data[fldIsSimpleKycVerified],
            data[fldIsKycVerified] ?? Constants.KYC_UNTESTED,
            data[fldPendingTxnId],
            data[fldIsIciciEnabled],
            data[fldIsAugmontEnabled],
            data[fldUsername],
            data[fldIsEmailVerified],
            UserPreferences(data[fldUserPrefs]));

  //to send user object to server
  toJson() {
    var userObj = {
      fldMobile: _mobile,
      fldName: _name,
      fldEmail: _email,
      fldDob: _dob,
      fldGender: _gender,
      fldPriBalance: _prize_balance,
      fldLifeTimeWinnings: _lifetime_winnings,
      fldPan: _encryptPan(_pan),
      fldAge: _age,
      fldIsInvested: _isInvested,
      fldIsIciciOnboarded: _isIciciOnboarded,
      fldIsAugmontOnboarded: _isAugmontOnboarded,
      fldIsSimpleKycVerified: _isSimpleKycVerified,
      fldIsKycVerified: _isKycVerified,
      fldPendingTxnId: _pendingTxnId,
      fldUsername: _username,
      fldIsEmailVerified: _isemailVerified
    };
    if (_isIciciEnabled != null) userObj[fldIsIciciEnabled] = _isIciciEnabled;
    if (_isAugmontEnabled != null)
      userObj[fldIsAugmontEnabled] = _isAugmontEnabled;
    if (_userPreferences != null)
      userObj[fldUserPrefs] = _userPreferences.toJson();
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
    return (((_mobile?.isEmpty ?? true) || (_name?.isEmpty ?? true)));
  }

  String get client_token => _client_token;

  set client_token(String value) {
    _client_token = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get mobile => _mobile;

  set mobile(String value) {
    _mobile = value;
  }

  String get dob => _dob;

  set dob(String date) {
    _dob = date;
  }

  String get gender => _gender;

  set gender(String gen) {
    _gender = gen;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get pan => _pan;

  set pan(String value) {
    _pan = value;
  }

  String get age => _age;

  set age(String value) {
    _age = value;
  }

  bool get isEmailVerified => _isemailVerified;

  set isEmailVerified(bool value) {
    _isemailVerified = value;
  }

  bool get isInvested => _isInvested;

  set isInvested(bool value) {
    _isInvested = value;
  }

  bool get isSimpleKycVerified => _isSimpleKycVerified;

  set isSimpleKycVerified(bool value) {
    _isSimpleKycVerified = value;
  }

  int get isKycVerified => _isKycVerified;

  set isKycVerified(int value) {
    _isKycVerified = value;
  }

  bool get isIciciOnboarded => _isIciciOnboarded;

  set isIciciOnboarded(bool value) {
    _isIciciOnboarded = value;
  }

  int get lifetime_winnings => _lifetime_winnings;

  set lifetime_winnings(int value) {
    _lifetime_winnings = value;
  }

  int get prize_balance => _prize_balance;

  set prize_balance(int value) {
    _prize_balance = value;
  }

  String get pendingTxnId => _pendingTxnId;

  set pendingTxnId(String value) {
    _pendingTxnId = value;
  }

  bool get isIciciEnabled => _isIciciEnabled;

  set isIciciEnabled(bool value) {
    _isIciciEnabled = value;
  }

  bool get isAugmontEnabled => _isAugmontEnabled;

  set isAugmontEnabled(bool value) {
    _isAugmontEnabled = value;
  }

  bool get isAugmontOnboarded => _isAugmontOnboarded;

  set isAugmontOnboarded(bool value) {
    _isAugmontOnboarded = value;
  }

  UserPreferences get userPreferences => _userPreferences;

  set userPreferences(UserPreferences value) {
    _userPreferences = value;
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
