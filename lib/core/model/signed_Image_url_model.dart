class SignedImageUrlModel {
  final String id;
  final String url;
  final String key;
  final String message;

  SignedImageUrlModel({
    required this.id,
    required this.url,
    required this.key,
    required this.message,
  });

  SignedImageUrlModel.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'] as String,
          key: map['key'] as String,
          message: map['message'] as String,
          url: map['url'] as String,
        );
}
