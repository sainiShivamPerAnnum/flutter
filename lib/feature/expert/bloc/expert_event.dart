part of 'expert_bloc.dart';

sealed class ExpertEvent {
  const ExpertEvent();
}

class LoadExpertsData extends ExpertEvent {
  const LoadExpertsData();
}

class SectionChanged extends ExpertEvent {
  final String newSection;

  const SectionChanged(this.newSection);
}
