part of 'sip_form_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class SipFormCubitState extends AutoSaveSetupState {
  final double formAmount;
  // int? editIndex;
  SipFormCubitState({
    this.formAmount = 0,
  });

  SipFormCubitState copyWith({
    double? formAmount,
  }) {
    return SipFormCubitState(
      formAmount: formAmount ?? this.formAmount,
    );
  }
}
