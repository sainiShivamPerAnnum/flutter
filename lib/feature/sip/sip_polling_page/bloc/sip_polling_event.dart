part of 'sip_polling_bloc.dart';

sealed class SipPollingEvent {
  const SipPollingEvent();
}

class StartPolling extends SipPollingEvent {
  final String subscriptionKey;
  const StartPolling(this.subscriptionKey);
}
