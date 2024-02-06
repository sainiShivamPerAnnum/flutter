part of 'sip_polling_bloc.dart';

sealed class SipPollingState extends Equatable {
  const SipPollingState();
}

class InitialPollingState extends SipPollingState {
  const InitialPollingState();
  @override
  List<Object?> get props => const [];
}

class Polling extends SipPollingState {
  const Polling();

  @override
  List<Object?> get props => const [];
}

class CompletedPollingWithSuccessOrPending extends SipPollingState {
  const CompletedPollingWithSuccessOrPending(this.response);
  final SubscriptionStatusData response;

  @override
  List<Object?> get props => [response];
}

class CompletedPollingWithFailure extends SipPollingState {
  const CompletedPollingWithFailure(this.message);
  final String message;

  @override
  List<Object?> get props => const [];
}
