import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class FaqPageViewModel extends BaseViewModel {
  final GetterRepository _gettersRepo = locator<GetterRepository>();

  List<FAQDataModel>? _list = [];
  List<FAQDataModel>? get list => _list;

  void init(FaqsType type) {
    fetchFaqs(type);
  }

  Future<void> fetchFaqs(FaqsType type) async {
    setState(ViewState.Busy);

    final res = await _gettersRepo.getFaqs(type: type);
    if (res.isSuccess()) {
      _list = res.model;
    } else {
      BaseUtil.showNegativeAlert("", res.errorMessage);
    }

    setState(ViewState.Idle);
  }
}
