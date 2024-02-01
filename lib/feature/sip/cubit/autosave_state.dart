part of 'autosave_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class AutosaveCubitState extends AutoSaveSetupState {
  int currentPage;
  AllSubscriptionModel? activeSubscription;
  bool isFetchingTransactions;
  int sipAmount;
  int timePeriod;
  num returnPercentage;
  int maxSipValue;
  int minSipValue;
  int maxTimePeriod;
  int minTimePeriod;
  int? numberOfPeriodsPerYear;
  AutosaveCubitState({
    this.currentPage = 0,
    this.activeSubscription,
    this.isFetchingTransactions = false,
    this.sipAmount = 0,
    this.timePeriod = 0,
    this.returnPercentage = 0,
    this.maxSipValue = 0,
    this.minSipValue = 0,
    this.maxTimePeriod = 0,
    this.minTimePeriod = 0,
    this.numberOfPeriodsPerYear,
  });

  AutosaveCubitState copyWith(
      {int? sipAmount,
      int? timePeriod,
      double? returnPercentage,
      int? maxSipValue,
      int? minSipValue,
      int? maxTimePeriod,
      int? numberOfPeriodsPerYear,
      int? minTimePeriod}) {
    return AutosaveCubitState(
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
