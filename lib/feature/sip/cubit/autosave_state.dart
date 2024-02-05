part of 'autosave_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class AutosaveCubitState extends AutoSaveSetupState {
  int currentPage;
  AllSubscriptionModel? activeSubscription;
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
  int? selectedAsset;
  int? editIndex;
  final List<ApplicationMeta> upiApps;

  AutosaveCubitState({
    this.currentPage = 0,
    this.activeSubscription,
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
    this.isEdit = false,
    this.currentSipFrequency,
    this.selectedAsset = -1,
    this.editSipAmount,
    this.editIndex,
    this.upiApps = const [],
  });

  AutosaveCubitState copyWith({
    List<ApplicationMeta>? upiApps,
    int? currentPage,
    bool? isFetchingDetails,
    AllSubscriptionModel? activeSubscription,
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
    int? selectedAsset,
    int? editIndex,
  }) {
    return AutosaveCubitState(
      currentPage: currentPage ?? this.currentPage,
      activeSubscription: activeSubscription ?? this.activeSubscription,
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
      selectedAsset: selectedAsset ?? this.selectedAsset,
      editIndex: editIndex ?? this.editIndex,
      numberOfPeriodsPerYear:
          numberOfPeriodsPerYear ?? this.numberOfPeriodsPerYear,
      upiApps: upiApps ?? this.upiApps,
    );
  }

  AutosaveCubitState getDefault() {
    return AutosaveCubitState(
      currentPage: currentPage,
      activeSubscription: activeSubscription,
      isFetchingDetails: isFetchingDetails,
      sipAmount: sipAmount,
      timePeriod: timePeriod,
      returnPercentage: returnPercentage,
      maxSipValue: maxSipValue,
      minSipValue: minSipValue,
      maxTimePeriod: maxTimePeriod,
      minTimePeriod: minTimePeriod,
      isPauseOrResuming: isPauseOrResuming,
      numberOfPeriodsPerYear: numberOfPeriodsPerYear,
      isEdit: false,
      currentSipFrequency: null,
      editSipAmount: null,
      selectedAsset: -1,
      editIndex: -1,
    );
  }
}
