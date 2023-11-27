import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampModel extends Timestamp {
  TimestampModel({required int seconds, required int nanoseconds})
      : super(seconds, nanoseconds);

  factory TimestampModel.fromMap(dynamic map) {
    if (map == null) return TimestampModel(seconds: 0, nanoseconds: 0);

    if (map.runtimeType == String) return TimestampModel.fromIsoString(map);

    return map.runtimeType == Timestamp
        ? TimestampModel.fromTimestamp(map as Timestamp)
        : TimestampModel(
            seconds: map['_seconds'] ?? 0,
            nanoseconds: map['_nanoseconds'] ?? 0,
          );
  }

  factory TimestampModel.fromTimestamp(Timestamp time) {
    return TimestampModel(
      seconds: time.seconds,
      nanoseconds: time.nanoseconds,
    );
  }

  factory TimestampModel.fromIsoString(String date) {
    return TimestampModel.fromTimestamp(
      Timestamp.fromDate(DateTime.parse(date)),
    );
  }

  static String toIsoString(TimestampModel date) {
    return date.toDate().toUtc().toIso8601String();
  }

  Map<String, dynamic> toMap() {
    return {
      '_seconds': seconds,
      '_nanoseconds': nanoseconds,
    };
  }

  factory TimestampModel.currentTimeStamp() {
    final timeStamp = Timestamp.now();
    return TimestampModel(
      seconds: timeStamp.seconds,
      nanoseconds: timeStamp.nanoseconds,
    );
  }

  factory TimestampModel.none() {
    return TimestampModel(seconds: 0, nanoseconds: 0);
  }

  int operator -(TimestampModel other) {
    return toDate().difference(other.toDate()).inDays;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }
}
