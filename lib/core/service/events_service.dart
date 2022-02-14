import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_view.dart';

enum SaverType { MONTHLY, DAILY, WEEKLY }

class EventService {
  SaverType getEventType(String type) {
    switch (type) {
      case "SAVER_DAILY":
        return SaverType.DAILY;
        break;
      case "SAVER_WEEKLY":
        return SaverType.WEEKLY;
        break;
      case "SAVER_MONTHLY":
        return SaverType.MONTHLY;
        break;
      default:
        return SaverType.DAILY;
        break;
    }
  }
}
