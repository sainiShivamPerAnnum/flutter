import 'package:cloud_firestore/cloud_firestore.dart';

class TicketRequest {
  int count;
  bool manual;
  Timestamp timestamp;
  String user_id;
  int week_code;
  String docKey;
  String status;

  TicketRequest(this.count, this.manual, this.timestamp, this.user_id,
      this.week_code, this.docKey, this.status);

  TicketRequest.fromMap(Map<String, dynamic> data, String id)
      : this(data['count'], data['manual'], data['timestamp'], data['user_id'],
            data['week_code'], id, data['status']);

  toJson() {
    return {
      'user_id': user_id,
      'manual': manual,
      'count': count,
      'week_code': week_code,
      'status': status,
      'timestamp': timestamp
    };
  }
}
