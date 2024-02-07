import 'package:felloapp/core/model/sip_model/sip_data_model.dart';

class SipDataHolder {
  const SipDataHolder._(this.data);
  final SipData data;

  static SipDataHolder? _instance;

  static SipDataHolder get instance {
    return _instance!;
  }

  factory SipDataHolder.init(SipData data) {
    final d = SipDataHolder._(data);
    _instance = d;
    return _instance!;
  }
}
