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
  final List<VideoData> recentLive;
  final List<VideoData> shortsData;
  final int currentTab;
  const ExpertDetailsLoaded({
    required this.expertDetails,
    this.currentTab = 0,
    this.recentLive = const [],
    this.shortsData = const [],
  });
  ExpertDetailsState copyWith({
    ExpertDetails? expertDetails,
    int? currentTab,
  final List<VideoData>? recentLive,
  final List<VideoData>? shortsData,
  }) {
    return ExpertDetailsLoaded(
      expertDetails: expertDetails ?? this.expertDetails,
      currentTab: currentTab ?? this.currentTab,
      recentLive: recentLive ?? this.recentLive,
      shortsData: shortsData ?? this.shortsData,
    );
  }

  @override
  List<Object?> get props => [
        expertDetails,
        currentTab,
        recentLive,
        shortsData,
      ];
}
