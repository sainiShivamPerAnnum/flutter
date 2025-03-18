part of 'transaction_bloc.dart';

sealed class FixedDepositTransactionState extends Equatable {
  const FixedDepositTransactionState();
}

class LoadingMyDeposits extends FixedDepositTransactionState {
  const LoadingMyDeposits();

  @override
  List<Object?> get props => const [];
}

final class FdDepositsLoaded extends FixedDepositTransactionState {
  final UserFdPortfolio fdData;
  const FdDepositsLoaded({
    required this.fdData,
  });
  FixedDepositTransactionState copyWith({
    UserFdPortfolio? fdData,
  }) {
    return FdDepositsLoaded(
      fdData: fdData ?? this.fdData,
    );
  }

  @override
  List<Object?> get props => [
        fdData,
      ];
}

class FdMyDepositsError extends FixedDepositTransactionState {
  final String message;

  const FdMyDepositsError(this.message);

  @override
  List<Object> get props => [message];
}
