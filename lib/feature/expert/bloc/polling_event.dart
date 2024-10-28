part of 'polling_bloc.dart';

sealed class PollingEvent {
  const PollingEvent();
}

class StartPolling extends PollingEvent {
  final String paymentId;
  final String fromTime;
  final String advisorName;
  const StartPolling(this.paymentId, this.fromTime, this.advisorName);
}