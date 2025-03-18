part of 'deposit_details_bloc.dart';

sealed class FixedDepositDetailsState extends Equatable {
  const FixedDepositDetailsState();
}

class LoadingMyDeposits extends FixedDepositDetailsState {
  const LoadingMyDeposits();

  @override
  List<Object?> get props => const [];
}

final class FdDepositsLoaded extends FixedDepositDetailsState {
  final List<AllFdsData> fdData;
  const FdDepositsLoaded({
    required this.fdData,
  });
  FixedDepositDetailsState copyWith({
    List<AllFdsData>? fdData,
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

class FdMyDepositsError extends FixedDepositDetailsState {
  final String message;

  const FdMyDepositsError(this.message);

  @override
  List<Object> get props => [message];
}
