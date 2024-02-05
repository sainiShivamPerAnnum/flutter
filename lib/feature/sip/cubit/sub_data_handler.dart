import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';

class AllSubscriptionHolder {
  const AllSubscriptionHolder._(this.data);
  final AllSubscriptionModel data;

  static AllSubscriptionHolder? _instance;

  static AllSubscriptionHolder get instance {
    return _instance!;
  }

  factory AllSubscriptionHolder.init(AllSubscriptionModel data) {
    final d = AllSubscriptionHolder._(data);
    _instance = d;
    return _instance!;
  }
}
