import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';

class KycUrls {
  static String defaultBaseUri;
  static String channelId;
  static String userName;

  static init() {
    if (Constants.activeSignzyStage == SignzyStage.DEV) {
      defaultBaseUri = 'https://multi-channel-preproduction.signzy.tech';
      channelId = "6007e4edf3be1f1190757519";
    } else {
      defaultBaseUri = 'https://multi-channel.signzy.tech';
      channelId = '60250a6e13e0e620a8cb489e';
    }
  }

  static String createOnboardingObject =
      "$defaultBaseUri/api/channels/$channelId/onboardings";
  static String convertImages = "https://persist.signzy.tech/api/files/upload";

  static String login = "$defaultBaseUri/api/onboardings/login?ns=";
  static String execute = "$defaultBaseUri/api/onboardings/execute";
  static String update = "$defaultBaseUri/api/onboardings/updateForm";
  static String generatePdf = "$defaultBaseUri/api/onboardings/execute";
}
