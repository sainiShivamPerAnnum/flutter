import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/fd_web_view.dart';

part 'deposit_calculator_state.dart';
part 'deposit_calculator_event.dart';

class FDCalculatorBloc
    extends Bloc<FDCalculatorEvents, FixedDepositCalculatorState> {
  final FdRepository _fdRepository;
  Timer? _debounce;
  FdCalculationResult? _lastFdCalculationResult;

  FDCalculatorBloc(
    this._fdRepository,
  ) : super(const LoadingFdCalculator()) {
    on<UpdateFDVariables>(_onUpdateFDVariables);
    on<OnProceed>(_onProceed);
  }

  FutureOr<void> _onUpdateFDVariables(
    UpdateFDVariables event,
    Emitter<FixedDepositCalculatorState> emitter,
  ) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {});
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      emitter(const LoadingFdCalculator());
      final response = await _fdRepository.fetchFdCalculation(
        investmentAmount: event.investmentAmount,
        investmentPeriod: event.investmentPeriod,
        isSeniorCitizen: event.isSeniorCitizen,
        payoutFrequency: event.payoutFrequency,
        isFemale: event.isFemale,
        issuerId: event.issuerId,
      );

      if (response.isSuccess() &&
          response.model != null &&
          response.model?.data != null) {
        _lastFdCalculationResult = FdCalculationResult(
          totalInterest: response.model!.data!.totalInterest,
          maturityAmount: response.model!.data!.maturityAmount,
          interestRate: response.model!.data!.interestRate,
        );
        emitter(_lastFdCalculationResult!);
      } else {
        emitter(
          FCalculatorError(
            response.errorMessage ?? 'Unknown error occurred',
          ),
        );
      }
    } catch (e) {
      emitter(FCalculatorError(e.toString()));
    }
  }

  FutureOr<void> _onProceed(
    OnProceed event,
    Emitter<FixedDepositCalculatorState> emitter,
  ) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {});
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      emitter(const ProccedingToDeposit());
      final response = await _fdRepository.getRedirectionUrl(
        issuerId: event.issuerId,
      );

      if (response.isSuccess() && response.model != null) {
        AppState.delegate!.appState.currentAction = PageAction(
          page: WebViewPageConfig,
          state: PageState.addWidget,
          widget: FdWebView(
            url: response.model!,
            onPageClosed: () {
              if (_lastFdCalculationResult != null) {
                emitter(_lastFdCalculationResult!);
              }
            },
          ),
        );
      } else {
        emitter(
          FCalculatorError(
            response.errorMessage ?? 'Unknown error occurred',
          ),
        );
      }
    } catch (e) {
      emitter(FCalculatorError(e.toString()));
    }
  }
}
