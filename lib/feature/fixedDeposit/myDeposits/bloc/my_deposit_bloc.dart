import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/fixedDeposit/my_fds.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';

part 'my_deposit_state.dart';
part 'my_deposit_event.dart';

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
      final data = await _fdRepository.myFds();
      if (data.isSuccess()) {
        emitter(FdDepositsLoaded(fdData: data.model!));
      } else {
        emitter(FdMyDepositsError(data.errorMessage.toString()));
      }
    } catch (e) {
      emitter(FdMyDepositsError(e.toString()));
    }
  }
}
