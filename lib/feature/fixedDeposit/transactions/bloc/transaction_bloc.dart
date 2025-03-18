import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/fixedDeposit/my_fds.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';

part 'transaction_state.dart';
part 'transaction_event.dart';

class TransactionBloc
    extends Bloc<FixedDepositTransactionEvent, FixedDepositTransactionState> {
  final FdRepository _fdRepository;
  TransactionBloc(
    this._fdRepository,
  ) : super(const LoadingMyDeposits()) {
    on<LoadMyFDs>(_onLoadFdsData);
  }
  FutureOr<void> _onLoadFdsData(
    LoadMyFDs event,
    Emitter<FixedDepositTransactionState> emitter,
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
