// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'bank_account_details_model.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class BankAccountDetailsModel {
  final String id;
  final String account;
  final String logo;
  final String bankName;
  final String ifsc;
  final String name;
  final NetBankingStatus netBankingStatus;
  final BankAvailability availability;
  final String? message;

  const BankAccountDetailsModel({
    this.id = '',
    this.account = '',
    this.ifsc = '',
    this.name = '',
    this.bankName = '',
    this.logo = 'https://img.phonepe.com/images/banks/40/40/DEFAULT.png',
    this.netBankingStatus = NetBankingStatus.UN_SUPPORTED,
    this.availability = BankAvailability.UNAVAILABLE,
    this.message,
  });

  factory BankAccountDetailsModel.fromMap(Map<String, dynamic> json) =>
      _$BankAccountDetailsModelFromJson(json);
}

extension BankDetailsValidator on BankAccountDetailsModel {
  bool get isDetailsAreValid => account.isNotEmpty && ifsc.isNotEmpty;
}

enum NetBankingStatus {
  SUPPORTED,
  UN_SUPPORTED;

  bool get isSupported => this == NetBankingStatus.SUPPORTED;
}

enum BankAvailability {
  AVAILABLE,
  UNAVAILABLE,
  DEGRADED;
}
