part of 'rewards_history_bloc.dart';

sealed class RewardsHistoryState extends Equatable {
  const RewardsHistoryState();
}

class LoadingHistoryData extends RewardsHistoryState {
  const LoadingHistoryData();

  @override
  List<Object?> get props => const [];
}

class HistoryLoadError extends RewardsHistoryState {
  const HistoryLoadError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class RewardsHistory extends RewardsHistoryState {
  const RewardsHistory({
    required this.history,
  });
  final List<RewardsHistoryModel> history;

  @override
  List<Object?> get props => [
        history,
      ];
}
