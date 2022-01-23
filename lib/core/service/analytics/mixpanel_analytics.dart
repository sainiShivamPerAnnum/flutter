import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelAnalytics extends BaseAnalyticsService {
  final _logger = locator<CustomLogger>();

  static const String DEV_TOKEN = "6bc0994f4244fc5b193213df643f14dc";
  static const String PROD_TOKEN = "03de57e684d04e87999e089fd605fcdd";

  Mixpanel _mixpanel;

  Future<void> login({bool isOnboarded, BaseUser baseUser}) async {
    try{
      _mixpanel = await Mixpanel.init(
        FlavorConfig.instance.values.mixpanelToken,
        optOutTrackingDefault: false,
      );

      if (isOnboarded != null && isOnboarded && baseUser != null) {
        _mixpanel.identify(baseUser.uid);
        _mixpanel.getPeople().set("Mobile", baseUser.mobile ?? '');
        _mixpanel.getPeople().set("Name", baseUser.name ?? '');
        _mixpanel.getPeople().set("Email", baseUser.email ?? '');
        _mixpanel.getPeople().set("Age", getAge(baseUser.dob, _logger) ?? 0);
        _mixpanel.getPeople().set("Gender", baseUser.gender ?? 'O');
        _mixpanel.getPeople().set("Signed Up", getSignupDate(baseUser.createdOn));
        _mixpanel
            .getPeople()
            .set("KYC Verified", baseUser.isSimpleKycVerified ?? false);

        _logger.d("MIXPANEL SERVICE :: User identify properties added.");
      }
    }catch(e) {
      _logger.e(e.toString());
    }
  }

  void signOut() {
    _mixpanel.reset();
  }

  void track({String eventName, Map<String, dynamic> properties}) {
    try{
      if (_mixpanel == null) {
        login()
            .then((value) => track(eventName: eventName, properties: properties));
      } else {
        if (properties != null && properties.isNotEmpty) {
          _mixpanel.track(eventName, properties: properties);
          _logger.i(
              "Event: $eventName, Properties: ${properties.toString()}. Successfully tracked");
        } else {
          _mixpanel.track(eventName);
        }
      }
    }catch(e) {
      _logger.e(e.toString());
    }
  }

  void trackScreen({String screen, Map<String, dynamic> properties}) {}
}
