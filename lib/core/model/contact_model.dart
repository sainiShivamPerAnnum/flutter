class Contact {
  final String displayName;
  final String phoneNumber;

  Contact({required this.displayName, required this.phoneNumber});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
