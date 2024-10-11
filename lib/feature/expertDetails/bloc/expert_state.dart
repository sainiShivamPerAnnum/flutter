part of 'expert_bloc.dart';

sealed class ExpertDetailsState extends Equatable {
  const ExpertDetailsState();
}

class LoadingExpertsDetails extends ExpertDetailsState {
  const LoadingExpertsDetails();

  @override
  List<Object?> get props => const [];
}

final class ExpertDetailsLoaded extends ExpertDetailsState {
  final ExpertDetails? expertDetails;
  const ExpertDetailsLoaded({
    required this.expertDetails,
  });
  ExpertDetailsState copyWith({
    ExpertDetails? expertDetails,
    String? currentSection,
  }) {
    return ExpertDetailsLoaded(
      expertDetails: expertDetails ?? expertDetails,
    );
  }

  @override
  List<Object?> get props => [
        expertDetails,
      ];
}
