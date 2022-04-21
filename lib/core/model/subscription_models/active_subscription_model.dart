import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveSubscriptionModel {
  String amountType;
  double autoAmount;
  String autoFrequency;
  Timestamp createdOn;
  Timestamp expiryDate;
  int frequency;
  String frequencyUnit;
  double maxAmount;
  Timestamp startDate;
  String status;
  String resumeDate;
  String resumeEnum;
  String subscriptionId;
  String vpa;
  Timestamp updatedOn;

  ActiveSubscriptionModel(
      {this.subscriptionId,
      this.amountType,
      this.expiryDate,
      this.frequencyUnit,
      this.autoAmount,
      this.vpa,
      this.resumeDate,
      this.resumeEnum,
      this.updatedOn,
      this.maxAmount,
      this.createdOn,
      this.startDate,
      this.frequency,
      this.status,
      this.autoFrequency});

  ActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscriptionId'];
    amountType = json['amountType'];
    expiryDate = Timestamp(
        json['expiryDate']["_seconds"], json['expiryDate']["_nanoseconds"]);
    frequencyUnit = json['frequencyUnit'];
    autoAmount = (json['autoAmount'] ?? 0).toDouble();
    vpa = json['vpa'];
    resumeDate = json['resumeDate'] ?? "";
    resumeEnum = json['resumeEnum'] ?? "";
    updatedOn = Timestamp(
        json['updatedOn']["_seconds"], json['updatedOn']["_nanoseconds"]);
    maxAmount = (json['maxAmount'] ?? 0).toDouble();
    createdOn = Timestamp(
        json['createdOn']["_seconds"], json['createdOn']["_nanoseconds"]);
    startDate = Timestamp(
        json['startDate']["_seconds"], json['startDate']["_nanoseconds"]);
    frequency = json['frequency'];
    status = json['status'];
    autoFrequency = json['autoFrequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amountType'] = this.amountType;
    data['expiryDate'] = this.expiryDate;
    data['frequencyUnit'] = this.frequencyUnit;
    data['autoAmount'] = this.autoAmount;
    data['vpa'] = this.vpa;
    data['resumeDate'] = this.resumeDate;
    data['resumeEnum'] = this.resumeEnum;
    data['updatedOn'] = this.updatedOn;
    data['maxAmount'] = this.maxAmount;
    data['createdOn'] = this.createdOn;
    data['startDate'] = this.startDate;
    data['frequency'] = this.frequency;
    data['status'] = this.status;
    data['autoFrequency'] = this.autoFrequency;
    return data;
  }
}
