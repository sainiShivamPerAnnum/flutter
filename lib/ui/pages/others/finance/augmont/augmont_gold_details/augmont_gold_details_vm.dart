import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class AugmontGoldDetailsViewModel extends BaseModel {
  final _augmontModel = locator<AugmontModel>();

  bool isGoldRateFetching = false;
  AugmontRates goldRates;

  fetchGoldRates() async {
    isGoldRateFetching = true;
    refresh();
    goldRates = await _augmontModel.getRates();
    if (goldRates == null)
      BaseUtil.showNegativeAlert(
          "Unable to fetch current price", "Please try again in few minutes");
    isGoldRateFetching = false;
    refresh();
  }
}
