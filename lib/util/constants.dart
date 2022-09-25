class Constants {
  static const String APP_NAME = "Fello";
  static const String PAN_AES_KEY = 'felloisquitefun!';

  //Game Type

  static const String GAME_TYPE_CANDYFIESTA = "GM_CANDY_FIESTA";
  static const String GAME_TYPE_FOOTBALL = "GM_FOOTBALL_KICKOFF";
  static const String GAME_TYPE_CRICKET = "GM_CRICKET_HERO";
  static const String GAME_TYPE_TAMBOLA = "GM_TAMBOLA2020";
  static const String GAME_TYPE_POOLCLUB = "GM_POOL_CLUB";
  static const String GAME_TYPE_HIGHEST_SAVER = "HIGHEST_SAVER";
  static const String GAME_TYPE_FPL = "FPL";

  //HIGHEST SAVER
  static const String HS_DAILY_SAVER = "SAVER_DAILY";
  static const String HS_WEEKLY_SAVER = "SAVER_WEEKLY";
  static const String HS_MONTHLY_SAVER = "SAVER_MONTHLY";
  static const String BUG_BOUNTY = "BUG_BOUNTY";
  static const String NEW_FELLO_UI = "NEW_FELLO";

  //Collections
  static final String COLN_USERS = "users";
  static final String COLN_ANNOUNCEMENTS = "announcements";
  static final String COLN_FEEDBACK = "feedback";
  static final String COLN_CREDENTIALS = "credentials";
  static final String COLN_EMAILOTPREQUESTS = "emailotprequests";
  static final String WINNERS = "winners";
  static final String COLN_FAQS = "faqs";
  static final String COLN_GAMES = "games";

  //Sub-collections
  static final String SUBCOLN_USER_FCM = "fcm";
  static final String SUBCOLN_USER_AUGMONT_DETAILS = "augmont";
  static final String SUBCOLN_USER_PRTD = "prtd";
  static final String SUBCOLN_USER_TXNS = "txns";
  static final String SUBCOLN_USER_WALLET = "wallet";
  static final String SUBCOLN_USER_REWARDS = "rewards";

  //Sub-collection docs
  static final String DOC_USER_FCM_TOKEN = "client_token";
  static final String DOC_USER_ICICI_DETAIL = "detail";
  static final String DOC_USER_KYC_DETAIL = "detail";
  static final String DOC_USER_AUGMONT_DETAIL = "detail";
  static final String DOC_USER_WALLET_FUND_BALANCE = "fndbalance";
  static final String DOC_USER_WALLET_TICKET_BALANCE = "tckbalance";
  static final String DOC_USER_WALLET_COIN_BALANCE = "coinbalance";
  static final String DOC_IAR_DAILY_CHIPS = "daily";
  static final String DOC_IAR_WEEKLY_CHIPS = "weekly";

  //Fetch real time finance stats from rtdb
  static final String DAILY = "daily";
  static final String WEEKLY = "weekly";

  static final String MONTHLY = "monthly";

  //Sub-Collection docs Collection docs
  static final String DOC_USER_SUBSCRIPTIONS_ORDERS = 'orders';

  static const int CORNERS_COMPLETED = 0;
  static const int ROW_ONE_COMPLETED = 1;
  static const int ROW_TWO_COMPLETED = 2;
  static const int ROW_THREE_COMPLETED = 3;
  static const int FULL_HOUSE_COMPLETED = 4;

  static const String POLL_NEXTGAME_ID = "nextgame";
  static const String POLL_FOLLOWUPGAME_ID = "followupgame";

  static const String APP_DOWNLOAD_LINK = "https://fello.in/download";
  static const String APP_NAVIGATION_LINK = "https://fello.in/app/goto/";

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
  static final DateTime VERSION_2_RELEASE_DATE = DateTime(2021, 4, 1);
  static final String GAME_CRICKET_URI =
      'https://prod.freakx.in/fello/cricket-2021-V2/';

  static const INSTALL_TRACKING = 'FELLO_INSTALL';
  static const SIGNUP_TRACKING = 'FELLO_SIGNUP';

  //Subscription Status
  static const SUBSCRIPTION_INIT = "INIT";
  static const SUBSCRIPTION_ACTIVE = "ACTIVE";
  static const SUBSCRIPTION_PROCESSING = "PROCESSING";
  static const SUBSCRIPTION_INACTIVE = "INACTIVE";
  static const SUBSCRIPTION_CANCELLED = "CANCELLED";

  //Notification Titles Startings
  static const GOLDEN_TICKET_NOTIFICATION = "You won a new golden ticket";
  static const COUPONS_APPLIED_NOTIFICATION = "Coupon Applied";

  static const DEPOSIT_COMPLETE_NOTIFICATION = "Deposit Complete";
  static const TXN_STATUS_RESPONSE_SUCCESS = "SUCCESS";
  static const TXN_STATUS_RESPONSE_FAILURE = "FAIL";
  static const TXN_STATUS_RESPONSE_PENDING = "PENDING";

  //User Bootup EE Constnats
  static const LAST_OPENED = "last_opened";
  static const DATE_TODAY = "date_today";
  static const DAY_OPENED_COUNT = "day_open_count";
  //Notices
  static const IS_MSG_NOTICE_AVILABLE = "isNoticeMessageAvilable";
  static const MSG_NOTICE = "url_message";
  //Normal app update dialog show
  static const IS_APP_UPDATE_AVILABLE = "isAppUpdateAvilable";

  static const PLAY_STORE_APP_LINK =
      "https://play.google.com/store/apps/details?id=in.fello.felloapp";
  static const APPLE_STORE_APP_LINK =
      "https://apps.apple.com/in/app/fello-save-play-win/id1558445254";
}
