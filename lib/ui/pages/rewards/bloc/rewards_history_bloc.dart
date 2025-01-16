import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/rewards_history.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';

part 'rewards_history_event.dart';
part 'rewards_history_state.dart';

class RewardsHistoryBloc
    extends Bloc<RewardsHistoryEvent, RewardsHistoryState> {
  final ScratchCardRepository _gtRepo;
  RewardsHistoryBloc(this._gtRepo) : super(const LoadingHistoryData()) {
    on<GetData>(_loadData);
  }

  Future<void> _loadData(
    GetData event,
    Emitter<RewardsHistoryState> emitter,
  ) async {
    final response = await _gtRepo.getRewardsHistory();
    if (response.isSuccess()) {
      emitter(
        RewardsHistory(history: response.model!),
      );
    } else {
      BaseUtil.showNegativeAlert(
        'Failed to fetch rewards history',
        'Please try again later.',
      );
    }
  }
}
