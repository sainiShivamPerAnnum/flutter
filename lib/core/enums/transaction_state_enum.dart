enum TransactionState {
  idle,
  overView,
  ongoing,
  success;

  bool get isGoingOn => this == TransactionState.ongoing;
}
