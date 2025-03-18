import 'package:json_annotation/json_annotation.dart';

part 'fd_transaction.g.dart';

@JsonSerializable()
class FDTransactionData {
  final String jid;
  final String status;
  final String issuerId;
  final String applicationId;
  final double depositAmount;
  final String? tenure;
  final double roi;
  final String maturityDate;
  final String depositDate;
  final List<BankDetails> bankDetails;

  FDTransactionData({
    required this.jid,
    required this.status,
    required this.issuerId,
    required this.applicationId,
    required this.depositAmount,
    required this.roi,
    required this.maturityDate,
    required this.depositDate,
    required this.bankDetails,
    this.tenure,
  });

  factory FDTransactionData.fromJson(Map<String, dynamic> json) =>
      _$FDTransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$FDTransactionDataToJson(this);
}

@JsonSerializable()
class BankDetails {
  final String bankName;
  final String accountNumber;

  BankDetails({
    required this.bankName,
    required this.accountNumber,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BankDetailsToJson(this);
}
