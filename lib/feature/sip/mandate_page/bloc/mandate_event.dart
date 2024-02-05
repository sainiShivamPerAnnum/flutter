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

  const CrateSubscription.lb({
    required this.meta,
    required num value,
    required this.freq,
  })  : amount = value,
        lbAmt = value,
        augAmt = 0;

  const CrateSubscription.aug({
    required this.meta,
    required num value,
    required this.freq,
  })  : amount = value,
        lbAmt = 0,
        augAmt = value;
}
