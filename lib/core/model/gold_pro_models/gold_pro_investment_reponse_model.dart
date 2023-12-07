// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class GoldProInvestmentResponseModel {
  final String id;
  final String uid;
  final String status;
  final String schemeId;
  final String fdId;
  final int days;
  final double qty;
  final double interest;
  final String note;
  final double amount;
  final bool isWithdrawable;
  final double interest_collected;
  final num interestPaid;
  final String message;
  final TimestampModel createdOn;
  final TimestampModel updatedOn;
  final String message_un_lease;
  final String? subText;

  GoldProInvestmentResponseModel({
    required this.id,
    required this.uid,
    required this.fdId,
    required this.status,
    required this.schemeId,
    required this.days,
    required this.qty,
    required this.interest,
    required this.note,
    required this.amount,
    required this.isWithdrawable,
    required this.interest_collected,
    required this.message,
    required this.createdOn,
    required this.updatedOn,
    required this.message_un_lease,
    required this.interestPaid,
    this.subText,
  });

  static final helper = HelperModel<GoldProInvestmentResponseModel>(
      GoldProInvestmentResponseModel.fromMap);

  factory GoldProInvestmentResponseModel.fromMap(Map<String, dynamic> map,
      {String? subText}) {
    return GoldProInvestmentResponseModel(
      interestPaid:
          map['interest_paid'] != null ? map['interest_paid'] as num : 0,
      id: map['id'] as String,
      uid: map['uid'] as String,
      status: map['status'] as String,
      fdId: map["fdId"] ?? map["fd_id"] ?? "",
      schemeId: map['schemeId'] ?? map["scheme_id"] ?? "",
      days: map['days'] ?? 0,
      qty: (map['qty'] ?? 0).toDouble() ?? 0.0,
      interest: (map['interest'] ?? 0).toDouble() ?? 0.0,
      note: (map['note'] ?? "") as String,
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

  @override
  String toString() {
    return 'GoldProInvestmentResponseModel(id: $id, uid: $uid, status: $status, schemeId: $schemeId, days: $days, qty: $qty, interest: $interest, note: $note, createdOn: $createdOn, updatedOn: $updatedOn)';
  }
}
