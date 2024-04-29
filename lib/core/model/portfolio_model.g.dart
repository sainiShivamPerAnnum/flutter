// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Portfolio _$PortfolioFromJson(Map<String, dynamic> json) => Portfolio(
      augmont: json['augmont'] == null
          ? const AugmontTiers()
          : AugmontTiers.fromJson(json['augmont'] as Map<String, dynamic>?),
      flo: json['flo'] == null
          ? const FloTiers()
          : FloTiers.fromJson(json['flo'] as Map<String, dynamic>),
      lifeTimeRewards: (json['lifeTimeRewards'] as num?)?.toDouble() ?? 0.0,
      rewards: (json['rewards'] as num?)?.toDouble() ?? 0.0,
      absolute: json['absolute'] == null
          ? const Asset()
          : Asset.fromJson(json['absolute'] as Map<String, dynamic>?),
    );

AugmontTiers _$AugmontTiersFromJson(Map<String, dynamic> json) => AugmontTiers(
      absGains: (json['absGains'] as num?)?.toDouble() ?? 0.0,
      percGains: (json['percGains'] as num?)?.toDouble() ?? 0.0,
      principle: (json['principle'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      gold: json['gold'] == null
          ? const Asset()
          : Asset.fromJson(json['gold'] as Map<String, dynamic>?),
      fd: json['fd'] == null
          ? const Asset()
          : Asset.fromJson(json['fd'] as Map<String, dynamic>?),
    );

FloTiers _$FloTiersFromJson(Map<String, dynamic> json) => FloTiers(
      absGain: json['absGain'] as num? ?? 0.0,
      percGain: json['percGain'] as num? ?? 0.0,
      principle: json['principle'] as num? ?? 0.0,
      balance: json['balance'] as num? ?? 0.0,
      flexi: json['flexi'] == null
          ? const Asset()
          : Asset.fromJson(json['flexi'] as Map<String, dynamic>?),
      assetInfo: (json['assetInfo'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Asset.fromJson(e as Map<String, dynamic>?)),
          ) ??
          const {},
    );

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      absGains: json['absGains'] as num? ?? 0.0,
      percGains: json['percGains'] as num? ?? 0.0,
      principle: json['principle'] as num? ?? 0.0,
      balance: json['balance'] as num? ?? 0.0,
      currentValue: json['currentValue'] as num? ?? 0.0,
      leased: json['leased'] as num? ?? 0.0,
      payouts: json['payouts'] as num? ?? 0.0,
      isGoldProUser: json['isGoldProUser'] as bool? ?? false,
    );
