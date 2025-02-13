part of 'fixed_deposit_bloc.dart';

sealed class MyFixedDepositState extends Equatable {
  const MyFixedDepositState();
}

class LoadingMyDeposits extends MyFixedDepositState {
  const LoadingMyDeposits();

  @override
  List<Object?> get props => const [];
}

final class FdDepositsLoaded extends MyFixedDepositState {
  final UserFdPortfolio fdData;
  const FdDepositsLoaded({
    required this.fdData,
  });
  MyFixedDepositState copyWith({
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

class FdMyDepositsError extends MyFixedDepositState {
  final String message;

  const FdMyDepositsError(this.message);

  @override
  List<Object> get props => [message];
}
