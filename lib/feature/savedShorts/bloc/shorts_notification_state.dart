part of 'shorts_notification_bloc.dart';

sealed class SavedShortsState extends Equatable {
  const SavedShortsState();
}

class LoadingSavedShortsDetails extends SavedShortsState {
  const LoadingSavedShortsDetails();

  @override
  List<Object?> get props => const [];
}

final class SavedShortsData extends SavedShortsState {
  final List<SavedShorts> shortsHome;

  const SavedShortsData({
    required this.shortsHome,
  });
  SavedShortsState copyWith({
    List<SavedShorts>? shortsHome,
  }) {
    return SavedShortsData(
      shortsHome: shortsHome ?? this.shortsHome,
    );
  }

  @override
  List<Object?> get props => [
        shortsHome,
      ];
}

class LoadingSavedShortsFailed extends SavedShortsState {
  const LoadingSavedShortsFailed({required this.errorMessage});
  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}
