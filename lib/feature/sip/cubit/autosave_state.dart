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
  AutosaveCubitState({
    this.currentPage = 0,
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
  });

  AutosaveCubitState copyWith(
      {bool? isFetchingDetails,
      int? sipAmount,
      int? timePeriod,
      double? returnPercentage,
      int? maxSipValue,
      int? minSipValue,
      int? maxTimePeriod,
      int? numberOfPeriodsPerYear,
      int? minTimePeriod}) {
    return AutosaveCubitState(
        isFetchingDetails: isFetchingDetails ?? this.isFetchingDetails,
        sipAmount: sipAmount ?? this.sipAmount,
        timePeriod: timePeriod ?? this.timePeriod,
        returnPercentage: returnPercentage ?? this.returnPercentage,
        maxSipValue: maxSipValue ?? this.maxSipValue,
        minSipValue: minSipValue ?? this.minSipValue,
        maxTimePeriod: maxTimePeriod ?? this.maxTimePeriod,
        minTimePeriod: minTimePeriod ?? this.minTimePeriod,
        numberOfPeriodsPerYear:
            numberOfPeriodsPerYear ?? this.numberOfPeriodsPerYear);
  }
}

final class SipAssetSelect extends AutoSaveSetupState {
  int? selectedAsset;
  SipAssetSelect({
    this.selectedAsset,
  });
  SipAssetSelect copyWith({int? selectedAsset}) {
    return SipAssetSelect(selectedAsset: selectedAsset ?? this.selectedAsset);
  }
}
