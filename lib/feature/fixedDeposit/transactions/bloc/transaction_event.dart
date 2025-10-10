part of 'transaction_bloc.dart';

sealed class FixedDepositTransactionEvent {
  const FixedDepositTransactionEvent();
}

class LoadMyFDTransactions extends FixedDepositTransactionEvent {
  const LoadMyFDTransactions();
}

class SwitchFilter extends FixedDepositTransactionEvent {
  final String filter;
  const SwitchFilter(
    this.filter,
  );
}
