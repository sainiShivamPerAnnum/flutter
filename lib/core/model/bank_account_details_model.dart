import 'dart:convert';

import 'package:flutter/material.dart';

class BankAccountDetailsModel {
  final String? id;
  final String? account;
  final String? ifsc;
  final String? name;
  BankAccountDetailsModel({
    @required this.id,
    @required this.account,
    @required this.ifsc,
    @required this.name,
  });

  BankAccountDetailsModel copyWith({
    String? id,
    String? account,
    String? ifsc,
    String? name,
  }) {
    return BankAccountDetailsModel(
      id: id ?? this.id,
      account: account ?? this.account,
      ifsc: ifsc ?? this.ifsc,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'account': account,
      'ifsc': ifsc,
      'name': name,
    };
  }

  factory BankAccountDetailsModel.fromMap(Map<String, dynamic> map) {
    return BankAccountDetailsModel(
      id: map['id'] as String?,
      account: map['account'] as String?,
      ifsc: map['ifsc'] as String?,
      name: map['name'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory BankAccountDetailsModel.fromJson(String source) =>
      BankAccountDetailsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BankAccountDetailsModel(id: $id, account: $account, ifsc: $ifsc, name: $name)';
  }

  @override
  bool operator ==(covariant BankAccountDetailsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.account == account &&
        other.ifsc == ifsc &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ account.hashCode ^ ifsc.hashCode ^ name.hashCode;
  }
}
