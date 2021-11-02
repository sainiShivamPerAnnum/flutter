class PrizesModel {
  String freq;
  String category;
  List<PrizesA> prizesA;

  PrizesModel({this.freq, this.category, this.prizesA});

  PrizesModel.fromJson(Map<String, dynamic> json) {
    freq = json['freq'];
    category = json['category'];
    if (json['prizes_a'] != null) {
      prizesA = <PrizesA>[];
      json['prizes_a'].forEach((v) {
        prizesA.add(new PrizesA.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['freq'] = this.freq;
    data['category'] = this.category;
    if (this.prizesA != null) {
      data['prizes_a'] = this.prizesA.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'freq': freq,
      'category': category,
      'prizes_a': prizesA?.map((x) => x.toMap())?.toList(),
    };
  }

  factory PrizesModel.fromMap(Map<String, dynamic> map) {
    return PrizesModel(
      freq: map['freq'],
      category: map['category'],
      prizesA:
          List<PrizesA>.from(map['prizes_a']?.map((x) => PrizesA.fromMap(x))),
    );
  }

  @override
  String toString() =>
      'PrizesModel(freq: $freq, category: $category, prizesA: ${prizesA.toString()})';
}

class PrizesA {
  int rank;
  int amt;
  int flc;
  String displayName;

  PrizesA({this.rank, this.amt, this.flc, this.displayName});

  PrizesA.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    amt = json['amt'];
    flc = json['flc'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['amt'] = this.amt;
    data['flc'] = this.flc;
    data['display_name'] = this.displayName;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'rank': rank,
      'amt': amt,
      'flc': flc,
      'display_name': displayName,
    };
  }

  factory PrizesA.fromMap(Map<String, dynamic> map) {
    return PrizesA(
      rank: map['rank'],
      amt: map['amt'],
      flc: map['flc'],
      displayName: map['display_name'],
    );
  }

  @override
  String toString() {
    return 'PrizesA(rank: $rank, amt: $amt, flc: $flc, displayName: $displayName)';
  }
}
