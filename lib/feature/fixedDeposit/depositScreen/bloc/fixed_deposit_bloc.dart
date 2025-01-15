import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_deposit.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';

part 'fixed_deposit_state.dart';
part 'fixed_deposit_event.dart';

class FDCalculatorBloc
    extends Bloc<FDCalculatorEvents, FixedDepositCalculatorState> {
  final FdRepository _fdRepository;
  FDCalculatorBloc(
    this._fdRepository,
  ) : super(const LoadingFdCalculator()) {
    on<LoadFDCalculator>(_onLoadFdsData);
  }
  FutureOr<void> _onLoadFdsData(
    LoadFDCalculator event,
    Emitter<FixedDepositCalculatorState> emitter,
  ) async {
    emitter(const LoadingFdCalculator());
    try {
      final data = await _fdRepository.individualFdData();
      if (data.isSuccess()) {
        emitter(FdCalculatorLoaded(fdCalculatorData: data.model!));
      } else {
        emitter(FCalculatorError(data.errorMessage.toString()));
      }
    } catch (e) {
      emitter(FCalculatorError(e.toString()));
    }
  }
}
