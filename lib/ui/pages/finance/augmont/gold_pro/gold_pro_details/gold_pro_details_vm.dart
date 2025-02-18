import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_config_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class GoldProDetailsViewModel extends BaseViewModel {
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  final UserService _userService = locator<UserService>();
  final _txnHistoryService = locator<TxnHistoryService>();
  final _getterRepo = locator<GetterRepository>();
  final AugmontTransactionService _txnService =
      locator<AugmontTransactionService>();
  GoldProConfig? _goldProConfig;

  GoldProConfig? get goldProConfig => _goldProConfig;

  set goldProConfig(GoldProConfig? value) {
    _goldProConfig = value;
    notifyListeners();
  }

  List<bool> detStatus = [false, false, false, false, false, false];
  List<String?> faqHeaders = [
    "What is Gold Pro?",
    "Who can invest in Gold Pro?",
    "How much can you invest in Gold Pro?",
    "What is the maximum investment you can do in Gold Pro?",
    "Is investing in Gold Pro secure?",
    "Is Gold Pro a legal investment option?"
  ];
  List<String?> faqResponses = [
    "Gold Pro is a gold leasing scheme offered in partnership with Fello and Auspicious (India's largest gold refinery). It allows users to securely lease their gold through the Fello app and earn interests of upto ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}%",
    "Any individual over 18 years with a valid PAN card and an active bank account can lease their digital gold on Gold Pro.",
    "The minimum quantity required for Gold Pro is 2 grams, while the maximum quantity is 10 grams.",
    "The maximum investment limit for Gold Pro is 10 grams.",
    "Yes, Gold Pro ensures security by leasing gold to reputable jeweller Divine Hira Jewellers Limited.",
    "Yes, Gold Pro is a legal investment scheme powered by Auspicious"
  ];

  void updateDetStatus(int i, bool val) {
    detStatus[i] = !detStatus[i];
    notifyListeners();
  }

  void init() {
    getGoldProConfigs();
    getGoldProScheme();
    getGoldProTransactions();
  }

  void dump() {}

  Future<void> getGoldProConfigs() async {
    final res = await _getterRepo.getGoldProConfig();
    if (res.isSuccess()) {
      if ((res.model?.data?.faqs ?? []).isNotEmpty) {
        detStatus = [];
        faqHeaders = [];
        faqResponses = [];
        res.model!.data!.faqs!.forEach((element) {
          detStatus.add(false);
          faqHeaders.add(element.title);
          faqResponses.add(element.subTitle);
        });
      }
      goldProConfig = res.model;
    }
  }

  Future<void> getGoldProScheme() async {
    final res = await _paymentRepo.getGoldProScheme();
    if (res.isSuccess()) {
      _txnService.goldProScheme = res.model;
    } else {
      // BaseUtil.showNegativeAlert(
      //     "Failed to fetch Gold Scheme", res.errorMessage);
    }
  }

  Future<void> getGoldProTransactions() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      _txnHistoryService.getGoldProTransactions(forced: true).then((value) {});
    });
  }

  Future<void> pullToRefresh() async {
    await _userService.getUserFundWalletData();
    await _userService.updatePortFolio();
    // await getGoldProScheme();
    await _txnHistoryService.getGoldProTransactions(forced: true);
  }
}
