import 'dart:collection';

import 'package:felloapp/util/logger.dart';

class User {
  static Log log = new Log("User");
  String _uid;
  String _mobile;
  String _name;
  String _email;
  String _client_token;   //fetched from a subcollection
  static final String fldId = "mID";
  static final String fldMobile = "mMobile";
  static final String fldEmail = "mEmail";
  static final String fldName = "mName";
  static final String fldClient_token = "mClientToken";

  User(this._uid, this._mobile, this._email, this._name, this._client_token);

  static List<String> _fldList = [ fldMobile, fldEmail, fldName ];

  User.newUser(String id, String mobile) : this(id, mobile, null, null, null);

  User.fromMap(Map<String, dynamic> data, String id, [String client_token]) :
        this(id, data[fldMobile],  data[fldEmail], data[fldName], client_token);

  //to send user object to server
  toJson() {
    return {
      fldMobile: _mobile,
      fldName: _name,
      fldEmail: _email,
    };
  }

  //to compile from cache
  static User parseFile(List<String> contents) {
    try {
      Map<String, dynamic> gData = new HashMap();
      String id;
      String client_token;
      for (String line in contents) {
        if (line.contains('$fldId\$')) {
          id = line.split('\$')[1];
          continue;
        }
        else if (line.contains('$fldClient_token\$')) {
          client_token = line.split('\$')[1];
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
      return User.fromMap(gData, id, client_token);
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

    log.debug("Generated FileWrite String: " + oContent.toString());
    return oContent.toString();
  }

  bool hasIncompleteDetails() {
    return ((_mobile?.isEmpty??true) || (_name?.isEmpty??true) || (_email?.isEmpty??true));
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
}