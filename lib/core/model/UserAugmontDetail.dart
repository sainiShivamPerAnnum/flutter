import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserAugmontDetail {
  Log log = new Log('UserAugmontDetail');
  String _panNumber;
  String _hasIssue;
  String _email;
  String _bankAccNo;
  String _bankHolderName;
  String _userState;
  bool _firstInvMade;
  Timestamp _createdTime;
  Timestamp _updatedTime;

  static final String fldPanNumber = 'aPanNumber';
  static final String fldHasIssue = 'aHasIssue';
  static final String fldCreatedTime = 'aCreatedTime';
  static final String fldUpdatedTime = 'aUpdatedTime';


}