part of 'autosave_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class AutosaveCubitState extends AutoSaveSetupState {
  final Subscriptions? activeSubscription;
  final SipData? sipScreenData;
  final bool isFetchingDetails;
  final bool? isPauseOrResuming;
  final List<ApplicationMeta> upiApps;
  AutosaveCubitState({
    this.activeSubscription,
    this.sipScreenData,
    this.isFetchingDetails = false,
    this.isPauseOrResuming = false,
    this.upiApps = const [],
  });

  AutosaveCubitState copyWith({
    List<ApplicationMeta>? upiApps,
    bool? isFetchingDetails,
    SipData? sipScreenData,
    Subscriptions? activeSubscription,
    bool? isPauseOrResuming,
  }) {
    return AutosaveCubitState(
      activeSubscription: activeSubscription ?? this.activeSubscription,
      isFetchingDetails: isFetchingDetails ?? this.isFetchingDetails,
      isPauseOrResuming: isPauseOrResuming ?? this.isPauseOrResuming,
      sipScreenData: sipScreenData ?? this.sipScreenData,
      upiApps: upiApps ?? this.upiApps,
    );
  }
}
