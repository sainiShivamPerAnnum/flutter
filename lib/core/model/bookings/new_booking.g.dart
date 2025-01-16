// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      slots: (json['slots'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      hasFreeCall: json['hasFreeCall'] as bool?,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'slots': instance.slots
          ?.map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
      'hasFreeCall': instance.hasFreeCall,
    };

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      fromTime: json['fromTime'] as String?,
      toTime: json['toTime'] as String?,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'fromTime': instance.fromTime,
      'toTime': instance.toTime,
    };
