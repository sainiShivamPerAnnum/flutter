part of 'autosave_cubit.dart';

sealed class SipState extends Equatable {
  const SipState();
}

class LoadingSipData extends SipState {
  const LoadingSipData();

  @override
  List<Object?> get props => const [];
}

class ErrorSipState extends SipState {
  const ErrorSipState();

  @override
  List<Object?> get props => const [];
}

class LoadedSipData extends SipState {
  const LoadedSipData({
    required this.activeSubscription,
    required this.sipScreenData,
    this.isPauseOrResuming = false,
    this.showAllSip = false,
  });
  final Subscriptions activeSubscription;
  final SipData sipScreenData;
  final bool isPauseOrResuming;
  final bool showAllSip;

  LoadedSipData copyWith({
    SipData? sipScreenData,
    Subscriptions? activeSubscription,
    bool? isPauseOrResuming,
    bool? showAllSip,
  }) {
    return LoadedSipData(
      activeSubscription: activeSubscription ?? this.activeSubscription,
      isPauseOrResuming: isPauseOrResuming ?? this.isPauseOrResuming,
      sipScreenData: sipScreenData ?? this.sipScreenData,
      showAllSip: showAllSip ?? this.showAllSip,
    );
  }

  @override
  List<Object?> get props =>
      [activeSubscription, sipScreenData, isPauseOrResuming, showAllSip];
}
