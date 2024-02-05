part of 'autosave_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class AutosaveCubitState extends AutoSaveSetupState {
  int currentPage;
  AllSubscriptionModel? activeSubscription;
  List<AutosaveState>? autosaveState;
  bool isFetchingDetails;
  int sipAmount;
  int timePeriod;
  num returnPercentage;
  int maxSipValue;
  int minSipValue;
  int maxTimePeriod;
  int minTimePeriod;
  int numberOfPeriodsPerYear;
  bool? isPauseOrResuming;
  bool? isEdit;
  num? editSipAmount;
  String? currentSipFrequency;
  AutosaveCubitState(
      {this.currentPage = 0,
      this.activeSubscription,
      this.autosaveState,
      this.isFetchingDetails = false,
      this.sipAmount = 0,
      this.timePeriod = 0,
      this.returnPercentage = 1,
      this.maxSipValue = 0,
      this.minSipValue = 0,
      this.maxTimePeriod = 0,
      this.minTimePeriod = 0,
      this.numberOfPeriodsPerYear = 12,
      this.isPauseOrResuming = false,
      this.isEdit,
      this.currentSipFrequency,
      this.editSipAmount});

  AutosaveCubitState copyWith({
    int? currentPage,
    bool? isFetchingDetails,
    AllSubscriptionModel? activeSubscription,
    List<AutosaveState>? autosaveState,
    int? sipAmount,
    int? timePeriod,
    double? returnPercentage,
    int? maxSipValue,
    int? minSipValue,
    int? maxTimePeriod,
    int? numberOfPeriodsPerYear,
    int? minTimePeriod,
    bool? isPauseOrResuming,
    bool? isEdit,
    num? editSipAmount,
    String? currentSipFrequency,
  }) {
    return AutosaveCubitState(
        currentPage: currentPage ?? this.currentPage,
        activeSubscription: activeSubscription ?? this.activeSubscription,
        autosaveState: autosaveState ?? this.autosaveState,
        isFetchingDetails: isFetchingDetails ?? this.isFetchingDetails,
        sipAmount: sipAmount ?? this.sipAmount,
        timePeriod: timePeriod ?? this.timePeriod,
        returnPercentage: returnPercentage ?? this.returnPercentage,
        maxSipValue: maxSipValue ?? this.maxSipValue,
        minSipValue: minSipValue ?? this.minSipValue,
        maxTimePeriod: maxTimePeriod ?? this.maxTimePeriod,
        minTimePeriod: minTimePeriod ?? this.minTimePeriod,
        isPauseOrResuming: isPauseOrResuming ?? this.isPauseOrResuming,
        isEdit: isEdit ?? this.isEdit,
        currentSipFrequency: currentSipFrequency ?? this.currentSipFrequency,
        editSipAmount: editSipAmount ?? this.editSipAmount,
        numberOfPeriodsPerYear:
            numberOfPeriodsPerYear ?? this.numberOfPeriodsPerYear);
  }
}

final class SipAssetSelect extends AutoSaveSetupState {
  int? selectedAsset;
  SipAssetSelect({
    this.selectedAsset = -1,
  });
  SipAssetSelect copyWith({int? selectedAsset}) {
    return SipAssetSelect(selectedAsset: selectedAsset ?? this.selectedAsset);
  }
}
