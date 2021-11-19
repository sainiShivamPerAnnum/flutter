import 'package:felloapp/util/flavor_config.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelService {
  static const String DEV_TOKEN = "6bc0994f4244fc5b193213df643f14dc";
  static const String PROD_TOKEN = "03de57e684d04e87999e089fd605fcdd";

  Mixpanel _mixpanel;

  Future<void> init() async {
    _mixpanel = await Mixpanel.init(FlavorConfig.instance.values.mixpanelToken,
        optOutTrackingDefault: false);
  }

  void track(String eventName, Map<String, dynamic> properties) {
    if (_mixpanel == null) init();
    try {
      _mixpanel.track(eventName, properties: properties);
    } catch (e) {
      String error = e ?? "Unable to track event: $eventName";
      throw error;
    }
  }
}
