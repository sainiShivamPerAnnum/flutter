import 'package:json_annotation/json_annotation.dart';

part 'new_booking.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  Map<String, List<TimeSlot>>? slots;
  bool? hasFreeCall;

  Schedule({this.slots, this.hasFreeCall});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class TimeSlot {
  String? fromTime;
  String? toTime;

  TimeSlot({this.fromTime, this.toTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}
