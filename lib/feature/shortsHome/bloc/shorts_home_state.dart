part of 'shorts_home_bloc.dart';

sealed class ShortsHomeState extends Equatable {
  const ShortsHomeState();
}

class LoadingShortsDetails extends ShortsHomeState {
  const LoadingShortsDetails();

  @override
  List<Object?> get props => const [];
}

final class ShortsHomeData extends ShortsHomeState {
  final ShortsHome shortsHome;
  const ShortsHomeData({
    required this.shortsHome,
  });
  ShortsHomeState copyWith({
    ShortsHome? shortsHome,
  }) {
    return ShortsHomeData(
      shortsHome: shortsHome ?? this.shortsHome,
    );
  }

  @override
  List<Object?> get props => [
        shortsHome,
      ];
}

class LoadingShortsFailed extends ShortsHomeState {
  const LoadingShortsFailed({required this.errorMessage});
  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}
