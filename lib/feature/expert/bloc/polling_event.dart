part of 'polling_bloc.dart';

sealed class PollingEvent {
  const PollingEvent();
}

class StartPolling extends PollingEvent {
  final String paymentId;
  const StartPolling(this.paymentId);
}