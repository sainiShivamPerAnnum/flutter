// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'data': instance.data
          ?.map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
    };

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      fromTime: json['fromTime'] as String?,
      toTime: json['toTime'] as String?,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
    };
