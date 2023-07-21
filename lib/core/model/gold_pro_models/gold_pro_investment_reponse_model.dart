// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class GoldProInvestmentResponseModel {
  final String id;
  final String uid;
  final String status;
  final String schemeId;
  final int days;
  final double qty;
  final double interest;
  final String note;
  final TimestampModel createdOn;
  final TimestampModel updatedOn;
  GoldProInvestmentResponseModel({
    required this.id,
    required this.uid,
    required this.status,
    required this.schemeId,
    required this.days,
    required this.qty,
    required this.interest,
    required this.note,
    required this.createdOn,
    required this.updatedOn,
  });

  static final helper = HelperModel<GoldProInvestmentResponseModel>(
      GoldProInvestmentResponseModel.fromMap);

  factory GoldProInvestmentResponseModel.fromMap(Map<String, dynamic> map) {
    return GoldProInvestmentResponseModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      status: map['status'] as String,
      schemeId: map['schemeId'] as String,
      days: map['days'] as int,
      qty: map['qty'] as double,
      interest: map['interest'] as double,
      note: (map['note'] ?? "") as String,
      createdOn: TimestampModel.fromMap(map['createdOn']),
      updatedOn: TimestampModel.fromMap(map['updatedOn']),
    );
  }

  @override
  String toString() {
    return 'GoldProInvestmentResponseModel(id: $id, uid: $uid, status: $status, schemeId: $schemeId, days: $days, qty: $qty, interest: $interest, note: $note, createdOn: $createdOn, updatedOn: $updatedOn)';
  }
}
