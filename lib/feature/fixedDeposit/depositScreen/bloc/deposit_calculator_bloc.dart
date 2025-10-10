import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/repository/fixed_deposit_repo.dart';
import 'package:felloapp/feature/fixedDeposit/depositScreen/widgets/redirection_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'deposit_calculator_state.dart';
part 'deposit_calculator_event.dart';

class FDCalculatorBloc
    extends Bloc<FDCalculatorEvents, FixedDepositCalculatorState> {
  final FdRepository _fdRepository;
  Timer? _debounce;
  FdCalculationResult? _lastFdCalculationResult;
  double? _lastInvestmentAmount;
  int? _lastInvestmentPeriod;
  bool? _lastIsSeniorCitizen;
  String? _lastPayoutFrequency;
  bool? _lastIsFemale;
  String? _lastIssuerId;

  FDCalculatorBloc(
    this._fdRepository,
  ) : super(const LoadingFdCalculator()) {
    on<UpdateFDVariables>(_onUpdateFDVariables);
    on<RestoreLastFDCalculation>(_onRestoreLastFDCalculation);
    on<OnProceed>(_onProceed);
  }

  FutureOr<void> _onUpdateFDVariables(
    UpdateFDVariables event,
    Emitter<FixedDepositCalculatorState> emitter,
  ) async {
    _lastInvestmentAmount = event.investmentAmount;
    _lastInvestmentPeriod = event.investmentPeriod;
    _lastIsSeniorCitizen = event.isSeniorCitizen;
    _lastPayoutFrequency = event.payoutFrequency;
    _lastIsFemale = event.isFemale;
    _lastIssuerId = event.issuerId;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {});
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      if (event.investmentAmount < event.minAmount) {
        emitter(
          FCalculatorError(
            'The minimum investment amount is ₹${event.minAmount}',
          ),
        );
        return;
      }
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

  FutureOr<void> _onRestoreLastFDCalculation(
    RestoreLastFDCalculation event,
    Emitter<FixedDepositCalculatorState> emitter,
  ) async {
    final investmentAmount = event.investmentAmount ?? _lastInvestmentAmount;
    final investmentPeriod = event.investmentPeriod ?? _lastInvestmentPeriod;
    final isSeniorCitizen = event.isSeniorCitizen ?? _lastIsSeniorCitizen;
    final payoutFrequency = event.payoutFrequency ?? _lastPayoutFrequency;
    final isFemale = event.isFemale ?? _lastIsFemale;
    final issuerId = event.issuerId ?? _lastIssuerId;

    if (investmentAmount != null &&
        investmentPeriod != null &&
        isSeniorCitizen != null &&
        payoutFrequency != null &&
        isFemale != null &&
        issuerId != null) {
      try {
        emitter(const LoadingFdCalculator());
        final response = await _fdRepository.fetchFdCalculation(
          investmentAmount: investmentAmount,
          investmentPeriod: investmentPeriod,
          isSeniorCitizen: isSeniorCitizen,
          payoutFrequency: payoutFrequency,
          isFemale: isFemale,
          issuerId: issuerId,
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
    } else {
      emitter(const FCalculatorError('No previous calculation found'));
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
        blostemId: event.blostemId,
      );

      if (response.isSuccess() && response.model != null) {
        AppState.screenStack.add(ScreenItem.modalsheet);
        await BaseUtil.openModalBottomSheet(
          isScrollControlled: false,
          enableDrag: true,
          isBarrierDismissible: true,
          addToScreenStack: false,
          content: BlostemRedirectionSheet(
            blostemUrl: response.model!,
            onCloseWebView: () {
              add(
                RestoreLastFDCalculation(
                  investmentAmount: event.investmentAmount > event.minAmount
                      ? event.investmentAmount
                      : event.minAmount.toDouble(),
                ),
              );
            },
          ),
        );
        add(
          RestoreLastFDCalculation(
            investmentAmount: event.investmentAmount > event.minAmount
                ? event.investmentAmount
                : event.minAmount.toDouble(),
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
