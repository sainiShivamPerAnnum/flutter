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

class CompletedPollingWithSuccess extends PollingState {
  const CompletedPollingWithSuccess(this.response);
  final PollingStatusResponse response;

  @override
  List<Object?> get props => [response];
}

class CompletedPollingWithPending extends PollingState {
  const CompletedPollingWithPending(this.response);
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
