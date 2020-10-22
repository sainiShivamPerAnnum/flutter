import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class TambolaBoard{
  static Log log = new Log('TambolaBoard');
  final Timestamp assigned_time;
  final String val;
  final Timestamp validity_start;
  final Timestamp validity_end;
  static final String fldAssignedTime = 'assigned_time';
  static final String fldValidityStart = 'validity_start';
  static final String fldValidityEnd = 'validity_end';
  static final String fldBoardValue = 'val';

  TambolaBoard({this.assigned_time, this.val, this.validity_start, this.validity_end});

  TambolaBoard.fromMap(Map<String, dynamic> data, String id)
    : this(
    assigned_time: data[fldAssignedTime],
    val: data[fldBoardValue],
    validity_start: data[fldValidityStart],
    validity_end: data[fldValidityEnd]
  );
}