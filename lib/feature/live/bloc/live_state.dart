part of 'live_bloc.dart';

sealed class LiveState extends Equatable {
  const LiveState();
}

class LoadingHomeData extends LiveState {
  const LoadingHomeData();

  @override
  List<Object?> get props => const [];
}

final class LiveHomeData extends LiveState {
  final LiveHome? homeData;
  final Map<String, bool> notificationStatus;

  const LiveHomeData({
    required this.homeData,
    this.notificationStatus = const {},
  });

  @override
  List<Object?> get props => [
        homeData,
        notificationStatus,
      ];
  
  LiveHomeData copyWith({
    LiveHome? homeData,
    Map<String, bool>? notificationStatus,
  }) {
    return LiveHomeData(
      homeData: homeData ?? this.homeData,
      notificationStatus: notificationStatus ?? this.notificationStatus,
    );
  }
}
