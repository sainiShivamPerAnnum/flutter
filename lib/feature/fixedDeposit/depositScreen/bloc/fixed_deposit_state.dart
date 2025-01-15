part of 'fixed_deposit_bloc.dart';

sealed class FixedDepositCalculatorState extends Equatable {
  const FixedDepositCalculatorState();
}

class LoadingFdCalculator extends FixedDepositCalculatorState {
  const LoadingFdCalculator();

  @override
  List<Object?> get props => const [];
}

final class FdCalculatorLoaded extends FixedDepositCalculatorState {
  final FdCalculator fdCalculatorData;
  const FdCalculatorLoaded({
    required this.fdCalculatorData,
  });
  FixedDepositCalculatorState copyWith({
    FdCalculator? fdCalculatorData,
  }) {
    return FdCalculatorLoaded(
      fdCalculatorData: fdCalculatorData ?? this.fdCalculatorData,
    );
  }

  @override
  List<Object?> get props => [
        fdCalculatorData,
      ];
}

class FCalculatorError extends FixedDepositCalculatorState {
  final String message;

  const FCalculatorError(this.message);

  @override
  List<Object> get props => [message];
}
