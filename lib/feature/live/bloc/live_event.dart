part of 'live_bloc.dart';

sealed class LiveEvent{
  const LiveEvent();
}

class LoadHomeData extends LiveEvent {
  const LoadHomeData();
}
