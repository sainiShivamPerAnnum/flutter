part of 'expert_bloc.dart';

sealed class ExpertDetailsEvent {
  const ExpertDetailsEvent();
}

class LoadExpertsDetails extends ExpertDetailsEvent {
  final String advisorId;
  const LoadExpertsDetails(this.advisorId);
}
