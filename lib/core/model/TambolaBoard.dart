import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class TambolaBoard{
  static Log log = new Log('TambolaBoard');
  final Timestamp assigned_time;
  final String val;
  final String id;
  final int week_code;
  static final String fldAssignedTime = 'assigned_time';
  static final String fldId = 'id';
  static final String fldBoardValue = 'val';
  static final String fldWeekCode = 'week_code';

  TambolaBoard({this.assigned_time, this.val, this.id, this.week_code});

  TambolaBoard.fromMap(Map<String, dynamic> data)
    : this(
    assigned_time: data[fldAssignedTime],
    val: data[fldBoardValue],
    id: data[fldId],
    week_code: data[fldWeekCode]
  );

  bool isValid() {
    return (val != null); //TODO
  }
}