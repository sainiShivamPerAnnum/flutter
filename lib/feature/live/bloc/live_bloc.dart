import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/core/repository/live_repository.dart';

part 'live_event.dart';
part 'live_state.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  final LiveRepository _liveRepository;
  LiveBloc(
    this._liveRepository,
  ) : super(const LoadingHomeData()) {
    on<LoadHomeData>(_onLoadHomeData);
  }
  FutureOr<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<LiveState> emitter,
  ) async {
    emitter(const LoadingHomeData());
    final data = await _liveRepository.getLiveHomeData();
    emitter(LiveHomeData(homeData: data.model));
  }
}
