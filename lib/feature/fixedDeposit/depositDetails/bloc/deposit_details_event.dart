part of 'deposit_details_bloc.dart';

sealed class FixedDepositDetailsEvent {
  const FixedDepositDetailsEvent();
}

class LoadMyFDs extends FixedDepositDetailsEvent {
  const LoadMyFDs();
}
