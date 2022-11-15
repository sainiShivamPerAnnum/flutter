class UserKycDataModel {
  final String uid;
  final bool ocrVerified;
  final String pan;
  final String name;
  final String url;
  final TrackResult trackResult;

  UserKycDataModel(
      {this.uid,
      this.ocrVerified,
      this.pan,
      this.name,
      this.url,
      this.trackResult});

  UserKycDataModel.fromMap(Map<String, dynamic> map)
      : this(
          name: map["name"] ?? '',
          ocrVerified: map["ocrVerified"] ?? false,
          pan: map["pan"] ?? '',
          trackResult: map['trackResult'] != null
              ? TrackResult.fromMap(map["trackResult"])
              : null,
          uid: map["uid"] ?? '',
          url: map["url"] ?? '',
        );
}

class TrackResult {
  final String status;
  final String reason;

  TrackResult({this.status, this.reason});

  TrackResult.fromMap(Map<String, dynamic> map)
      : this(status: map["status"], reason: map["reason"]);
}
