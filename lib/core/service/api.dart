import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/ReferralDetail.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Api {
  Log log = new Log("Api");
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final rdb.FirebaseDatabase _realtimeDatabase = rdb.FirebaseDatabase.instance;

  String path;
  CollectionReference ref;

  Api();

  Future<void> updateUserClientToken(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_FCM);
    return ref.doc(Constants.DOC_USER_FCM_TOKEN).set(data);
  }

  Future<DocumentSnapshot> getUserById(String id) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(id).get();
  }

  Future<void> updateUserDocument(String docId, Map data) {
    ref = _db.collection(Constants.COLN_USERS);
    return ref.doc(docId).set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserIciciDetailDocument(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_ICICI_DETAILS);
    return ref.doc(Constants.DOC_USER_ICICI_DETAIL).get();
  }

  Future<void> updateUserIciciDetailDocument(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_ICICI_DETAILS);
    return ref
        .doc(Constants.DOC_USER_ICICI_DETAIL)
        .set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserAugmontDetailDocument(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_AUGMONT_DETAILS);
    return ref.doc(Constants.DOC_USER_AUGMONT_DETAIL).get();
  }

  Future<void> updateUserAugmontDetailDocument(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_AUGMONT_DETAILS);
    return ref
        .doc(Constants.DOC_USER_AUGMONT_DETAIL)
        .set(data, SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserKycDetailDocument(String userId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_KYC_DETAILS);
    return ref.doc(Constants.DOC_USER_KYC_DETAIL).get();
  }

  Future<void> updateUserKycDetailDocument(String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_KYC_DETAILS);
    return ref
        .doc(Constants.DOC_USER_KYC_DETAIL)
        .set(data, SetOptions(merge: true));
  }

  Future<DocumentReference> addUserTransactionDocument(
      String userId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    return ref.add(data);
  }

  Future<DocumentSnapshot> getUserTransactionDocument(
      String userId, String txnId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    return ref.doc(txnId).get();
  }

  Future<void> updateUserTransactionDocument(
      String userId, String txnId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    return ref.doc(txnId).set(data, SetOptions(merge: true));
  }

  Future<DocumentReference> createTicketRequest(String userId, Map data) {
    return _db.collection(Constants.COLN_TICKETREQUEST).add(data);
  }

  Stream<DocumentSnapshot> getticketRequestDocumentEvent(String docId) {
    return _db.collection(Constants.COLN_TICKETREQUEST).doc(docId).snapshots();
  }

  Future<QuerySnapshot> getValidUserTickets(String user_id, int weekCode) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(user_id)
        .collection(Constants.SUBCOLN_USER_TICKETS);
    query = query.where(TambolaBoard.fldWeekCode, isEqualTo: weekCode);

    //return query.snapshots();
    return query.get();
  }

  Future<QuerySnapshot> getWeekPickByCde(int weekCde) {
    Query query = _db
        .collection(Constants.COLN_DAILYPICKS)
        .where(DailyPick.fldWeekCode, isEqualTo: weekCde);

    return query.get();
  }

  //set the mentioned fields to true
  Future<bool> setReferralDocBonusField(String uid) async {
    DocumentReference _rRef = _db.collection(Constants.COLN_REFERRALS).doc(uid);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_rRef);
          if (!snapshot.exists) {
            //did not sign up via referral
            throw Exception('No referral found');
          } else if (snapshot.data() == null ||
              snapshot.data()[ReferralDetail.fldUsrBonusFlag] == null ||
              snapshot.data()[ReferralDetail.fldRefereeBonusFlag] == null) {
            throw Exception('Empty/invalid data');
          } else {
            bool _uFlag, _rFlag;
            try {
              _uFlag = snapshot.data()[ReferralDetail.fldUsrBonusFlag];
              _rFlag = snapshot.data()[ReferralDetail.fldRefereeBonusFlag];
            } catch (e) {
              throw Exception('Failed to create bool flags');
            }
            if (_uFlag == null || _rFlag == null) {
              throw Exception('Failed to create bool flags');
            }
            if (_uFlag == true && _rFlag == true) {
              //referral bonus already unlocked
              throw Exception('Referral bonus already unlocked');
            } else {
              Map<String, dynamic> rMap = {};
              rMap[ReferralDetail.fldUsrBonusFlag] = true;
              rMap[ReferralDetail.fldRefereeBonusFlag] = true;
              transaction.set(_rRef, rMap, SetOptions(merge: true));
              return true;
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  Future<void> updateReferralDocument(String docId, Map data) {
    return _db
        .collection(Constants.COLN_REFERRALS)
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> addFeedbackDocument(Map data) {
    return _db.collection(Constants.COLN_FEEDBACK).add(data);
  }

  Future<void> addFailedReportDocument(Map data) {
    return _db.collection(Constants.COLN_FAILREPORTS).add(data);
  }

  Future<QuerySnapshot> getWinnersByWeekCde(int weekCde) async {
    Query query = _db
        .collection(Constants.COLN_WINNERS)
        .where('week_code', isEqualTo: weekCde)
        .where('win_type', isEqualTo: 'tambola');
    final response = await query.get();
    return response;
  }

  Future updateWeeklyWinnerDocument(String docId, Map data) async {
    return _db.collection(Constants.COLN_WINNERS).doc(docId).update(data);
  }

  Future<QuerySnapshot> getCredentialsByTypeAndStage(
      String type, String stage, int index) {
    Query query = _db
        .collection(Constants.COLN_CREDENTIALS)
        .where('type', isEqualTo: type)
        .where('stage', isEqualTo: stage)
        .where('index', isEqualTo: index);

    return query.get();
  }

  Future<QuerySnapshot> getUserTransactionsByField(
      String user_id, String type, String subtype, int limit) {
    Query query = _db
        .collection(Constants.COLN_USERS)
        .doc(user_id)
        .collection(Constants.SUBCOLN_USER_TXNS);
    if (type != null)
      query = query.where(UserTransaction.fldType, isEqualTo: type);
    if (subtype != null)
      query = query.where(UserTransaction.fldSubType, isEqualTo: subtype);
    if (limit != -1 && limit > 10) query = query.limit(limit);
    query = query.orderBy(UserTransaction.fldTimestamp, descending: true);

    return query.get();
  }

  Future<void> addCallbackDocument(String year, String monthCde, Map data) {
    return _db
        .collection('callbacks')
        .doc(year)
        .collection(monthCde)
        .doc()
        .set(data, SetOptions(merge: false));
  }

  Future<void> addDepositDocument(String year, String monthCde, Map data) {
    return _db
        .collection('deposits')
        .doc(year)
        .collection(monthCde)
        .doc()
        .set(data, SetOptions(merge: false));
  }

  Future<void> addWithdrawalDocument(String year, String monthCde, Map data) {
    return _db
        .collection('withdrawals')
        .doc(year)
        .collection(monthCde)
        .doc()
        .set(data, SetOptions(merge: false));
  }

  Future<void> addClaimDocument(Map data) {
    return _db.collection('claims').doc().set(data, SetOptions(merge: false));
  }

  Future<QuerySnapshot> getReferralDocs(String id) {
    ref = _db.collection(Constants.COLN_REFERRALS);
    return ref.where('ref_by', isEqualTo: id).get();
  }

  Future<DocumentSnapshot> getUserReferDoc(String id) {
    ref = _db.collection(Constants.COLN_REFERRALS);
    return ref.doc(id).get();
  }

  Future<DocumentSnapshot> getPollDocument(String id) {
    ref = _db.collection(Constants.COLN_POLLS);
    return ref.doc(id).get();
  }

  Future<dynamic> incrementPollDocument(String id, String field) {
    ref = _db.collection(Constants.COLN_POLLS);
    Map<String, dynamic> upObj = {};
    upObj[field] = FieldValue.increment(1);

    return ref.doc(id).update(upObj);
  }

  Future<void> addUserPollResponseDocument(String id, String pollId, Map data) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_POLL_RESPONSES);
    return ref.doc(pollId).set(data, SetOptions(merge: false));
  }

  Future<DocumentSnapshot> getUserPollResponseDocument(
      String id, String pollId) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_POLL_RESPONSES);
    return ref.doc(pollId).get();
  }

  Future<DocumentSnapshot> getUserFundWalletDocById(String id) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_WALLET);
    return ref.doc(Constants.DOC_USER_WALLET_FUND_BALANCE).get();
  }

  Future<bool> updateUserFundWalletFields(
      String userId, String verifyFld, double verifyValue, Map data) {
    DocumentReference _docRef = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_WALLET)
        .doc(Constants.DOC_USER_WALLET_FUND_BALANCE);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_docRef);
          if (!snapshot.exists) {
            //wallet didnt exist?
            transaction.set(_docRef, data, SetOptions(merge: true));
          } else {
            Map<String, dynamic> _map = snapshot.data();
            if (_map[verifyFld] == null) {
              ///field doesnt exist. add the field
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else if (_map[verifyFld] != null &&
                _map[verifyFld] == verifyValue) {
              ///field exists and the condition is satisfied
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else {
              ///field exists but there is a data discrepancy
              throw Exception('Condition not satisfied');
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  Future<QuerySnapshot> getRecentAugmontDepositTxn(
      String userId, Timestamp cmpTimestamp) {
    Query _query = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_TXNS);
    _query = _query
        .where(UserTransaction.fldSubType,
            isEqualTo: UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
        .where(UserTransaction.fldType,
            isEqualTo: UserTransaction.TRAN_TYPE_DEPOSIT)
        .where(UserTransaction.fldTranStatus,
            isEqualTo: UserTransaction.TRAN_STATUS_COMPLETE)
        .where(UserTransaction.fldTimestamp,
            isGreaterThanOrEqualTo: cmpTimestamp);
    // .orderBy(UserTransaction.fldTimestamp, descending: true).startAfter([cmpTimestamp]);

    return _query.get();
  }

  Future<DocumentSnapshot> getUserTicketWalletDocById(String id) {
    ref = _db
        .collection(Constants.COLN_USERS)
        .doc(id)
        .collection(Constants.SUBCOLN_USER_WALLET);
    return ref.doc(Constants.DOC_USER_WALLET_TICKET_BALANCE).get();
  }

  Future<bool> updateUserTicketWalletFields(
      String userId, String verifyFld, int verifyValue, Map data) {
    DocumentReference _docRef = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_WALLET)
        .doc(Constants.DOC_USER_WALLET_TICKET_BALANCE);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_docRef);
          if (!snapshot.exists) {
            //wallet didnt exist?
            transaction.set(_docRef, data, SetOptions(merge: true));
          } else {
            Map<String, dynamic> _map = snapshot.data();
            if (_map[verifyFld] == null) {
              ///field doesnt exist. add the field
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else if (_map[verifyFld] != null &&
                _map[verifyFld] == verifyValue) {
              ///field exists and the condition is satisfied
              transaction.set(_docRef, data, SetOptions(merge: true));
            } else {
              ///field exists but there is a data discrepancy
              throw Exception('Condition not satisfied');
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  //sets the 'gGEN_COUNT_LEFT' field in the user ticket wallet object
  Future<bool> setUserTicketWalletGenerationField(
      String userId, String actionFld, int count) {
    DocumentReference _docRef = _db
        .collection(Constants.COLN_USERS)
        .doc(userId)
        .collection(Constants.SUBCOLN_USER_WALLET)
        .doc(Constants.DOC_USER_WALLET_TICKET_BALANCE);
    return _db
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(_docRef);
          if (!snapshot.exists) {
            return false;
          } else {
            Map<String, dynamic> _map = snapshot.data();
            if (_map[actionFld] != null && _map[actionFld] > 0) {
              ///generation field already presesnt
              throw Exception('Field already present');
            } else {
              transaction.update(_docRef, {'$actionFld': count});
            }
          }
        })
        .then((value) => true)
        .catchError((onErr) => false);
  }

  Future<QuerySnapshot> getLeaderboardDocument(String category, int weekCde) {
    Query _query = _db
        .collection(Constants.COLN_LEADERBOARD)
        .where('category', isEqualTo: category)
        .where('week_code', isEqualTo: weekCde);
    return _query.get();
  }

  Future<QuerySnapshot> getHomeCardCollection() {
    Query _query = _db.collection(Constants.COLN_HOMECARDS).orderBy('id');
    return _query.get();
  }

  Future<String> getFileFromDPBucketURL(String uid, String path) {
    return _storage.ref('dps/$uid/$path').getDownloadURL();
  }

  Future<bool> deleteUserTicketsBeforeWeekCode(String uid, int weekCde) async {
    bool flag = true;
    Query _query = _db
        .collection(Constants.COLN_USERS)
        .doc(uid)
        .collection(Constants.SUBCOLN_USER_TICKETS)
        .where('week_code', isLessThan: weekCde);
    List<DocumentReference> _docReferences = [];
    try {
      QuerySnapshot _querySnapshot = await _query.get();
      _querySnapshot.docs.forEach((dDoc) {
        if (dDoc.exists) _docReferences.add(dDoc.reference);
      });
    } catch (e) {
      log.error('Failed to retrieve ticket documents: $e');
      flag = false;
    }

    if (_docReferences.length > 0) {
      try {
        var opBatch = _db.batch();
        for (var ref in _docReferences) {
          opBatch.delete(ref);
        }
        log.debug(
            'Deleting ${_docReferences.length.toString()} ticket documents');

        await opBatch.commit();
      } catch (e) {
        log.error('DB Batch operation failed: $e');
        flag = false;
      }
    }
    return flag;
  }

  Future<bool> deleteUserTicketDocuments(
      String uid, List<String> references) async {
    if (references.length > 0) {
      CollectionReference colnReference = _db
          .collection(Constants.COLN_USERS)
          .doc(uid)
          .collection(Constants.SUBCOLN_USER_TICKETS);
      try {
        var opBatch = _db.batch();
        for (String ref in references) {
          opBatch.delete(colnReference.doc(ref));
        }
        log.debug('Deleting ${references.length.toString()} ticket documents');

        await opBatch.commit();
        return true;
      } catch (e) {
        log.error('DB Batch operation failed: $e');
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> createEmailVerificationDocument(String email, String otp) async {
    String htmlCode = getOtpEmailHTML(otp);

    Map<String, dynamic> data = {
      'to': [email],
      'message': {
        'text': 'This is the text body',
        'subject': '$otp - OTP for email verification',
        'html': htmlCode
      }
    };
    try {
      await _db.collection('emailotprequests').add(data);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //---------------------------------------REALTIME DATABASE-------------------------------------------//

  Future<bool> checkUserNameAvailability(String username) async {
    try {
      rdb.DataSnapshot data = await _realtimeDatabase
          .reference()
          .child("usernames")
          .child(username)
          .once();
      print(data.key.toString() + "  " + data.value.toString());
      if (data.value != null) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setUserName(String username, String userId) async {
    try {
      await _realtimeDatabase
          .reference()
          .child("usernames")
          .child(username)
          .set(userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  String getOtpEmailHTML(String otp) {
    return """ 
      <!DOCTYPE HTML
  >
<html >

<head>ks

  <title></title>

  <style type="text/css">
    table,
    td {ks
      color: #000000;
    }

    a {
      color: #0000ee;
      text-decoration: underline;
    }

    @media (max-width: 480px) {
      #u_content_button_4 .v-padding {
        padding: 20px 50px !important;
      }
    }

    @media only screen and (min-width: 620px) {
      .u-row {
        width: 600px !important;
      }

      .u-row .u-col {
        vertical-align: top;
      }

      .u-row .u-col-100 {
        width: 600px !important;
      }

    }

    @media (max-width: 620px) {
      .u-row-container {
        max-width: 100% !important;
        padding-left: 0px !important;
        padding-right: 0px !important;
      }

      .u-row .u-col {
        min-width: 320px !important;
        max-width: 100% !important;
        display: block !important;
      }

      .u-row {
        width: calc(100% - 40px) !important;
      }

      .u-col {
        width: 100% !important;
      }

      .u-col>div {
        margin: 0 auto;
      }
    }

    body {
      margin: 0;
      padding: 0;
    }

    table,
    tr,
    td {
      vertical-align: top;
      border-collapse: collapse;
    }

    p {
      margin: 0;
    }

    .ie-container table,
    .mso-container table {
      table-layout: fixed;
    }

    * {
      line-height: inherit;
    }

    a[x-apple-data-detectors='true'] {
      color: inherit !important;
      text-decoration: none !important;
    }
  </style>



  <!--[if !mso]><!-->
  <link href="https://fonts.googleapis.com/css?family=Lato:400,700&display=swap" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,700&display=swap" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Raleway:400,700&display=swap" rel="stylesheet" type="text/css">

</head>

<body class="clean-body"
  style="margin: 0;padding: 0;-webkit-text-size-adjust: 100%;background-color: #efefef;color: #000000">

  <table
    style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;min-width: 320px;Margin: 0 auto;background-color: #efefef;width:100%"
    cellpadding="0" cellspacing="0">
    <tbody>
      <tr style="vertical-align: top">
        <td style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">


          <div class="u-row-container" style="padding: 0px;background-color: transparent">
            <div class="u-row"
              style="Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #020887;">
              <div style="border-collapse: collapse;display: table;width: 100%;background-color: transparent;">
              <div class="u-col u-col-100"
                  style="max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;">
                  <div style="width: 100% !important;">
                    <div
                      style="padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;">

                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:25px 10px 13px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                  <td style="padding-right: 0px;padding-left: 0px;" align="center">

                                    <img align="center" border="0"
                                      src="https://fello.in/src/images/fello_logo_2_grey.png" alt="Image" title="Image"
                                      style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: inline-block !important;border: none;height: auto;float: none;width: 28%;max-width: 162.4px;"
                                      width="162.4" />

                                  </td>
                                </tr>
                              </table>

                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>



          <div class="u-row-container" style="padding: 0px;background-color: transparent">
            <div class="u-row"
              style="Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #ffffff;">
              <div style="border-collapse: collapse;display: table;width: 100%;background-color: transparent;">
                <!--[if (mso)|(IE)]><table width="100%" cellpadding="0" cellspacing="0" border="0"><tr><td style="padding: 0px;background-color: transparent;" align="center"><table cellpadding="0" cellspacing="0" border="0" style="width:600px;"><tr style="background-color: #ffffff;"><![endif]-->

                <!--[if (mso)|(IE)]><td align="center" width="600" style="width: 600px;padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;" valign="top"><![endif]-->
                <div class="u-col u-col-100"
                  style="max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;">
                  <div style="width: 100% !important;">
                    <!--[if (!mso)&(!IE)]><!-->
                    <div
                      style="padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;">
                      <!--<![endif]-->

                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:20px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <table height="0px" align="center" border="0" cellpadding="0" cellspacing="0" width="100%"
                                style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 0px solid #BBBBBB;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%">
                                <tbody>
                                  <tr style="vertical-align: top">
                                    <td
                                      style="word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%">
                                      <span>&#160;</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>

                            </td>
                          </tr>
                        </tbody>
                      </table>

                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:0px 25px 10px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <div
                                style="color: #333333; line-height: 160%; text-align: center; word-wrap: break-word;">
                                <p style="font-size: 14px; line-height: 160%;"><span
                                    style="font-size: 16px; line-height: 25.6px; font-family: Lato, sans-serif;">Hi,
                                    Thank you for choosing Fello.</span></p>
                              </div>

                            </td>
                          </tr>
                        </tbody>
                      </table>

                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:25px 10px 30px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <div
                                style="color: #333333; line-height: 140%; text-align: center; word-wrap: break-word;">
                                <p style="font-size: 14px; line-height: 140%;"><span
                                    style="font-size: 22px; line-height: 30.8px;">Your OTP is</span></p>
                              </div>

                            </td>
                          </tr>
                        </tbody>
                      </table>

                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>



          <div class="u-row-container" style="padding: 0px;background-color: transparent">
            <div class="u-row"
              style="Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #ffffff;">
              <div style="border-collapse: collapse;display: table;width: 100%;background-color: transparent;">
                <div class="u-col u-col-100"
                  style="max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;">
                  <div style="width: 100% !important;">
                    <div
                      style="padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;">

                      <table id="u_content_button_4" style="font-family:'Open Sans',sans-serif;" role="presentation"
                        cellpadding="0" cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <div align="center">
                                <a href="" target="_blank"
                                  style="box-sizing: border-box;display: inline-block;font-family:'Open Sans',sans-serif;text-decoration: none;-webkit-text-size-adjust: none;text-align: center;color: #FFFFFF; background-color: #e67e23; border-radius: 35px; -webkit-border-radius: 35px; -moz-border-radius: 35px; width:auto; max-width:100%; overflow-wrap: break-word; word-break: break-word; word-wrap:break-word; mso-border-alt: none;">
                                  <span class="v-padding"
                                    style="display:block;padding:20px 40px;line-height:120%;"><span
                                      style="font-size: 14px; line-height: 16.8px;"><strong><span
                                          style="line-height: 16.8px; font-size: 14px;">$otp</span></strong></span></span>
                                </a>
                              </div>

                            </td>
                          </tr>
                        </tbody>
                      </table>

                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="u-row-container" style="padding: 0px;background-color: transparent">
            <div class="u-row"
              style="Margin: 0 auto;min-width: 320px;max-width: 600px;overflow-wrap: break-word;word-wrap: break-word;word-break: break-word;background-color: #ffffff;">
              <div style="border-collapse: collapse;display: table;width: 100%;background-color: transparent;">
                <div class="u-col u-col-100"
                  style="max-width: 320px;min-width: 600px;display: table-cell;vertical-align: top;">
                  <div style="width: 100% !important;">
                    <div
                      style="padding: 0px;border-top: 0px solid transparent;border-left: 0px solid transparent;border-right: 0px solid transparent;border-bottom: 0px solid transparent;">
                      
                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:30px 50px 10px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <div style="line-height: 180%; text-align: left; word-wrap: break-word;">
                                <p style="line-height: 180%; text-align: center; font-size: 14px;"><span
                                    style="font-family: Lato, sans-serif;"><span
                                      style="font-size: 16px; line-height: 28.8px;">For any queries, please reach out
                                      through </span></span></p>
                                <p style="line-height: 180%; text-align: center; font-size: 14px;"><span
                                    style="font-family: Lato, sans-serif;"><span
                                      style="font-size: 16px; line-height: 28.8px;">any of the means available
                                      below</span></span></p>
                              </div>

                            </td>
                          </tr>
                        </tbody>
                      </table>

                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:30px 10px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <table height="0px" align="center" border="0" cellpadding="0" cellspacing="0" width="72%"
                                style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;border-top: 1px solid #413d45;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%">
                                <tbody>
                                  <tr style="vertical-align: top">
                                    <td
                                      style="word-break: break-word;border-collapse: collapse !important;vertical-align: top;font-size: 0px;line-height: 0px;mso-line-height-rule: exactly;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%">
                                      <span>&#160;</span>
                                    </td>
                                  </tr>
                                </tbody>
                              </table>

                            </td>
                          </tr>
                        </tbody>
                      </table>

                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <div align="center">
                                <div style="display: table; max-width:155px;">
                                 <table align="left" border="0" cellspacing="0" cellpadding="0" width="32" height="32"
                                    style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 20px">
                                    <tbody>
                                      <tr style="vertical-align: top">
                                        <td align="left" valign="middle"
                                          style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
                                          <a href="https://www.instagram.com/fellofinance/?hl=en" title="Instagram" target="_blank">
                                            <img
                                              src="https://lh3.googleusercontent.com/proxy/gPPhtB9BRZjMB87TesvXo7AMzwNruNXTxaMw8ZnL8oYmClipGqBKBFXCn66OyQrfSt6hF730HIeH3peo2ULiROZwhH4rzm5w2PYD5eDajlu7nYScPerP_XRYg4l5G3ZYnF4Mx8L5CiGRQafd8HCH_uwnLt5z"
                                              alt="Instagram" title="Instagram" width="32"
                                              style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important">
                                          </a>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                  <table align="left" border="0" cellspacing="0" cellpadding="0" width="32" height="32"
                                    style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 20px">
                                    <tbody>
                                      <tr style="vertical-align: top">
                                        <td align="left" valign="middle"
                                          style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
                                          <a href="https://wa.me/${917993252690}/?text=Hello Fello" title="WhatsApp" target="_blank">
                                            <img
                                              src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/479px-WhatsApp.svg.png"
                                              alt="WhatsApp" title="WhatsApp" width="32"
                                              style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important">
                                          </a>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                 <table align="left" border="0" cellspacing="0" cellpadding="0" width="32" height="32"
                                    style="border-collapse: collapse;table-layout: fixed;border-spacing: 0;mso-table-lspace: 0pt;mso-table-rspace: 0pt;vertical-align: top;margin-right: 0px">
                                    <tbody>
                                      <tr style="vertical-align: top">
                                        <td align="left" valign="middle"
                                          style="word-break: break-word;border-collapse: collapse !important;vertical-align: top">
                                          <a href="https://www.linkedin.com/company/fellofinance/?originalSubdomain=in" title="LinkedIn" target="_blank">
                                            <img
                                              src="https://www.raulvelazquezphd.com/wp-content/uploads/2017/10/LinkedIn-1.png"
                                              alt="LinkedIn" title="LinkedIn" width="32"
                                              style="outline: none;text-decoration: none;-ms-interpolation-mode: bicubic;clear: both;display: block !important;border: none;height: auto;float: none;max-width: 32px !important">
                                          </a>
                                        </td>
                                      </tr>
                                    </tbody>
                                  </table>
                                 </div>
                              </div>

                            </td>
                          </tr>
                        </tbody>
                      </table>

                      <table style="font-family:'Open Sans',sans-serif;" role="presentation" cellpadding="0"
                        cellspacing="0" width="100%" border="0">
                        <tbody>
                          <tr>
                            <td
                              style="overflow-wrap:break-word;word-break:break-word;padding:10px;font-family:'Open Sans',sans-serif;"
                              align="left">

                              <div
                                style="color: #7e7e81; line-height: 150%; text-align: center; word-wrap: break-word;">
                                <p style="line-height: 150%; font-size: 14px;"><span
                                    style="font-size: 12px; line-height: 18px;">Fello Technologies</span></p>
                                <p style="font-size: 14px; line-height: 150%;"><span
                                    style="font-size: 12px; line-height: 18px;">4321 Area Ave.&nbsp; I&nbsp; North town
                                    CA 2345&nbsp; I&nbsp; Country Name. </span></p>
                                <p style="font-size: 14px; line-height: 150%;"><span
                                    style="font-size: 12px; line-height: 18px;">Company Number: 07094561</span></p>
                                <p style="font-size: 14px; line-height: 150%;"><span
                                    style="font-size: 12px; line-height: 18px;">&copy; Healthcare. Inc. </span></p>
                              </div>

                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
             </div>
            </div>
          </div>


        </td>
      </tr>
    </tbody>
  </table>

</body>

</html>
    
    """;
  }
}
