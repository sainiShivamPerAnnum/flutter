part of 'my_deposit_bloc.dart';

sealed class MyFixedDepositEvent {
  const MyFixedDepositEvent();
}

class LoadMyFDs extends MyFixedDepositEvent {
  const LoadMyFDs();
}
