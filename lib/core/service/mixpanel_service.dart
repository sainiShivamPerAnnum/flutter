import 'package:felloapp/util/flavor_config.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelService {
  static const String DEV_TOKEN = "6bc0994f4244fc5b193213df643f14dc";
  static const String PROD_TOKEN = "03de57e684d04e87999e089fd605fcdd";

  Mixpanel _mixpanel;
  Mixpanel get mixpanel => _mixpanel;

  MixpanelService() {
    init();
  }

  init() async {
    _mixpanel = await Mixpanel.init(FlavorConfig.instance.values.mixpanelToken,
        optOutTrackingDefault: false);
  }

  // _mixpanel.track("tester");
  // _mixpanel.track('Plan Selected', properties: {'Plan': 'Shourya'});
}
