part of 'fixed_deposit_bloc.dart';

sealed class FDCalculatorEvents {
  const FDCalculatorEvents();
}

class LoadFDCalculator extends FDCalculatorEvents {
  const LoadFDCalculator();
}
