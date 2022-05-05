enum CampaignType { MONTHLY, DAILY, WEEKLY, FPL, BUGBOUNTY, NEWFELLO }

class EventService {
  CampaignType getEventType(String type) {
    switch (type) {
      case "SAVER_DAILY":
        return CampaignType.DAILY;
        break;
      case "SAVER_WEEKLY":
        return CampaignType.WEEKLY;
        break;
      case "SAVER_MONTHLY":
        return CampaignType.MONTHLY;
        break;
      case "FPL":
        return CampaignType.FPL;
        break;
      case "BUG_BOUNTY":
        return CampaignType.BUGBOUNTY;
        break;
      case "NEW_FELLO":
        return CampaignType.NEWFELLO;
        break;
      default:
        return CampaignType.DAILY;
        break;
    }
  }
}
