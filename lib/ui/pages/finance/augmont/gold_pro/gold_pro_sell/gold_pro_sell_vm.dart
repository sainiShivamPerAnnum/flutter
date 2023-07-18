// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';

class GoldProSellViewModel extends BaseViewModel {
  List<GoldProSellCardModel> leasedGoldList = [
    GoldProSellCardModel(
        amount: 1000,
        extraGold: 0.5,
        leasedOn: TimestampModel.currentTimeStamp(),
        maturityOn: TimestampModel.currentTimeStamp(),
        status: GoldProSellStatus.leased,
        value: 0.6),
    GoldProSellCardModel(
        amount: 1000,
        extraGold: 0.5,
        leasedOn: TimestampModel.currentTimeStamp(),
        maturityOn: TimestampModel.currentTimeStamp(),
        status: GoldProSellStatus.leased,
        value: 0.6),
    GoldProSellCardModel(
        amount: 1000,
        extraGold: 0.5,
        leasedOn: TimestampModel.currentTimeStamp(),
        maturityOn: TimestampModel.currentTimeStamp(),
        status: GoldProSellStatus.leased,
        value: 0.6),
    GoldProSellCardModel(
        amount: 1000,
        extraGold: 0.5,
        leasedOn: TimestampModel.currentTimeStamp(),
        maturityOn: TimestampModel.currentTimeStamp(),
        status: GoldProSellStatus.leased,
        value: 0.6)
  ];
  void init() {}

  void dump() {}
}

class GoldProSellCardModel {
  final double amount;
  final double value;
  final TimestampModel leasedOn;
  final double extraGold;
  final TimestampModel maturityOn;
  final GoldProSellStatus status;
  GoldProSellCardModel({
    required this.amount,
    required this.value,
    required this.leasedOn,
    required this.extraGold,
    required this.maturityOn,
    required this.status,
  });

  GoldProSellCardModel copyWith({
    double? amount,
    double? value,
    TimestampModel? leasedOn,
    double? extraGold,
    TimestampModel? maturityOn,
    GoldProSellStatus? status,
  }) {
    return GoldProSellCardModel(
      amount: amount ?? this.amount,
      value: value ?? this.value,
      leasedOn: leasedOn ?? this.leasedOn,
      extraGold: extraGold ?? this.extraGold,
      maturityOn: maturityOn ?? this.maturityOn,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'value': value,
      'leasedOn': leasedOn.toMap(),
      'extraGold': extraGold,
      'maturityOn': maturityOn.toMap(),
      'status': status.name,
    };
  }

  factory GoldProSellCardModel.fromMap(Map<String, dynamic> map) {
    return GoldProSellCardModel(
      amount: map['amount'] as double,
      value: map['value'] as double,
      leasedOn: TimestampModel.fromMap(map['leasedOn'] as Map<String, dynamic>),
      extraGold: map['extraGold'] as double,
      maturityOn:
          TimestampModel.fromMap(map['maturityOn'] as Map<String, dynamic>),
      status: GoldProSellStatus.leased,
    );
  }

  String toJson() => json.encode(toMap());

  factory GoldProSellCardModel.fromJson(String source) =>
      GoldProSellCardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GoldProSellCardModel(amount: $amount, value: $value, leasedOn: $leasedOn, extraGold: $extraGold, maturityOn: $maturityOn, status: $status)';
  }

  @override
  bool operator ==(covariant GoldProSellCardModel other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        other.value == value &&
        other.leasedOn == leasedOn &&
        other.extraGold == extraGold &&
        other.maturityOn == maturityOn &&
        other.status == status;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        value.hashCode ^
        leasedOn.hashCode ^
        extraGold.hashCode ^
        maturityOn.hashCode ^
        status.hashCode;
  }
}

enum GoldProSellStatus { leased, processing, unleased }
