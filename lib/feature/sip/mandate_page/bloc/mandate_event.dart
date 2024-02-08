part of "mandate_bloc.dart";

sealed class MandateEvent {
  const MandateEvent();
}

class LoadPSPApps extends MandateEvent {
  const LoadPSPApps();
}

class CreateSubscription extends MandateEvent {
  final ApplicationMeta meta;
  final num amount;
  final num lbAmt;
  final num augAmt;
  final String freq;
  final String assetType;

  factory CreateSubscription.fromAssetType(
    SIPAssetTypes type, {
    required ApplicationMeta meta,
    required String freq,
    required String assetType,
    required int value,
  }) {
    return type.isAugGold
        ? CreateSubscription.aug(
            meta: meta,
            freq: freq,
            assetType: assetType,
            value: value,
          )
        : CreateSubscription.lb(
            meta: meta,
            freq: freq,
            assetType: assetType,
            value: value,
          );
  }

  const CreateSubscription.lb({
    required this.meta,
    required this.freq,
    required this.assetType,
    required int value,
  })  : amount = value,
        lbAmt = value,
        augAmt = 0;

  const CreateSubscription.aug(
      {required this.meta,
      required this.freq,
      required this.assetType,
      required int value})
      : amount = value,
        lbAmt = 0,
        augAmt = value;
}
