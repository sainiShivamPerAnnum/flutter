import 'package:felloapp/core/model/timestamp_model.dart';

class SubscriptionModel {
  String? id;
  String? uid;
  String? merchantSubId;
  String? amount;
  String? authTxnId;
  String? frequency;
  String? recurringCount;
  String? status;
  String? note;
  String? cloudTask;
  String? resumeFrequency;
  TimestampModel? resumeDate;
  TimestampModel? startDate;
  TimestampModel? createdOn;
  TimestampModel? updatedOn;

  SubscriptionModel(
      {this.id,
      this.uid,
      this.merchantSubId,
      this.amount,
      this.authTxnId,
      this.frequency,
      this.recurringCount,
      this.status,
      this.note,
      this.cloudTask,
      this.resumeFrequency,
      this.resumeDate,
      this.startDate,
      this.createdOn,
      this.updatedOn});

  SubscriptionModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    uid = map['uid'];
    merchantSubId = map['merchantSubId'];
    amount = map['amount'];
    authTxnId = map['authTxnId'];
    frequency = map['frequency'];
    recurringCount = map['recurringCount'];
    status = map['status'];
    note = map['note'];
    cloudTask = map['cloudTask'];
    resumeFrequency = map['resumeFrequency'];
    resumeDate = TimestampModel.fromMap(map['resumeDate']);
    startDate = TimestampModel.fromMap(map['startDate']);
    createdOn = TimestampModel.fromMap(map['createdOn']);
    updatedOn = TimestampModel.fromMap(map['updatedOn']);
  }
}
