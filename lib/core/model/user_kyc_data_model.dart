class UserKycDataModel {
  final String uid;
  final bool ocrVerified;
  final String status;
  final String pan;
  final String name;
  final String url;

  UserKycDataModel({
    required this.uid,
    required this.ocrVerified,
    required this.pan,
    required this.name,
    required this.url,
    required this.status,
  });

  UserKycDataModel.fromMap(Map<String, dynamic> map)
      : this(
          name: map["name"] ?? '',
          ocrVerified: map["ocrVerified"] ?? false,
          pan: map["pan"] ?? '',
          status: map['status'],
          uid: map["uid"] ?? '',
          url: map["url"] ?? '',
        );

  @override
  String toString() {
    // TODO: implement toString
    return "Name: $name OcrVerified: $ocrVerified Pan: $pan Status: $status Uid: $uid Url: $url";
  }
}
