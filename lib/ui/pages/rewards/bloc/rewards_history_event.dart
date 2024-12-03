part of 'rewards_history_bloc.dart';

sealed class RewardsHistoryEvent {
  const RewardsHistoryEvent();
}

class GetData extends RewardsHistoryEvent {
  const GetData();
}
