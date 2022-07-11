import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimestampModel extends Timestamp {
  TimestampModel({@required int seconds, @required int nanoseconds})
      : super(seconds, nanoseconds);

  factory TimestampModel.fromMap(dynamic map) {
    if (map == null) return new TimestampModel(seconds: 0, nanoseconds: 0);

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

  Map<String, dynamic> toMap() {
    return {
      '_seconds': seconds,
      '_nanoseconds': nanoseconds,
    };
  }

  factory TimestampModel.currentTimeStamp() {
    return TimestampModel(
      seconds: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      nanoseconds: DateTime.now().millisecondsSinceEpoch * 1000,
    );
  }
}
