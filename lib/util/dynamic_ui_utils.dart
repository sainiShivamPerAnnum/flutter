import 'package:felloapp/core/model/page_config_model.dart';

class DynamicUiUtils {
  static List<dynamic> saveViewOrder = [
    ['AG', 'LB'],
    ['AS', 'CH', 'BL'],
  ];

  static CtaText ctaText = CtaText(
    "India's favorite asset",
    "Over 2L users have invested in Flo in the last month.",
  );
  static bool isGoldTrending = false;
  static bool islbTrending = false;

  static String goldTag = "";
  static String lbTag = "";
  // static Text trendingTag=
  static List<String> navBar = ["JN", "SV", "TM", "PL", "AC"];
  static List<String> playViewOrder = ['TA', 'AG', 'HTP', 'GOW', 'ST'];
  static SingleInfo helpFab =
      SingleInfo(iconUri: '', actionUri: '', title: 'Help', isCollapse: true);
}
