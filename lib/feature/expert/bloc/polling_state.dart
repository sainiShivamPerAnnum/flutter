part of 'polling_bloc.dart';

sealed class PollingState extends Equatable {
  const PollingState();
}

class InitialPollingState extends PollingState {
  const InitialPollingState();
  @override
  List<Object?> get props => const [];
}

class Polling extends PollingState {
  const Polling();

  @override
  List<Object?> get props => const [];
}

class CompletedPollingWithSuccessOrPending extends PollingState {
  const CompletedPollingWithSuccessOrPending(this.response);
  final PollingStatusResponse response;

  @override
  List<Object?> get props => [response];
}

class CompletedPollingWithFailure extends PollingState {
  const CompletedPollingWithFailure(this.message);
  final String message;

  @override
  List<Object?> get props => const [];
}
