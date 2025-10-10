// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDetails _$CartDetailsFromJson(Map<String, dynamic> json) => CartDetails(
      advisorId: json['advisorId'] as String,
      advisorName: json['advisorName'] as String,
      advisorImg: json['advidorImg'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      duration: (json['duration'] as num?)?.toInt(),
      fromTime: json['fromTime'] as String?,
      toTime: json['toTime'] as String?,
    );
