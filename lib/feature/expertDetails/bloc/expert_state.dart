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
  final bool isLoading;
  final ExpertDetails? expertDetails;
  final List<VideoData> recentLive;
  final List<VideoData> shortsData;
  final int currentTab;
  const ExpertDetailsLoaded({
    required this.expertDetails,
    this.isLoading = false,
    this.currentTab = 0,
    this.recentLive = const [],
    this.shortsData = const [],
  });
  ExpertDetailsState copyWith({
    ExpertDetails? expertDetails,
    int? currentTab,
    bool? isLoading,
    List<VideoData>? recentLive,
    List<VideoData>? shortsData,
  }) {
    return ExpertDetailsLoaded(
      isLoading: isLoading ?? this.isLoading,
      expertDetails: expertDetails ?? this.expertDetails,
      currentTab: currentTab ?? this.currentTab,
      recentLive: recentLive ?? this.recentLive,
      shortsData: shortsData ?? this.shortsData,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        expertDetails,
        currentTab,
        recentLive,
        shortsData,
      ];
}
