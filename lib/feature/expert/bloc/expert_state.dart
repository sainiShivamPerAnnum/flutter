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
  final List<Expert> searchResults;
  final String query;
  const ExpertHomeLoaded({
    required this.expertsHome,
    this.currentSection = '',
    this.searchResults = const [],
    this.query = '',
  });
  ExpertState copyWith({
    ExpertsHome? expertsHome,
    String? currentSection,
    List<Expert>? searchResults,
    String? query,
  }) {
    return ExpertHomeLoaded(
      expertsHome: expertsHome ?? this.expertsHome,
      currentSection: currentSection ?? this.currentSection,
      searchResults: searchResults ?? this.searchResults,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
        expertsHome,
        currentSection,
        searchResults,
        query,
      ];
}

class LoadingExpertsFailed extends ExpertState {
  const LoadingExpertsFailed({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}
