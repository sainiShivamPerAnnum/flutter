part of 'sip_form_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class SipFormCubitState extends AutoSaveSetupState {
  final int formAmount;
  final bool isLoading;
  SipFormCubitState({
    this.formAmount = 0,
    this.isLoading = false,
  });

  SipFormCubitState copyWith({
    int? formAmount,
    bool? isLoading,
  }) {
    return SipFormCubitState(
        formAmount: formAmount ?? this.formAmount,
        isLoading: isLoading ?? this.isLoading);
  }
}
