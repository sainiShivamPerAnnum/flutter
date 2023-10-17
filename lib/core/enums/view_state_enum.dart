enum ViewState { Idle, Busy, Offline }

extension ViewStateFlag on ViewState {
  bool get isBusy => this == ViewState.Busy;
}
