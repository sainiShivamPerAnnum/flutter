class UserKycDataModel {
  final String uid;
  final bool ocrVerified;
  final String status;
  final String pan;
  final String name;
  final String url;
  final bool augmontKyc;

  UserKycDataModel({
    required this.uid,
    required this.ocrVerified,
    required this.pan,
    required this.name,
    required this.url,
    required this.status,
    required this.augmontKyc,
  });

  UserKycDataModel.fromMap(Map<String, dynamic> map)
      : this(
          name: map["name"] ?? '',
          ocrVerified: map["ocrVerified"] ?? false,
          pan: map["pan"] ?? '',
          status: map['status'],
          uid: map["uid"] ?? '',
          url: map["url"] ?? '',
          augmontKyc: map["augmontKyc"] ?? false,
        );

  @override
  String toString() {
    return "Name: $name OcrVerified: $ocrVerified Pan: $pan Status: $status Uid: $uid Url: $url";
  }
}
