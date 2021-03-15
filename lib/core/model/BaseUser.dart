import 'dart:collection';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';

class BaseUser {
  static Log log = new Log("User");
  String _uid;
  String _mobile;
  String _name;
  String _email;
  String _client_token;   //fetched from a subcollection
  int _ticket_count;
  int _account_balance;
  int _deposit_balance;
  int _prize_balance;
  double _icici_balance;
  double _augmont_balance;
  int _lifetime_winnings;
  String _pan;
  String _age;
  bool _isInvested;
  bool _isIciciOnboarded;
  bool _isAugmontOnboarded;
  int _isKycVerified;
  String _pendingTxnId;
  bool _isIciciEnabled;
  bool _isAugmontEnabled;

  static final String fldId = "mID";
  static final String fldMobile = "mMobile";
  static final String fldEmail = "mEmail";
  static final String fldName = "mName";
  static final String fldClient_token = "mClientToken";
  static final String fldTicket_count = "mTicketCount";
  static final String fldAcctBalance = "mAcctBalance";
  static final String fldDepositBalance = "mDepBalance";
  static final String fldPriBalance = "mPriBalance";
  static final String fldICICIBalance = "mICBalance";
  static final String fldAugmontBalance = "mAugBalance";
  static final String fldLifeTimeWinnings = "mLifeTimeWin";
  static final String fldPan = "mPan";
  static final String fldAge = "mAge";
  static final String fldIsInvested = "mIsInvested";
  static final String fldIsIciciOnboarded = "mIsIciciOnboarded";
  static final String fldIsAugmontOnboarded = "mIsAugmontOnboarded";
  static final String fldIsKycVerified = "mIsKycVerified";
  static final String fldPendingTxnId = "mPendingTxnId";
  static final String fldIsIciciEnabled = "mIsIciciEnabled";
  static final String fldIsAugmontEnabled = "mIsAugmontEnabled";

  BaseUser(this._uid, this._mobile, this._email, this._name, this._client_token,
      this._ticket_count, this._account_balance, this._deposit_balance,
      this._prize_balance, this._icici_balance, this._augmont_balance,
      this._lifetime_winnings, this._pan, this._age, this._isInvested,
      this._isIciciOnboarded, this._isAugmontOnboarded, this._isKycVerified,
      this._pendingTxnId, this._isIciciEnabled, this._isAugmontEnabled);

  static List<String> _fldList = [ fldMobile, fldEmail, fldName, fldPan, fldAge ];

  BaseUser.newUser(String id, String mobile) : this(id, mobile, null, null, null,
      BaseUtil.NEW_USER_TICKET_COUNT, 0, 0, 0, 0, 0, 0, null, null, false, false,false,
      BaseUtil.KYC_UNTESTED,null,null,null);

  BaseUser.fromMap(Map<String, dynamic> data, String id, [String client_token]) :
        this(id, data[fldMobile], data[fldEmail], data[fldName], client_token,
          data[fldTicket_count]??BaseUtil.NEW_USER_TICKET_COUNT, data[fldAcctBalance]??0,
          data[fldDepositBalance]??0,data[fldPriBalance]??0, data[fldICICIBalance]??0,
          data[fldAugmontBalance]??0,data[fldLifeTimeWinnings]??0,data[fldPan],
          data[fldAge], data[fldIsInvested]??false,data[fldIsIciciOnboarded]??false,
          data[fldIsAugmontOnboarded]??false,data[fldIsKycVerified]??BaseUtil.KYC_UNTESTED,
          data[fldPendingTxnId],data[fldIsIciciEnabled],data[fldIsAugmontEnabled]
      );

  //to send user object to server
  toJson() {
    var userObj = {
      fldMobile: _mobile,
      fldName: _name,
      fldEmail: _email,
      fldTicket_count: _ticket_count,
      fldAcctBalance: _account_balance,
      fldDepositBalance: _deposit_balance,
      fldPriBalance: _prize_balance,
      fldICICIBalance: _icici_balance,
      fldAugmontBalance: _augmont_balance,
      fldLifeTimeWinnings: _lifetime_winnings,
      fldPan: _pan,
      fldAge: _age,
      fldIsInvested: _isInvested,
      fldIsIciciOnboarded: _isIciciOnboarded,
      fldIsAugmontOnboarded: _isAugmontOnboarded,
      fldIsKycVerified: _isKycVerified,
      fldPendingTxnId: _pendingTxnId
    };
    if(_isIciciEnabled != null)userObj[fldIsIciciEnabled]=_isIciciEnabled;
    if(_isAugmontEnabled != null)userObj[fldIsAugmontEnabled]=_isAugmontEnabled;

    return userObj;
  }

