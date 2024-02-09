import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/model/sip_model/sip_options.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_holder.dart';
import 'package:felloapp/feature/sip/mandate_page/view/mandate_view.dart';
import 'package:felloapp/feature/sip/sip_polling_page/view/sip_polling_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/locator.dart';

part 'sip_form_state.dart';

class SipFormCubit extends Cubit<SipFormState> {
  SipFormCubit() : super(const LoadingSipFormData());
  final SubService _subService = locator<SubService>();
  final _subscriptionRepo = locator<SubscriptionRepo>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  void setAmount(int amount) {
    final currentState = state;
    if (currentState is SipFormCubitState) {
      emit(currentState.copyWith(formAmount: amount));
    }
  }

  void onTabChange(int index) {
    final currentState = state;
    if (currentState is SipFormCubitState) {
      List<String> tabOptions =
          SipDataHolder.instance.data.amountSelectionScreen.options;
      List<SipOptions> options = SipDataHolder
          .instance.data.amountSelectionScreen.data[tabOptions[index]]!.options;
      SipOptions? maxValueOption = options.reduce((currentMax, next) =>
          next.value > currentMax.value ? next : currentMax);
      int _upperLimit = maxValueOption.value;
      int _division = options.length;
      int currentAmount = options.firstWhere((option) => option.best).value;
      emit(currentState.copyWith(
          currentTab: index,
          bestOption: options.firstWhere((option) => option.best),
          division: options.length,
          upperLimit: maxValueOption.value,
          formAmount: currentAmount,
          lowerLimit: _upperLimit / _division));
    }
  }

  void init(int? prefillAmount, String? prefillFrequency) {
    List<String> tabOptions =
        SipDataHolder.instance.data.amountSelectionScreen.options;
    int editSipTab = SipDataHolder.instance.data.amountSelectionScreen.options
        .indexOf(prefillFrequency ?? 'DAILY');
    List<SipOptions> options = SipDataHolder.instance.data.amountSelectionScreen
        .data[tabOptions[editSipTab]]!.options;
    SipOptions? maxValueOption = options.reduce((currentMax, next) =>
        next.value > currentMax.value ? next : currentMax);
    SipOptions bestOption = options.firstWhere((option) => option.best);
    int currentAmount = prefillAmount ?? bestOption.value;
    int _upperLimit = maxValueOption.value;
    int _division = options.length;
    emit(SipFormCubitState(
        formAmount: currentAmount,
        currentTab: editSipTab,
        bestOption: bestOption,
        division: options.length,
        upperLimit: maxValueOption.value,
        lowerLimit: _upperLimit / _division));
  }

  Future<bool> editSipTrigger(
      num principalAmount, String frequency, String id) async {
    final currentState = state;
    if (currentState is SipFormCubitState) {
      emit(currentState.copyWith(isLoading: true));
      bool response = await _subService.updateSubscription(
          freq: frequency, amount: principalAmount.toInt(), id: id);
      if (!response) {
        BaseUtil.showNegativeAlert("Failed to update SIP", "Please try again");
        emit(currentState.copyWith(isLoading: false));
        return false;
      } else {
        emit(currentState.copyWith(isLoading: false));
        BaseUtil.showPositiveAlert("Subscription updated successfully",
            "Effective changes will take place from tomorrow");
        await AppState.backButtonDispatcher!.didPopRoute();
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> createSubscription({
    required num amount,
    required String freq,
    required SIPAssetTypes assetType,
  }) async {
    final currentState = state;
    if (currentState is SipFormCubitState) {
      emit(currentState.copyWith(isLoading: true));

      final response = await _subscriptionRepo.createSubscription(
        freq: freq,
        amount: amount,
        assetType: assetType.name,
        lbAmt: assetType.isLendBox ? amount : 0,
        augAmt: assetType.isAugGold ? amount : 0,
      );

      final data = response.model?.data;
      final subscription = data?.subscription;

      if (response.isSuccess() && subscription != null) {
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: SipPollingPageConfig,
          widget: SipPollingPage(
            data: subscription,
          ),
        );
      } else {
        emit(currentState.copyWith(isLoading: false));
        BaseUtil.showNegativeAlert(
          'Failed to create subscription',
          response.errorMessage,
        );
      }
    }
  }

  Future<void> onFormSubmit(
    bool mandateAvailable,
    bool isKYCVerified,
    bool isValidAmount,
    bool isEdit,
    num amount,
    String frequency,
    String? id,
    SIPAssetTypes sipAssetType,
    String defultChip,
    String defaultTickets,
    String minAmount,
  ) async {
    _analyticsService
        .track(eventName: AnalyticsEvents.sipPaymentAppChoose, properties: {
      "Frequency": frequency,
      "Amount": amount,
      "Default chip amount": defultChip,
      "tambola tickets": defaultTickets,
      "KYC Status": isKYCVerified ? "Yes" : "No",
      "Minimum Amount": minAmount,
    });
    if (!isKYCVerified) {
      AppState.delegate!.appState.currentAction =
          PageAction(page: KycDetailsPageConfig, state: PageState.addPage);
    } else if (isValidAmount) {
      if (isEdit) {
        await editSipTrigger(amount, frequency, id!);
      } else {
        if (mandateAvailable) {
          await createSubscription(
              amount: amount, freq: frequency, assetType: sipAssetType);
        } else {
          AppState.delegate!.appState.currentAction = PageAction(
            page: SipMandatePageConfig,
            widget: SipMandateView(
                amount: amount, frequency: frequency, assetType: sipAssetType),
            state: PageState.addWidget,
          );
        }
      }
    }
  }
}
