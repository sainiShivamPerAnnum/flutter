import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';

class KycUrls {
  static String defaultBaseUri;
  static String channelId;
  static String userName;

  static init() {
    if (FlavorConfig.instance.values.signzyStage == SignzyStage.DEV) {
      defaultBaseUri = 'multi-channel-preproduction.signzy.tech';
      channelId = "6007e4edf3be1f1190757519";
    } else {
      defaultBaseUri = 'multi-channel.signzy.tech';
      channelId = '60250a6e13e0e620a8cb489e';
    }
  }

  static String createOnboardingObject = "/api/channels/$channelId/onboardings";
  static String convertImages = "https://persist.signzy.tech/api/files/upload";

  static String login = "/api/onboardings/login?ns=";
  static String execute = "$defaultBaseUri/api/onboardings/execute";
  static String update = "$defaultBaseUri/api/onboardings/updateForm";
  static String generatePdf = "$defaultBaseUri/api/onboardings/execute";
}
