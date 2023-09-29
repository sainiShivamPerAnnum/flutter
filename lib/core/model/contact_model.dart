class Contact {
  final String displayName;
  final String phoneNumber;
  bool? isRegistered;

  Contact(
      {required this.displayName,
      required this.phoneNumber,
      this.isRegistered});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Future<void> copyWith({required bool isRegistered}) async {
    this.isRegistered = isRegistered;
  }
}
