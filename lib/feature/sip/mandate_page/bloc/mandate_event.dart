part of "mandate_bloc.dart";

sealed class MandateEvent {
  const MandateEvent();
}

class LoadPSPApps extends MandateEvent {
  const LoadPSPApps();
}

class CrateSubscription extends MandateEvent {
  final ApplicationMeta meta;
  final num amount;
  final num lbAmt;
  final num augAmt;
  final String freq;
  final String assetType;

  const CrateSubscription({
    required this.meta,
    required this.freq,
    required this.assetType,
    this.amount = 0,
    this.lbAmt = 0,
    this.augAmt = 0,
  });
}
