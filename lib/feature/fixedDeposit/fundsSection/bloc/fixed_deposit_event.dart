part of 'fixed_deposit_bloc.dart';

sealed class FixedDepositEvent {
  const FixedDepositEvent();
}

class LoadFDs extends FixedDepositEvent {
  const LoadFDs();
}
