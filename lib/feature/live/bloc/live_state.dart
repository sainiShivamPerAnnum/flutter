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
  const LiveHomeData({
    required this.homeData,
  });
  @override
  List<Object?> get props => [
        homeData,
      ];
}
