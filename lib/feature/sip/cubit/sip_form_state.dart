part of 'sip_form_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

sealed class SipFormState extends Equatable {
  const SipFormState();
}

class LoadingSipFormData extends SipFormState {
  const LoadingSipFormData();

  @override
  List<Object?> get props => const [];
}

final class SipFormCubitState extends SipFormState {
  final int formAmount;
  final bool isLoading;
  final num upperLimit;
  final num lowerLimit;
  final num division;
  final int currentTab;
  final SipOptions bestOption;
  const SipFormCubitState({
    required this.upperLimit,
    required this.lowerLimit,
    required this.division,
    required this.bestOption,
    this.formAmount = 0,
    this.isLoading = false,
    this.currentTab = 0,
  });

  SipFormCubitState copyWith({
    int? formAmount,
    bool? isLoading,
    num? division,
    SipOptions? bestOption,
    num? upperLimit,
    int? currentTab,
    num? lowerLimit,
  }) {
    return SipFormCubitState(
        upperLimit: upperLimit ?? this.upperLimit,
        lowerLimit: lowerLimit ?? this.lowerLimit,
        division: division ?? this.division,
        currentTab: currentTab ?? this.currentTab,
        bestOption: bestOption ?? this.bestOption,
        formAmount: formAmount ?? this.formAmount,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object?> get props => [
        upperLimit,
        lowerLimit,
        division,
        currentTab,
        bestOption,
        formAmount,
        isLoading
      ];
}
