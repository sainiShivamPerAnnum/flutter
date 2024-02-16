// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class SubscriptionTransactionModel {
  final String id;
  final String type;
  final num amount;
  final String status;
  final String? note;
  final TimestampModel createdOn;
  final TimestampModel updateOn;
  final LbMap? lbMap;
  final AugMap? augMap;
  final MiscMap? miscMap;
  final RefundMap? refundMap;
  SubscriptionTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.note,
    required this.createdOn,
    required this.updateOn,
    required this.lbMap,
    required this.augMap,
    required this.miscMap,
    required this.refundMap,
  });

  static final helper = HelperModel<SubscriptionTransactionModel>(
    (map) => SubscriptionTransactionModel.fromMap(map),
  );

  factory SubscriptionTransactionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionTransactionModel(
      id: map['id'] as String,
      type: map['type'] as String,
      amount: map['amount'] as num,
      status: map['status'] as String,
      note: map['note'] as String,
      createdOn: TimestampModel.fromMap(map['createdOn']),
      updateOn: TimestampModel.fromMap(map['updateOn']),
      lbMap: LbMap.fromMap(map['lbMap'] as Map<String, dynamic>),
      augMap: AugMap.fromMap(map['augMap'] as Map<String, dynamic>),
      miscMap: MiscMap.fromMap(map['miscMap'] as Map<String, dynamic>),
      refundMap: RefundMap.fromMap(map['refundMap'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() {
    return 'SubscriptionTransactionModel(id: $id, type: $type, amount: $amount, status: $status, note: $note, createdOn: $createdOn, updateOn: $updateOn, lbMap: $lbMap, augMap: $augMap, miscMap: $miscMap, refundMap: $refundMap)';
  }
}

class LbMap {
  final String? status;
  final num? amount;
  final String? note;
  LbMap({
    required this.status,
    required this.amount,
    required this.note,
  });

  factory LbMap.fromMap(Map<String, dynamic> map) {
    return LbMap(
      status: map['status'],
      amount: map['amount'],
      note: map['note'],
    );
  }

  @override
  String toString() => 'LbMap(status: $status, amount: $amount, note: $note)';
}

class AugMap {
  String? status;
  num? amount;
  String? note;
  String? blockId;
  num? lockPrice;
  num? gold;
  num? closingBalance;
  AugMap({
    required this.status,
    required this.amount,
    required this.note,
    required this.blockId,
    required this.lockPrice,
    required this.gold,
    required this.closingBalance,
  });

  factory AugMap.fromMap(Map<String, dynamic> map) {
    return AugMap(
      status: map['status'],
      amount: map['amount'],
      note: map['note'],
      blockId: map['blockId'],
      lockPrice: map['lockPrice'],
      gold: map['gold'],
      closingBalance: map['closingBalance'],
    );
  }

  @override
  String toString() {
    return 'AugMap(status: $status, amount: $amount, note: $note, blockId: $blockId, lockPrice: $lockPrice, gold: $gold, closingBalance: $closingBalance)';
  }
}

class MiscMap {
  final num? tt;
  final List<String>? gts;
  MiscMap({
    required this.tt,
    required this.gts,
  });

  factory MiscMap.fromMap(Map<String, dynamic> map) {
    return MiscMap(
        tt: map['tt'],
        gts: map['gts'] != null
            ? []
            : List<String>.from(
                (map['gts'] as List<String>),
              ));
  }

  @override
  String toString() => 'MiscMap(tt: $tt, gts: $gts)';
}

class RefundMap {
  final String? id;
  final String? amount;
  final String? status;
  RefundMap({
    required this.id,
    required this.amount,
    required this.status,
  });

  factory RefundMap.fromMap(Map<String, dynamic> map) {
    return RefundMap(
      id: map['id'],
      amount: map['amount'],
      status: map['status'],
    );
  }

  @override
  String toString() => 'RefundMap(id: $id, amount: $amount, status: $status)';
}
