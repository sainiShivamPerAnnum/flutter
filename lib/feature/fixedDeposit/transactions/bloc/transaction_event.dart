part of 'transaction_bloc.dart';

sealed class FixedDepositTransactionEvent {
  const FixedDepositTransactionEvent();
}

class LoadMyFDs extends FixedDepositTransactionEvent {
  const LoadMyFDs();
}
