part of 'fixed_deposit_bloc.dart';

sealed class FixedDepositDetailsEvent {
  const FixedDepositDetailsEvent();
}

class LoadMyFDs extends FixedDepositDetailsEvent {
  const LoadMyFDs();
}
