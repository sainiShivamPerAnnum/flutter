import 'package:json_annotation/json_annotation.dart';

part 'sip_transaction_model.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class MySIPFunds {
  final String message;
  final Data data;
  MySIPFunds({required this.message, required this.data});

  factory MySIPFunds.fromJson(Map<String, dynamic> json) =>
      _$MySIPFundsFromJson(json);
}

@_deserializable
class Data {
  final List<Subs> subs;

  Data({required this.subs});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@_deserializable
class Subs {
  final String id;
  final String fundType;
  final int sipamount;
  final int investedamount;
  final String status;
  final String frequency;
  final String startDate;
  final String nextDue;

  Subs(
      {required this.id,
      required this.fundType,
      required this.sipamount,
      required this.investedamount,
      required this.status,
      required this.frequency,
      required this.startDate,
      required this.nextDue});

  factory Subs.fromJson(Map<String, dynamic> json) => _$SubsFromJson(json);
}
