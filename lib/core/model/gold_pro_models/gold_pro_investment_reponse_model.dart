// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class GoldProInvestmentResponseModel {
  final String id;
  final String status;
  final String schemeId;
  final double qty;
  final double amount;
  final bool isWithdrawable;
  final double interest_collected;
  final String message;
  final TimestampModel createdOn;
  final TimestampModel updatedOn;
  final String message_un_lease;
  final String? subText;

  const GoldProInvestmentResponseModel({
    required this.id,
    required this.status,
    required this.schemeId,
    required this.qty,
    required this.amount,
    required this.isWithdrawable,
    required this.interest_collected,
    required this.message,
    required this.createdOn,
    required this.updatedOn,
    required this.message_un_lease,
    this.subText,
  });

  static final helper = HelperModel<GoldProInvestmentResponseModel>(
      GoldProInvestmentResponseModel.fromMap);

  factory GoldProInvestmentResponseModel.fromMap(Map<String, dynamic> map,
      {String? subText}) {
    return GoldProInvestmentResponseModel(
      id: map['id'] as String,
      status: map['status'] as String,
      schemeId: map['schemeId'] ?? map["scheme_id"] ?? "",
      qty: (map['qty'] ?? 0).toDouble() ?? 0.0,
      amount: (map['amount'] ?? 0).toDouble() ?? 0.0,
      isWithdrawable: map['isWithdrawable'] ?? false,
      interest_collected: (map['interest_collected'] ?? 0).toDouble() ?? 0.0,
      message: map["message"] ?? "",
      createdOn: TimestampModel.fromMap(map['createdOn']),
      updatedOn: TimestampModel.fromMap(map['updatedOn']),
      message_un_lease:
          map["message_un_lease"] ?? "Unable to un-lease at the moment",
      subText: subText,
    );
  }
}
