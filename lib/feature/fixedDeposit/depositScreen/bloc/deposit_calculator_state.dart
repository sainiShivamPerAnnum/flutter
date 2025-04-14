part of 'deposit_calculator_bloc.dart';

sealed class FixedDepositCalculatorState extends Equatable {
  const FixedDepositCalculatorState();
}

class LoadingFdCalculator extends FixedDepositCalculatorState {
  const LoadingFdCalculator();

  @override
  List<Object?> get props => const [];
}

class ProccedingToDeposit extends FixedDepositCalculatorState {
  const ProccedingToDeposit();

  @override
  List<Object?> get props => const [];
}

class FdCalculationResult extends FixedDepositCalculatorState {
  final String? totalInterest;
  final String? maturityAmount;
  final num? interestRate;

  const FdCalculationResult({
    this.totalInterest,
    this.maturityAmount,
    this.interestRate,
  });

  @override
  List<Object?> get props => [
        totalInterest,
        maturityAmount,
        interestRate,
      ];
}

class FCalculatorError extends FixedDepositCalculatorState {
  final String message;

  const FCalculatorError(this.message);

  @override
  List<Object?> get props => [message];
}
