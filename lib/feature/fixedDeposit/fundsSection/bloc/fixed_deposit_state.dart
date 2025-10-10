part of 'fixed_deposit_bloc.dart';

sealed class FixedDepositState extends Equatable {
  const FixedDepositState();
}

class LoadingAllFds extends FixedDepositState {
  const LoadingAllFds();

  @override
  List<Object?> get props => const [];
}

final class AllFdsLoaded extends FixedDepositState {
  final List<AllFdsData> fdData;
  const AllFdsLoaded({
    required this.fdData,
  });
  FixedDepositState copyWith({
    List<AllFdsData>? fdData,
  }) {
    return AllFdsLoaded(
      fdData: fdData ?? this.fdData,
    );
  }

  @override
  List<Object?> get props => [
        fdData,
      ];
}

class FdLoadError extends FixedDepositState {
  final String message;

  const FdLoadError(this.message);

  @override
  List<Object> get props => [message];
}
