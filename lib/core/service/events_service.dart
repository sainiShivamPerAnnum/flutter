enum SaverType { MONTHLY, DAILY, WEEKLY, FPL }

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
      case "FPL":
        return SaverType.FPL;
        break;
      default:
        return SaverType.DAILY;
        break;
    }
  }
}
