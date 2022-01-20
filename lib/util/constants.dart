class Constants {
  static const String APP_NAME = "Fello";
  static const String PAN_AES_KEY = 'felloisquitefun!';

  //Game Type
  static const String GAME_TYPE_CRICKET = "GM_CRIC2020";
  static const String GAME_TYPE_TAMBOLA = "GM_TAMBOLA2020";

  //Collections
  static final String COLN_USERS = "users";
  static final String COLN_ANNOUNCEMENTS = "announcements";
  static final String COLN_TICKETREQUEST = "ticketrequests";
  static final String COLN_DAILYPICKS = "dailypicks";
  static final String COLN_WINNERS = "winners";
  static final String COLN_REFERRALS = "referrals";
  static final String COLN_FEEDBACK = "feedback";
  static final String COLN_FAILREPORTS = "failreports";
  static final String COLN_CREDENTIALS = "credentials";
  static final String COLN_POLLS = "polls";
  static final String COLN_HOMECARDS = "homefeed";
  static final String COLN_PROMOS = "promos";
  static final String COLN_EMAILOTPREQUESTS = "emailotprequests";
  static final String COLN_STATISTICS = "statistics";
  static final String WINNERS = "winners";
  static final String COLN_PRIZES = "prizes";
  static final String COLN_FAQS = "faqs";

  //Sub-collections
  static final String SUBCOLN_USER_FCM = "fcm";
  static final String SUBCOLN_USER_TICKETS = "tickets";
  static final String SUBCOLN_USER_ICICI_DETAILS = "icici";
  static final String SUBCOLN_USER_AUGMONT_DETAILS = "augmont";
  static final String SUBCOLN_USER_KYC_DETAILS = "kyc";
  static final String SUBCOLN_USER_PRTD = "prtd";
  static final String SUBCOLN_USER_TXNS = "txns";
  static final String SUBCOLN_USER_WALLET = "wallet";
  static final String SUBCOLN_USER_POLL_RESPONSES = "poll";
  static final String SUBCOLN_USER_ALERTS = "alerts";
  static final String SUBCOLN_USER_REWARDS = "rewards";
  static final String SUBCOLN_USER_STATS = "stats";
  //Sub-collection docs
  static final String DOC_USER_FCM_TOKEN = "client_token";
  static final String DOC_USER_ICICI_DETAIL = "detail";
  static final String DOC_USER_KYC_DETAIL = "detail";
  static final String DOC_USER_AUGMONT_DETAIL = "detail";
  static final String DOC_USER_WALLET_FUND_BALANCE = "fndbalance";
  static final String DOC_USER_WALLET_TICKET_BALANCE = "tckbalance";
  static final String DOC_USER_WALLET_COIN_BALANCE = "coinbalance";

  static const int CORNERS_COMPLETED = 0;
  static const int ROW_ONE_COMPLETED = 1;
  static const int ROW_TWO_COMPLETED = 2;
  static const int ROW_THREE_COMPLETED = 3;
  static const int FULL_HOUSE_COMPLETED = 4;

  static const String POLL_NEXTGAME_ID = "nextgame";
  static const String POLL_FOLLOWUPGAME_ID = "followupgame";

  static const String GOLDENTICKET_DYNAMICLINK_PREFIX =
      "https://fello.in/goldenticket";

  //home feed
  static const String LEARN_FEED_CARD_TYPE = 'L';
  static const String PRIZE_FEED_CARD_TYPE = 'P';
  static const String TAMBOLA_FEED_CARD_TYPE = 'T';
  static const String DEFAULT_FEED_CARD_TYPE = 'T';

  static const int REFERRAL_TICKET_BONUS = 10;
  static const int REFERRAL_AMT_BONUS = 25;

  // static const int TOTAL_DRAWS = 35;
  static const int NEW_USER_TICKET_COUNT = 0;
  static const int MAX_TICKET_GEN_PER_REQUEST = 30;
  static const int KYC_UNTESTED = 0;
  static const int KYC_INVALID = 1;
  static const int KYC_VALID = 2;
  static const int INVESTMENT_AMOUNT_FOR_TICKET = 100;
  static const int AUG_GOLD_WITHDRAW_OFFSET =
      2; //no of days to wait before withdrawal
  static const int UNLOCK_REFERRAL_AMT = 100;
  static final DateTime VERSION_2_RELEASE_DATE = DateTime(2021, 4, 1);
  static final String GAME_CRICKET_URI =
      'https://prod.freakx.in/fello/cricket-2021-V2/';

  static const INSTALL_CLICK_ID = 'FELLO_INSTALL';
  static const SIGNUP_CLICK_ID = 'FELLO_SIGNUP';

  static const acquisitionTrackURL =
      "https://optimidea.vnative.co/acquisition?security_token=fc8979c42862e88b9081&goal_value=783&click_id=";
}
