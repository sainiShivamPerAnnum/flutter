part of 'rps_bloc.dart';

sealed class RPSEvent {
  const RPSEvent();
}

class LoadRpsDetails extends RPSEvent {
  const LoadRpsDetails();
}
