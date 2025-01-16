part of 'advisor_bloc.dart';

sealed class AdvisorEvent{
  const AdvisorEvent();
}

class LoadAdvisorData extends AdvisorEvent {
  const LoadAdvisorData();
}
