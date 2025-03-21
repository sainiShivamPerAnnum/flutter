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
  final String query;
  const ShortsHomeData({
    required this.shortsHome,
    required this.query,
  });
  ShortsHomeState copyWith({
    ShortsHome? shortsHome,
    String? query,
  }) {
    return ShortsHomeData(
      shortsHome: shortsHome ?? this.shortsHome,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [
        shortsHome,
        query,
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
