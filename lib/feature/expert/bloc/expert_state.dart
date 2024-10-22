part of 'expert_bloc.dart';

sealed class ExpertState extends Equatable {
  const ExpertState();
}

class LoadingExpertsData extends ExpertState {
  const LoadingExpertsData();

  @override
  List<Object?> get props => const [];
}

final class ExpertHomeLoaded extends ExpertState {
  final ExpertsHome? expertsHome;
  final String currentSection;
  const ExpertHomeLoaded({
    required this.expertsHome,
    this.currentSection = 'Personal Finance',
  });
  ExpertState copyWith({
    ExpertsHome? expertsHome,
    String? currentSection,
  }) {
    return ExpertHomeLoaded(
      expertsHome: expertsHome ?? this.expertsHome,
      currentSection: currentSection ?? this.currentSection,
    );
  }

  @override
  List<Object?> get props => [
        expertsHome,
        currentSection,
      ];
}
