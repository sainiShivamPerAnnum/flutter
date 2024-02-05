import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'sip_form_state.dart';

class SipFormCubit extends Cubit<SipFormCubitState> {
  SipFormCubit() : super(SipFormCubitState());

  void setAmount(double amount) {
    emit(state.copyWith(formAmount: amount));
  }
}
