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
  final List<FDTransactionData> activeDeposits;
  final List<FDTransactionData> maturedDeposits;
  final String currentFilter;
  const FdDepositsLoaded({
    required this.activeDeposits,
    required this.maturedDeposits,
    this.currentFilter = 'ACTIVE',
  });
  List<FDTransactionData> get filteredDeposits {
    return currentFilter == 'ACTIVE' ? activeDeposits : maturedDeposits;
  }

  FixedDepositTransactionState copyWith({
    List<FDTransactionData>? activeDeposits,
    List<FDTransactionData>? maturedDeposits,
    String? currentFilter,
  }) {
    return FdDepositsLoaded(
      activeDeposits: activeDeposits ?? this.activeDeposits,
      maturedDeposits: maturedDeposits ?? this.maturedDeposits,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [
        activeDeposits,
        maturedDeposits,
        currentFilter,
      ];
}

class FdMyDepositsError extends FixedDepositTransactionState {
  final String message;

  const FdMyDepositsError(this.message);

  @override
  List<Object> get props => [message];
}

class NoFixedDepositsState extends FixedDepositTransactionState {
  final String message;

  const NoFixedDepositsState(this.message);

  @override
  List<Object> get props => [message];
}
