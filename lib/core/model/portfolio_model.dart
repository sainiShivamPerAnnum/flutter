// ignore_for_file: public_member_api_docs, sort_constructors_first

class Portfolio {
  final Asset gold;
  final FloTiers flo;
  final double rewards;
  final Asset absolute;
  final Asset goldPro;
  Portfolio({
    required this.gold,
    required this.flo,
    required this.rewards,
    required this.absolute,
    required this.goldPro,
  });

  factory Portfolio.fromMap(Map<String, dynamic> map) {
    return Portfolio(
        gold: Asset.fromMap(map['gold'] as Map<String, dynamic>),
        flo: FloTiers.fromMap(map['flo'] as Map<String, dynamic>),
        rewards: (map['rewards'] ?? 0.0) * 1.0,
        absolute: Asset.fromMap(map['absolute'] as Map<String, dynamic>),
        goldPro: Asset.fromMap(map['goldFd'] as Map<String, dynamic>));
  }

  factory Portfolio.base() {
    return Portfolio(
      gold: Asset.base(),
      flo: FloTiers.base(),
      rewards: 0.0,
      absolute: Asset.base(),
      goldPro: Asset.base(),
    );
  }
}

class FloTiers {
  final double absGains;
  final double percGains;
  final double principle;
  final double balance;
  final Asset flexi;
  final Asset fixed1;
  final Asset fixed2;
  FloTiers({
    required this.absGains,
    required this.percGains,
    required this.principle,
    required this.balance,
    required this.flexi,
    required this.fixed1,
    required this.fixed2,
  });

  factory FloTiers.fromMap(Map<String, dynamic> map) {
    return FloTiers(
      absGains: (map['absGain'] ?? 0.0) * 1.0,
      percGains: (map['percGain'] ?? 0.0) * 1.0,
      principle: map["principle"] * 1.0,
      balance: (map['balance'] ?? 0.0) * 1.0,
      flexi: Asset.fromMap(map['flexi'] as Map<String, dynamic>),
      fixed1: Asset.fromMap(map['fixed1'] as Map<String, dynamic>),
      fixed2: Asset.fromMap(map['fixed2'] as Map<String, dynamic>),
    );
  }

  factory FloTiers.base() {
    return FloTiers(
      absGains: 0.0,
      percGains: 0.0,
      principle: 0.0,
      balance: 0.0,
      flexi: Asset.base(),
      fixed1: Asset.base(),
      fixed2: Asset.base(),
    );
  }
}

class Asset {
  final double absGains;
  final double percGains;
  final double principle;
  final double balance;
  Asset({
    required this.absGains,
    required this.percGains,
    required this.principle,
    required this.balance,
  });

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      absGains: (map['absGain'] ?? 0.0) * 1.0,
      percGains: (map['percGain'] ?? 0.0) * 1.0,
      principle: (map["principle"] ?? 0.0) * 1.0,
      balance: (map["balance"] ?? 0.0) * 1.0,
    );
  }
  factory Asset.base() {
    return Asset(absGains: 0.0, percGains: 0.0, principle: 0.0, balance: 0.0);
  }
}