  //to compile from cache
  static BaseUser parseFile(List<String> contents) {
    try {
      Map<String, dynamic> gData = new HashMap();
      String id;
      String client_token;
      bool isInv = false;
      for (String line in contents) {
        if (line.contains('$fldId\$')) {
          id = line.split('\$')[1];
          continue;
        }
        else if (line.contains('$fldClient_token\$')) {
          client_token = line.split('\$')[1];
          continue;
        }
        else if (line.contains('$fldIsInvested\$')) {
          String inFlag = line.split('\$')[1];
          try{
            int isx = int.parse(inFlag);
            gData[fldIsInvested] = (isx == 1);
          }catch(e) {
            isInv = false;
          }
          continue;
        }
        else if (line.contains('$fldTicket_count\$')) {
          String a = line.split('\$')[1];
          try{
            int count = int.parse(a);
            gData[fldTicket_count] = count;
          }catch(e) {
            gData[fldTicket_count] = BaseUtil.NEW_USER_TICKET_COUNT;
          }
          continue;
        }
        else if (line.contains('$fldAcctBalance\$')) {
          String a = line.split('\$')[1];
          try{
            int balance = int.parse(a);
            gData[fldAcctBalance] = balance;
          }catch(e) {
            gData[fldAcctBalance] = 0;
          }
          continue;
        }
        else {
          _fldList.forEach((fld) {
            if (line.contains('$fld\$')) {
              gData.putIfAbsent(fld, () {
                String res = line.split('\$')[1];
                return (res != null && res.length > 0) ? res : '';
              });
            }
          });
        }
      }
      return BaseUser.fromMap(gData, id, client_token);
    }catch(e) {
      log.error("Caught Exception while parsing local User file: " + e.toString());
      return null;
    }
  }

  //to save in cache
  String toFileString() {
    StringBuffer oContent = new StringBuffer();
    oContent.writeln(fldId + '\$' + _uid.trim());
    oContent.writeln(fldMobile + '\$' + _mobile.trim());
    if(_email != null) oContent.writeln(fldEmail + '\$' +_email.trim());
    if(_name != null) oContent.writeln(fldName + '\$' + _name.trim());
    if(_client_token != null)oContent.writeln(fldClient_token + '\$' + _client_token.trim());
    if(_ticket_count != null)oContent.writeln(fldTicket_count + '\$' + _ticket_count.toString());
    if(_account_balance != null)oContent.writeln(fldAcctBalance + '\$' + _account_balance.toString());
    if(_pan != null)oContent.writeln(fldPan + '\$' + _pan.trim());
    if(_isInvested != null)oContent.writeln(fldIsInvested + '\$' + ((_isInvested)?'1':'0'));
    if(_age != null)oContent.writeln(fldAge + '\$' + _age.trim());

    log.debug("Generated FileWrite String: " + oContent.toString());
    return oContent.toString();
  }

  bool hasIncompleteDetails() {
    //return ((_mobile?.isEmpty??true) || (_name?.isEmpty??true) || (_email?.isEmpty??true));
    return (((_mobile?.isEmpty??true) || (_name?.isEmpty??true))||_ticket_count==null);
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

  String get mobile => _mobile;

  set mobile(String value) {
    _mobile = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  int get ticket_count => _ticket_count;

  set ticket_count(int value) {
    _ticket_count = value;
  }

  int get account_balance => _account_balance;

  set account_balance(int value) {
    _account_balance = value;
  }

  double get augmont_balance => _augmont_balance;

  set augmont_balance(double value) {
    _augmont_balance = value;
  }

  String get pan => _pan;

  set pan(String value) {
    _pan = value;
  }

  String get age => _age;

  set age(String value) {
    _age = value;
  }

  bool get isInvested => _isInvested;

  set isInvested(bool value) {
    _isInvested = value;
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

  int get deposit_balance => _deposit_balance;

  set deposit_balance(int value) {
    _deposit_balance = value;
  }

  double get icici_balance => _icici_balance;

  set icici_balance(double value) {
    _icici_balance = value;
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
}