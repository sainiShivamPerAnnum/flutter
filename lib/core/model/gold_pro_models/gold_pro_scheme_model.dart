// ignore_for_file: public_member_api_docs, sort_constructors_first

class GoldProSchemeModel {
  final String id;
  final String jewellerUserAccountName;
  final String description;
  final String interestRate;
  final String minQtyLease;
  final String isSoldOut;
  final String isFreezeLease;
  final String logo;
  GoldProSchemeModel({
    required this.id,
    required this.interestRate,
    required this.minQtyLease,
    required this.description,
    required this.isFreezeLease,
    required this.jewellerUserAccountName,
    required this.isSoldOut,
    required this.logo,
  });

  factory GoldProSchemeModel.fromMap(Map<String, dynamic> map) {
    return GoldProSchemeModel(
      id: map['id'] ?? "",
      interestRate: map['interestRate'] ?? "",
      minQtyLease: map['minQtyLease'] ?? "",
      isSoldOut: map['isSoldOut'] ?? "",
      isFreezeLease: map['isFreezeLease'] ?? "",
      description: map['description'] ?? "",
      jewellerUserAccountName: map['jewellerUserAccountName'] ?? "",
      logo: map["profile"]["logo"] ?? "",
    );
  }

  @override
  String toString() {
    return 'GoldProSchemeModel(id: $id, interestRate: $interestRate, minQtyLease: $minQtyLease, isSoldOut: $isSoldOut, isFreezeLease: $isFreezeLease)';
  }

  @override
  bool operator ==(covariant GoldProSchemeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.interestRate == interestRate &&
        other.minQtyLease == minQtyLease &&
        other.isSoldOut == isSoldOut &&
        other.isFreezeLease == isFreezeLease;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        interestRate.hashCode ^
        minQtyLease.hashCode ^
        isSoldOut.hashCode ^
        isFreezeLease.hashCode;
  }
}
