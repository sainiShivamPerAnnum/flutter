import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_home.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';

part 'deposit_details_state.dart';
part 'deposit_details_event.dart';

class FixedDepositDetailsBloc
    extends Bloc<FixedDepositDetailsEvent, FixedDepositDetailsState> {
  final FdRepository _fdRepository;
  FixedDepositDetailsBloc(
    this._fdRepository,
  ) : super(const LoadingMyDeposits()) {
    on<LoadMyFDs>(_onLoadFdsData);
  }
  FutureOr<void> _onLoadFdsData(
    LoadMyFDs event,
    Emitter<FixedDepositDetailsState> emitter,
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
