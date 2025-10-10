import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_home.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';

part 'fixed_deposit_state.dart';
part 'fixed_deposit_event.dart';

class FixedDepositBloc extends Bloc<FixedDepositEvent, FixedDepositState> {
  final FdRepository _fdRepository;
  FixedDepositBloc(
    this._fdRepository,
  ) : super(const LoadingAllFds()) {
    on<LoadFDs>(_onLoadFdsData);
  }
  FutureOr<void> _onLoadFdsData(
    LoadFDs event,
    Emitter<FixedDepositState> emitter,
  ) async {
    emitter(const LoadingAllFds());
    try {
      final data = await _fdRepository.getAllFdsData();
      if (data.isSuccess()) {
        emitter(AllFdsLoaded(fdData: data.model ?? []));
      } else {
        emitter(FdLoadError(data.errorMessage.toString()));
      }
    } catch (e) {
      emitter(FdLoadError(e.toString()));
    }
  }
}
