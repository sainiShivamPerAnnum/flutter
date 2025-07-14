part of 'rps_bloc.dart';

sealed class RPSState extends Equatable {
  const RPSState();
}

class LoadingRPSDetails extends RPSState {
  const LoadingRPSDetails();

  @override
  List<Object?> get props => const [];
}

final class RPSDataState extends RPSState {
  final RpsData? fixedData;
  const RPSDataState({
    required this.fixedData,
  });
  RPSDataState copyWith({
    RpsData? fixedData,
    RpsData? flexiData,
  }) {
    return RPSDataState(
      fixedData: fixedData ?? this.fixedData,
    );
  }

  @override
  List<Object?> get props => [
        fixedData,
      ];
}
