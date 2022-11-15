class UserKycDataModel {
  final String uid;
  final bool ocrVerified;
  final String status;
  final String pan;
  final String name;
  final String url;

  UserKycDataModel(
      {this.uid, this.ocrVerified, this.pan, this.name, this.url, this.status});

  UserKycDataModel.fromMap(Map<String, dynamic> map)
      : this(
          name: map["name"] ?? '',
          ocrVerified: map["ocrVerified"] ?? false,
          pan: map["pan"] ?? '',
          status: map['trackResult'],
          uid: map["uid"] ?? '',
          url: map["url"] ?? '',
        );
}
