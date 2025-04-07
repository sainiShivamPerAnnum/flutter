import 'package:felloapp/core/model/fixedDeposit/my_fds.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fd_transaction.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class FDTransactionData {
  final String? jid;
  final String? status;
  final String? issuerId;
  final String? applicationId;
  final double? depositAmount;
  final String? tenure;
  final double? roi;
  final String? maturityDate;
  final String? depositDate;
  final List<BankDetails>? bankDetails;

  FDTransactionData({
    this.jid,
    this.status,
    this.issuerId,
    this.applicationId,
    this.depositAmount,
    this.roi,
    this.maturityDate,
    this.depositDate,
    this.bankDetails,
    this.tenure,
  });

  factory FDTransactionData.fromJson(Map<String, dynamic> json) =>
      _$FDTransactionDataFromJson(json);
}
