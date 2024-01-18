part of 'sip_cubit.dart';

final class SipState extends Equatable {
  bool autosaveVisible;
  AutosaveState autosaveState;
  SubscriptionModel? subscriptionData;
  bool isPauseOrResuming;
  SipState({
    this.autosaveVisible = true,
    this.autosaveState = AutosaveState.IDLE,
    this.subscriptionData,
    this.isPauseOrResuming = false,
  });

  SipState copyWith({required bool visible}) {
    return SipState(autosaveVisible: visible);
  }

  @override
  List<Object> get props => [autosaveVisible, autosaveState, isPauseOrResuming];
}
