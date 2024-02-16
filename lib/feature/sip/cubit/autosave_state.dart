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
    this.calculatorAmount = 0,
    this.calculatorTP = 0,
    this.currentTab = 0,
    this.calculatorRoi = 0,
  });
  final Subscriptions activeSubscription;
  final SipData sipScreenData;
  final bool isPauseOrResuming;
  final bool showAllSip;
  final int calculatorAmount;
  final int calculatorTP;
  final int calculatorRoi;
  final int currentTab;

  LoadedSipData copyWith({
    SipData? sipScreenData,
    Subscriptions? activeSubscription,
    bool? isPauseOrResuming,
    bool? showAllSip,
    int? calculatorAmount,
    int? calculatorTP,
    int? currentTab,
    int? calculatorRoi,
  }) {
    return LoadedSipData(
      activeSubscription: activeSubscription ?? this.activeSubscription,
      isPauseOrResuming: isPauseOrResuming ?? this.isPauseOrResuming,
      sipScreenData: sipScreenData ?? this.sipScreenData,
      showAllSip: showAllSip ?? this.showAllSip,
      calculatorAmount: calculatorAmount ?? this.calculatorAmount,
      calculatorTP: calculatorTP ?? this.calculatorTP,
      currentTab: currentTab ?? this.currentTab,
      calculatorRoi: calculatorRoi ?? this.calculatorRoi,
    );
  }

  @override
  List<Object?> get props => [
        activeSubscription,
        sipScreenData,
        isPauseOrResuming,
        showAllSip,
        calculatorAmount,
        calculatorTP,
        calculatorRoi,
        currentTab,
      ];
}
