// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySIPFunds _$MySIPFundsFromJson(Map<String, dynamic> json) => MySIPFunds(
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      subs: (json['subs'] as List<dynamic>)
          .map((e) => Subs.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Subs _$SubsFromJson(Map<String, dynamic> json) => Subs(
      id: json['id'] as String,
      fundType: json['fundType'] as String,
      sipamount: json['sipamount'] as int,
      investedamount: json['investedamount'] as int,
      status: json['status'] as String,
      frequency: json['frequency'] as String,
      startDate: json['startDate'] as String,
      nextDue: json['nextDue'] as String,
    );
