import 'package:json_annotation/json_annotation.dart';

part 'portfolio_model.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class Portfolio {
  final AugmontTiers augmont;
  final FloTiers flo;
  final double rewards;
  final double lifeTimeRewards;
  final Asset absolute;

  const Portfolio({
    this.augmont = const AugmontTiers(),
    this.flo = const FloTiers(),
    this.lifeTimeRewards = 0.0,
    this.rewards = 0.0,
    this.absolute = const Asset(),
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) =>
      _$PortfolioFromJson(json);
}

@_deserializable
class AugmontTiers {
  final double absGains;
  final double percGains;
  final double principle;
  final double balance;

  final Asset gold;
  final Asset fd;

  const AugmontTiers({
    this.absGains = 0.0,
    this.percGains = 0.0,
    this.principle = 0.0,
    this.balance = 0.0,
    this.gold = const Asset(),
    this.fd = const Asset(),
  });

  factory AugmontTiers.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return const AugmontTiers();
    return _$AugmontTiersFromJson(json);
  }
}

@_deserializable
class FloTiers {
  final num absGain;
  final num percGain;
  final num principle;
  final num balance;
  final Map<String, Asset> assetInfo;

  final Asset flexi;
  final Asset fixed1;
  final Asset fixed2;

  const FloTiers({
    this.absGain = 0.0,
    this.percGain = 0.0,
    this.principle = 0.0,
    this.balance = 0.0,
    this.flexi = const Asset(),
    this.fixed1 = const Asset(),
    this.fixed2 = const Asset(),
    this.assetInfo = const {},
  });

  factory FloTiers.fromJson(Map<String, dynamic> json) =>
      _$FloTiersFromJson(json);
}

@_deserializable
class Asset {
  final num absGains;
  final num percGains;
  final num principle;
  final num balance; // gold balance in rupees.
  final num currentValue; // total gold quantity with principle and interest.
  final num leased; // total leased amount in quantity.
  final num payouts; // interest gain in quantity.
  final bool isGoldProUser;

  const Asset({
    this.absGains = 0.0,
    this.percGains = 0.0,
    this.principle = 0.0,
    this.balance = 0.0,
    this.currentValue = 0.0,
    this.leased = 0.0,
    this.payouts = 0.0,
    this.isGoldProUser = false,
  });

  factory Asset.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return const Asset();
    return _$AssetFromJson(json);
  }
}
