import 'dart:convert';
import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class CouponModel {
  final String id;
  final String code;
  final String description;
  final TimestampModel expiresOn;
  final TimestampModel createdOn;
  final int maxUse;
  final int priority;
  final int minPurchase;
  final String highlight;
  static final helper =
      HelperModel<CouponModel>((map) => CouponModel.fromMap(map));
  CouponModel({
    this.id,
    this.code,
    this.description,
    this.expiresOn,
    this.createdOn,
    this.maxUse,
    this.priority,
    this.minPurchase,
    this.highlight,
  });

  CouponModel copyWith({
    String id,
    String code,
    String description,
    TimestampModel expireOn,
    TimestampModel createdOn,
    int maxUse,
    int priority,
    int minPurchase,
    String highlight,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      expiresOn: expireOn ?? this.expiresOn,
      createdOn: createdOn ?? this.createdOn,
      maxUse: maxUse ?? this.maxUse,
      priority: priority ?? this.priority,
      minPurchase: minPurchase ?? this.minPurchase,
      highlight: highlight ?? this.highlight,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'description': description,
      'expiresOn': expiresOn.toMap(),
      'createdOn': createdOn.toMap(),
      'maxUse': maxUse,
      'priority': priority,
      'minPurchase': minPurchase,
      'highlight': highlight,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id'] as String,
      code: map['code'] as String,
      description: map['description'] as String,
      expiresOn: TimestampModel.fromMap(map['expiresOn']),
      createdOn: TimestampModel.fromMap(map['createdOn']),
      maxUse: map['maxUse'] as int,
      priority: map['priority'] as int,
      minPurchase: map['minPurchase'] as int,
      highlight: map['highlight'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CouponModel(id: $id, code: $code, description: $description, expiresOn: $expiresOn, createdOn: $createdOn, maxUse: $maxUse, priority: $priority, minPurchase: $minPurchase, highlight: $highlight)';
  }

  @override
  bool operator ==(covariant CouponModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.description == description &&
        other.expiresOn == expiresOn &&
        other.createdOn == createdOn &&
        other.maxUse == maxUse &&
        other.priority == priority &&
        other.minPurchase == minPurchase &&
        other.highlight == highlight;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        description.hashCode ^
        expiresOn.hashCode ^
        createdOn.hashCode ^
        maxUse.hashCode ^
        priority.hashCode ^
        minPurchase.hashCode ^
        highlight.hashCode;
  }
}
