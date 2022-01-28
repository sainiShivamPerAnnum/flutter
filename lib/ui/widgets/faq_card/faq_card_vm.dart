import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';

class FAQCardViewModel extends BaseModel {
  static const String FAQ_CAT_GENERAL = 'general';
  static const String FAQ_CAT_AUGMONT = 'digital_gold';
  static const String FAQ_CAT_REFERRALS = 'referrals';
  static const String FAQ_CAT_TAMBOLA = 'tambola';
  static const String FAQ_CAT_MUTUALFUNDS = 'mututalfunds';

  final _dbModel = locator<DBModel>();
  final _logger = locator<CustomLogger>();
  List<bool> detStatus;
  List<String> faqHeaders = [];
  List<String> faqResponses = [];

  init(String category) async {
    setState(ViewState.Busy);
    await fetchFaqs(category);
    detStatus = List.filled(faqHeaders.length, false);
    setState(ViewState.Idle);
  }

  Future fetchFaqs(String category) async {
    ApiResponse response = await _dbModel.fetchCategorySpecificFAQ(category);
    if (response.code == 200) {
      _logger.d("FAQs fetched for category: ${response.model.category}");
      faqHeaders.clear();
      faqResponses.clear();
      List<FAQ> faqs = response.model.faqList;
      faqs.sort((a, b) => a.order.compareTo(b.order));
      faqs.forEach((e) {
        faqHeaders.add(e.header);
        faqResponses.add(e.response);
      });
    }
  }

  updateDetStatus(int i, bool val) {
    detStatus[i] = val;
    notifyListeners();
  }
}
