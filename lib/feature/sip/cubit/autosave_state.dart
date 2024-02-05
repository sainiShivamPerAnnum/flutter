part of 'autosave_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class AutosaveCubitState extends AutoSaveSetupState {
  final AllSubscriptionModel? activeSubscription;
  final SipData? sipScreenData;
  final bool isFetchingDetails;
  final bool? isPauseOrResuming;
  // bool? isEdit;
  // num? editSipAmount;
  // String? currentSipFrequency;
  // int? selectedAsset;
  // int? editIndex;
  final List<ApplicationMeta> upiApps;
  AutosaveCubitState({
    this.activeSubscription,
    this.sipScreenData,
    this.isFetchingDetails = false,
    this.isPauseOrResuming = false,
    // this.isEdit = false,
    // this.currentSipFrequency,
    // this.selectedAsset = -1,
    // this.editSipAmount,
    // this.editIndex,
    this.upiApps = const [],
  });

  AutosaveCubitState copyWith({
    List<ApplicationMeta>? upiApps,
    bool? isFetchingDetails,
    SipData? sipScreenData,
    AllSubscriptionModel? activeSubscription,
    bool? isPauseOrResuming,
  }) {
    return AutosaveCubitState(
      activeSubscription: activeSubscription ?? this.activeSubscription,
      isFetchingDetails: isFetchingDetails ?? this.isFetchingDetails,
      isPauseOrResuming: isPauseOrResuming ?? this.isPauseOrResuming,
      sipScreenData: sipScreenData ?? this.sipScreenData,
      // isEdit: isEdit ?? this.isEdit,
      // currentSipFrequency: currentSipFrequency ?? this.currentSipFrequency,
      // editSipAmount: editSipAmount ?? this.editSipAmount,
      // selectedAsset: selectedAsset ?? this.selectedAsset,
      // editIndex: editIndex ?? this.editIndex,
      // numberOfPeriodsPerYear:
      //     numberOfPeriodsPerYear ?? this.numberOfPeriodsPerYear,
      upiApps: upiApps ?? this.upiApps,
    );
  }
}
