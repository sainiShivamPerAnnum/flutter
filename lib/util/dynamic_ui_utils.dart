import 'package:felloapp/core/model/page_config_model.dart';

class DynamicUiUtils {
  static List<List<String>> saveViewOrder = [
    ['AG', 'LB'],
    ['AS', 'CH', 'BL']
  ];

  static List<String> navBar = ["JN", "SV", "TM", "PL", "AC"];
  static List<String> playViewOrder = ['TA', 'AG', 'HTP', 'GOW', 'ST'];
  static SingleInfo helpFab =
      SingleInfo(iconUri: '', actionUri: '', title: 'Help', isCollapse: true);
}
