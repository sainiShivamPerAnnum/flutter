import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_transaction.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';
import 'package:felloapp/feature/fixedDeposit/myDeposits/bloc/my_deposit_bloc.dart';

part 'transaction_state.dart';
part 'transaction_event.dart';

class FdTransactionBloc
    extends Bloc<FixedDepositTransactionEvent, FixedDepositTransactionState> {
  final FdRepository _fdRepository;
  FdTransactionBloc(
    this._fdRepository,
  ) : super(const LoadingMyDeposits()) {
    on<LoadMyFDTransactions>(_onLoadFdsData);
    on<SwitchFilter>(_switchFilter);
  }
  FutureOr<void> _onLoadFdsData(
    LoadMyFDTransactions event,
    Emitter<FixedDepositTransactionState> emitter,
  ) async {
    emitter(const LoadingMyDeposits());
    try {
      final data = await _fdRepository.fdTransactions();
      if (data.isSuccess()) {
        if (data.model is String) {
          throw NoFixedDepositFoundException('No fixed deposits found');
        } else if (data.model != null) {
          final deposits = data.model!;
          final activeDeposits =
              deposits.where((d) => d.status != 'MATURED').toList();
          final maturedDeposits =
              deposits.where((d) => d.status == 'MATURED').toList();
          emitter(
            FdDepositsLoaded(
              activeDeposits: activeDeposits,
              maturedDeposits: maturedDeposits,
              currentFilter: 'ACTIVE',
            ),
          );
        }
      } else {
        emitter(FdMyDepositsError(data.errorMessage.toString()));
      }
    } on NoFixedDepositFoundException catch (e) {
      emitter(NoFixedDepositsState(e.message));
    } catch (e) {
      emitter(FdMyDepositsError(e.toString()));
    }
  }

  FutureOr<void> _switchFilter(
    SwitchFilter event,
    Emitter<FixedDepositTransactionState> emitter,
  ) async {
    try {
      final currentState = state as FdDepositsLoaded;
      emitter(
        currentState.copyWith(
          currentFilter: event.filter,
        ),
      );
    } catch (e) {
      emitter(FdMyDepositsError(e.toString()));
    }
  }
}
