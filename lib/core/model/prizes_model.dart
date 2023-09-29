import 'package:felloapp/core/model/helper_model.dart';

class PrizesModel {
  String? freq;
  String? category;
  List<Prizes>? prizes, prizesA;

  PrizesModel({this.freq, this.category, this.prizesA, this.prizes});

  factory PrizesModel.fromMap(Map<String, dynamic> map) {
    return PrizesModel(
      freq: map['freq'],
      category: map['category'],
      prizesA: map["prizes_a"] != null
          ? Prizes.helper.fromMapArray(map["prizes_a"])
          : [],
      prizes: map["prizes"] != null
          ? Prizes.helper.fromMapArray(map["prizes"])
          : [],
    );
  }

  @override
  String toString() =>
      'PrizesModel(freq: $freq, category: $category, prizesA: ${prizesA.toString()})';
}

class Prizes {
  int? rank;
  int? amt;
  int? flc;
  String? displayName;
  String? displayPrize;
  String? displayAmount;

  Prizes(
      {this.rank,
      this.amt,
      this.flc,
      this.displayName,
      this.displayAmount,
      this.displayPrize});

  static final helper = HelperModel<Prizes>((map) => Prizes.fromMap(map));

  factory Prizes.fromMap(Map<String, dynamic> map) {
    return Prizes(
      rank: map['rank'] ?? 0,
      amt: map['amt'] ?? 0,
      flc: map['flc'] ?? 0,
      displayName: map['display_name'] ?? "",
      displayAmount: map['display_amount'] ?? "",
      displayPrize: map['display_prize'] ?? "",
    );
  }

  @override
  String toString() {
    return 'PrizesA(rank: $rank, amt: $amt, flc: $flc, displayName: $displayName)';
  }
}
