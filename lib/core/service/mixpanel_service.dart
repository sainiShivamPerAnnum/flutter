import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:intl/intl.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelService {
  final _logger = locator<CustomLogger>();

  static const String DEV_TOKEN = "6bc0994f4244fc5b193213df643f14dc";
  static const String PROD_TOKEN = "03de57e684d04e87999e089fd605fcdd";

  Mixpanel _mixpanel;

  Future<void> init({bool isOnboarded, BaseUser baseUser}) async {
    _mixpanel = await Mixpanel.init(FlavorConfig.instance.values.mixpanelToken,
        optOutTrackingDefault: false);
    if (isOnboarded != null && isOnboarded && baseUser != null) {
      _mixpanel.identify(baseUser.uid);
      _mixpanel.getPeople().set("Mobile", baseUser.mobile ?? '');
      _mixpanel.getPeople().set("Name", baseUser.name ?? '');
      _mixpanel.getPeople().set("Email", baseUser.email ?? '');
      _mixpanel.getPeople().set("Age", _getAge(baseUser.dob) ?? 0);
      _mixpanel.getPeople().set("Gender", baseUser.gender ?? 'O');
      _mixpanel
          .getPeople()
          .set("Signed Up", _getSignupDate(baseUser.createdOn));
      _mixpanel
          .getPeople()
          .set("KYC Verified", baseUser.isSimpleKycVerified ?? false);

      // _mixpanel.registerSuperPropertiesOnce({
      //   'userId': baseUser.uid ?? '',
      //   'gender': baseUser.gender ?? 'O',
      //   'kycVerified': baseUser.isSimpleKycVerified ?? false,
      //   'signupDate': _getSignupDate(baseUser.createdOn),
      //   'age': _getAge(baseUser.dob) ?? 0
      // });

      //Use flush only for testing.
      // _mixpanel.flush();
      _logger.d("MIXPANEL SERVICE :: User identify properties added.");
    }
  }

  void signOut() {
    _mixpanel.reset();
  }

  void track({String eventName, Map<String, dynamic> properties}) {
    if (_mixpanel == null) init();
    try {
      if (properties != null && properties.isNotEmpty) {
        _mixpanel.track(eventName, properties: properties);
        _logger.i(
            "Event: $eventName, Properties: ${properties.toString()}. Successfully tracked");
      } else {
        _mixpanel.track(eventName);
      }
    } catch (e) {
      String error = e ?? "Unable to track event: $eventName";
      _logger.e(error);
    }
  }

  String _getSignupDate(Timestamp signupDate) {
    if (signupDate == null) signupDate = Timestamp.now();
    try {
      return DateFormat('yyyy-MM-dd').format(signupDate.toDate());
    } catch (e) {
      return '';
    }
  }

  int _getAge(String dob) {
    if (dob == null || dob.isEmpty) return 0;
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      int month1 = currentDate.month;
      int month2 = birthDate.month;
      if (month2 > month1) {
        age--;
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          age--;
        }
      }
      return age;
    } catch (e) {
      _logger.e('$e');
      return 0;
    }
  }
}
