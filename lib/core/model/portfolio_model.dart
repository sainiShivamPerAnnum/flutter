// ignore_for_file: public_member_api_docs, sort_constructors_first

class Portfolio {
  final AugmontTiers augmont;
  final FloTiers flo;
  final double rewards;
  final double lifeTimeRewards;
  final Asset absolute;

  const Portfolio({
    required this.augmont,
    required this.flo,
    required this.rewards,
    required this.lifeTimeRewards,
    required this.absolute,
  });

  factory Portfolio.fromMap(Map<String, dynamic> map) {
    return Portfolio(
      augmont: AugmontTiers.fromMap(map['augmont']),
      flo: FloTiers.fromMap(map['flo']),
      lifeTimeRewards: (map['lifeTimeRewards'] ?? 0.0) * 1.0,
      rewards: (map['rewards'] ?? 0.0) * 1.0,
      absolute: Asset.fromMap(map['absolute']),
    );
  }

  factory Portfolio.base() {
    return Portfolio(
      augmont: AugmontTiers.base(),
      flo: FloTiers.base(),
      lifeTimeRewards: 0.0,
      rewards: 0.0,
      absolute: Asset.base(),
    );
  }
}

class AugmontTiers {
  final double absGains;
  final double percGains;
  final double principle;
  final double balance;
  final Asset gold;
  final Asset fd;

  const AugmontTiers({
    required this.absGains,
    required this.percGains,
    required this.principle,
    required this.balance,
    required this.gold,
    required this.fd,
  });

  factory AugmontTiers.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return AugmontTiers.base();

    return AugmontTiers(
      absGains: (map['absGain'] ?? 0.0) * 1.0,
      percGains: (map['percGain'] ?? 0.0) * 1.0,
      principle: (map["principle"] ?? 0.0) * 1.0,
      balance: (map["balance"] ?? 0.0) * 1.0,
      gold: Asset.fromMap(map['gold']),
      fd: Asset.fromMap(map['fd']),
    );
  }

  @override
  String toString() {
    return 'AugmontTiers(absGains: $absGains, percGains: $percGains, principle: $principle, balance: $balance, gold: $gold, fd: $fd)';
  }

  factory AugmontTiers.base() {
    return AugmontTiers(
      absGains: 0.0,
      percGains: 0.0,
      principle: 0.0,
      balance: 0.0,
      gold: Asset.base(),
      fd: Asset.base(),
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
  final double balance; // gold balance in rupees.
  final bool isGoldProUser;
  final num currentValue; // total gold quantity with principle and interest.
  final num leased; // total leased amount in quantity.
  final num payouts; // interest gain in quantity.

  const Asset({
    required this.absGains,
    required this.percGains,
    required this.principle,
    required this.balance,
    required this.isGoldProUser,
    required this.currentValue,
    required this.leased,
    required this.payouts,
  });

  factory Asset.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return Asset.base();
    return Asset(
      absGains: (map['absGain'] ?? 0.0) * 1.0,
      percGains: (map['percGain'] ?? 0.0) * 1.0,
      principle: (map["principle"] ?? 0.0) * 1.0,
      balance: (map["balance"] ?? 0.0) * 1.0,
      currentValue: map['currentValue'] ?? 0.0,
      isGoldProUser: map['isGoldProUser'] ?? false,
      leased: map['leased'] ?? 0.0,
      payouts: map['payouts'] ?? 0.0,
    );
  }
  factory Asset.base() {
    return const Asset(
      absGains: 0.0,
      percGains: 0.0,
      principle: 0.0,
      balance: 0.0,
      currentValue: 0,
      isGoldProUser: false,
      leased: 0.0,
      payouts: 0.0,
    );
  }
}
