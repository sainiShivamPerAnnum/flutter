import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_home.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';

part 'fixed_deposit_state.dart';
part 'fixed_deposit_event.dart';

class MyFixedDepositBloc
    extends Bloc<MyFixedDepositEvent, MyFixedDepositState> {
  final FdRepository _fdRepository;
  MyFixedDepositBloc(
    this._fdRepository,
  ) : super(const LoadingMyDeposits()) {
    on<LoadMyFDs>(_onLoadFdsData);
  }
  FutureOr<void> _onLoadFdsData(
    LoadMyFDs event,
    Emitter<MyFixedDepositState> emitter,
  ) async {
    emitter(const LoadingMyDeposits());
    try {
      final data = await _fdRepository.getAllFdsData();
      if (data.isSuccess()) {
        emitter(FdDepositsLoaded(fdData: data.model ?? []));
      } else {
        emitter(FdMyDepositsError(data.errorMessage.toString()));
      }
    } catch (e) {
      emitter(FdMyDepositsError(e.toString()));
    }
  }
}
