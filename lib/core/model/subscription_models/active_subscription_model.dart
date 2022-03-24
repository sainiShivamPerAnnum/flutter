import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveSubscriptionModel {
  String subId;
  String amountType;
  Timestamp expiryDate;
  String frequencyUnit;
  double autoAmount;
  String vpa;
  Timestamp updatedOn;
  double maxAmount;
  Timestamp createdOn;
  Timestamp startDate;
  int frequency;
  String status;
  String autoFrequency;

  ActiveSubscriptionModel(
      {this.subId,
      this.amountType,
      this.expiryDate,
      this.frequencyUnit,
      this.autoAmount,
      this.vpa,
      this.updatedOn,
      this.maxAmount,
      this.createdOn,
      this.startDate,
      this.frequency,
      this.status,
      this.autoFrequency});

  ActiveSubscriptionModel.fromJson(Map<String, dynamic> json, String sid) {
    subId = sid;
    amountType = json['amountType'];
    expiryDate = json['expiryDate'];
    frequencyUnit = json['frequencyUnit'];
    autoAmount = (json['autoAmount'] ?? 0).toDouble();
    vpa = json['vpa'];
    updatedOn = json['updatedOn'];
    maxAmount = (json['maxAmount'] ?? 0).toDouble();
    createdOn = json['createdOn'];
    startDate = json['startDate'];
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
