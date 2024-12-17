import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/rps_model.dart';
import 'package:felloapp/core/repository/rps_repo.dart';
part 'rps_event.dart';
part 'rps_state.dart';

class RpsDetailsBloc extends Bloc<RPSEvent, RPSState> {
  final RpsRepository _rpsRepository;
  RpsDetailsBloc(
    this._rpsRepository,
  ) : super(const LoadingRPSDetails()) {
    on<LoadRpsDetails>(_onLoadRpsData);
  }
  FutureOr<void> _onLoadRpsData(
    LoadRpsDetails event,
    Emitter<RPSState> emitter,
  ) async {
    emitter(const LoadingRPSDetails());
    final fixedData = await _rpsRepository.getRpsData(
      'fixed',
    );
    final flexiData = await _rpsRepository.getRpsData(
      'flexi',
    );
    emitter(
      RPSDataState(fixedData: fixedData.model!, flexiData: flexiData.model),
    );
  }
}
