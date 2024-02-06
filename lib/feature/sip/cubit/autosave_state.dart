part of 'autosave_cubit.dart';

sealed class SipState extends Equatable {
  const SipState();

  @override
  List<Object?> get props => const [];
}

class LoadingSipData extends SipState {
  const LoadingSipData();

  @override
  List<Object?> get props => const [];
}

class LoadedSipData extends SipState {
  const LoadedSipData({
    required this.activeSubscription,
    required this.sipScreenData,
    this.isPauseOrResuming = false,
  });
  final Subscriptions activeSubscription;
  final SipData sipScreenData;
  final bool isPauseOrResuming;

  LoadedSipData copyWith({
    SipData? sipScreenData,
    Subscriptions? activeSubscription,
    bool? isPauseOrResuming,
  }) {
    return LoadedSipData(
      activeSubscription: activeSubscription ?? this.activeSubscription,
      isPauseOrResuming: isPauseOrResuming ?? this.isPauseOrResuming,
      sipScreenData: sipScreenData ?? this.sipScreenData,
    );
  }

  @override
  List<Object?> get props =>
      [activeSubscription, sipScreenData, isPauseOrResuming];
}
