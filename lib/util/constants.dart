// ignore_for_file: non_constant_identifier_names

class Constants {
  const Constants._();
  static const String APP_NAME = "Fello";
  static const String PAN_AES_KEY = 'felloisquitefun!';

  //Game Type

  static const String GAME_TYPE_CANDYFIESTA = "GM_CANDY_FIESTA";
  static const String GAME_TYPE_FOOTBALL = "GM_FOOTBALL_KICKOFF";
  static const String GAME_TYPE_CRICKET = "GM_CRICKET_HERO";
  static const String GAME_TYPE_TAMBOLA = "GM_TAMBOLA2020";
  static const String GAME_TYPE_POOLCLUB = "GM_POOL_CLUB";
  static const String GAME_TYPE_BOTTLEFLIP = "GM_BOTTLE_FLIP";
  static const String GAME_TYPE_BOWLING = "GM_BOWLING";
  static const String GAME_TYPE_ROLLYVORTEX = "GM_ROLLY_VORTEX";
  static const String GAME_TYPE_KNIFEHIT = "GM_KNIFE_HIT";
  static const String GAME_TYPE_FRUITMAINA = "GM_FRUIT_KNIFE";
  static const String GAME_TYPE_TWODOTS = "GM_TWO_DOTS";
  static const String GAME_TYPE_HIGHEST_SAVER = "HIGHEST_SAVER_V2";
  static const String GAME_TYPE_FPL = "FPL";

  //Assets Type
  static const String ASSET_TYPE_AUGMONT = "AUGGOLD99";
  static const String ASSET_TYPE_AUGMONT_FD = "AUGGOLD99FD";
  static const String ASSET_TYPE_LENDBOX = "LENDBOXP2P";
  static const String ASSET_TYPE_LENDBOX_FD1 = "LENDBOXP2P_FD1";
  static const String ASSET_TYPE_LENDBOX_FD2 = "LENDBOXP2P_FD2";
  static const String ASSET_TYPE_FLO_FELXI = "UNI_FLEXI";
  static const String ASSET_TYPE_FLO_FIXED_3 = "UNI_FIXED_3";
  static const String ASSET_TYPE_FLO_FIXED_6 = "UNI_FIXED_6";
  static const String ASSET_GOLD_STAKE = "Gold Pro";

  //Segments
  static const String US_FLO_OLD = "OLD_LB";
  static const String NEW_USER = "NEW_USER";
  static const String NO_SAVE_AUG = "NO_SAVE_AUG";
  static const String NO_SAVE_LB = "NO_SAVE_LB";

  //HIGHEST SAVER
  static const String HS_DAILY_SAVER = "SAVER_DAILY";
  static const String HS_WEEKLY_SAVER = "SAVER_WEEKLY";
  static const String HS_MONTHLY_SAVER = "SAVER_MONTHLY";
  static const String BUG_BOUNTY = "BUG_BOUNTY";
  static const String NEW_FELLO_UI = "NEW_FELLO";

  //GOLDEN TICKETS REWARD TYPES
  static const String GT_REWARD_GOLD = "gold";
  static const String GT_REWARD_FLC = "flc";
  static const String GT_REWARD_RUPEE = "rupee";
  static const String GT_REWARD_TAMBOLA_TICKET = "tt";
  static const String GT_REWARD_AMT = "amt";

  //Collections
  static const String COLN_USERS = "users";
  static const String COLN_ANNOUNCEMENTS = "announcements";
  static const String COLN_FEEDBACK = "feedback";
  static const String COLN_CREDENTIALS = "credentials";
  static const String COLN_EMAILOTPREQUESTS = "emailotprequests";
  static const String WINNERS = "winners";
  static const String COLN_FAQS = "faqs";
  static const String COLN_GAMES = "games";

  //Sub-collections
  static const String SUBCOLN_USER_FCM = "fcm";
  static const String SUBCOLN_USER_AUGMONT_DETAILS = "augmont";
  static const String SUBCOLN_USER_PRTD = "prtd";
  static const String SUBCOLN_USER_TXNS = "txns";
  static const String SUBCOLN_USER_WALLET = "wallet";
  static const String SUBCOLN_USER_REWARDS = "rewards";

  //Sub-collection docs
  static const String DOC_USER_FCM_TOKEN = "client_token";
  static const String DOC_USER_ICICI_DETAIL = "detail";
  static const String DOC_USER_KYC_DETAIL = "detail";
  static const String DOC_USER_AUGMONT_DETAIL = "detail";
  static const String DOC_USER_WALLET_FUND_BALANCE = "fndbalance";
  static const String DOC_USER_WALLET_TICKET_BALANCE = "tckbalance";
  static const String DOC_USER_WALLET_COIN_BALANCE = "coinbalance";
  static const String DOC_IAR_DAILY_CHIPS = "daily";
  static const String DOC_IAR_WEEKLY_CHIPS = "weekly";

  //Fetch real time finance stats from rtdb
  static const String DAILY = "daily";
  static const String WEEKLY = "weekly";

  static const String MONTHLY = "monthly";

  //Sub-Collection docs Collection docs
  static const String DOC_USER_SUBSCRIPTIONS_ORDERS = 'orders';

  static const int CORNERS_COMPLETED = 0;
  // static const int ROW_ONE_COMPLETED = 1;
  // static const int ROW_TWO_COMPLETED = 2;
  // static const int ROW_THREE_COMPLETED = 3;
  // static const int FULL_HOUSE_COMPLETED = 4;
  static const int ONE_ROW_COMPLETED = 1;
  static const int TWO_ROWS_COMPLETED = 2;
  static const int FULL_HOUSE_COMPLETED = 3;

  static const String POLL_NEXTGAME_ID = "nextgame";
  static const String POLL_FOLLOWUPGAME_ID = "followupgame";

  static const String APP_DOWNLOAD_LINK = "https://fello.in/download";
  static const String APP_NAVIGATION_LINK = "https://fello.in/app/goto/";
  static const String postNBRedirectionURL = 'https://fello.in/';

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
  static const String GAME_CRICKET_URI =
      'https://prod.freakx.in/fello/cricket-2021-V2/';

  static const gamingtnc = "https://fello.in/policy/gaming";
  static const tambolatnc = "https://fello.in/policy/tambola";
  static const savingstnc = "https://fello.in/policy/savings";

  static const INSTALL_TRACKING = 'FELLO_INSTALL';
  static const SIGNUP_TRACKING = 'FELLO_SIGNUP';

  //Subscription Status
  static const SUBSCRIPTION_INIT = "INIT";
  static const SUBSCRIPTION_ACTIVE = "ACTIVE";
  static const SUBSCRIPTION_PROCESSING = "PROCESSING";
  static const SUBSCRIPTION_INACTIVE = "INACTIVE";
  static const SUBSCRIPTION_CANCELLED = "CANCELLED";

  //Notification Titles Startings
  static const GOLDEN_TICKET_NOTIFICATION = "You won a new scratch card";
  static const COUPONS_APPLIED_NOTIFICATION = "Coupon Applied";

  static const DEPOSIT_COMPLETE_NOTIFICATION = "Deposit Complete";
  static const TXN_STATUS_RESPONSE_SUCCESS = "SUCCESS";
  static const TXN_STATUS_RESPONSE_FAILURE = "FAIL";
  static const TXN_STATUS_RESPONSE_PENDING = "PENDING";

  static const GOLD_PRO_TXN_STATUS_ACTIVE = "active";
  static const GOLD_PRO_TXN_STATUS_CLOSE = "close";
  static const GOLD_PRO_TXN_STATUS_PENDING = "pending";
  static const GOLD_PRO_TXN_STATUS_FAILED = "failed";

  //User Bootup EE Constnats
  static const LAST_OPENED = "last_opened";
  static const DATE_TODAY = "date_today";
  static const DAY_OPENED_COUNT = "day_open_count";

  //Notices
  static const IS_MSG_NOTICE_AVAILABLE = "isNoticeMessageAvilable";
  static const MSG_NOTICE = "url_message";

  //Normal app update dialog show
  static const IS_APP_UPDATE_AVAILABLE = "isAppUpdateAvilable";

  static const PLAY_STORE_APP_LINK =
      "https://play.google.com/store/apps/details?id=in.fello.felloapp";
  static const APPLE_STORE_APP_LINK =
      "https://apps.apple.com/in/app/fello-save-play-win/id1558445254";

  // View keys for Apxor Nudges
  static const TOTAL_SAVINGS_JAPPBAR = "savingsJourneyAppBar";
  static const TOTAL_WINNINGS_JAPPBAR = "winningsJourneyAppBar";
  static const PROFILE_JAPPBAR = "profileJourneyAppBar";
  static const PROFILE = "profile";
  static const HELP_FAB = "helpFab";
  static const FELLO_COIN_BAR = "felloCoinBar";
  static const FELLO_COIN_BAR_JAPPBAR = "felloCoinsJourney";
  static const TOTAL_SAVINGS = "totalSavings";
  static const CURRENT_WINNINGS = "currentWinnings";
  static const CURRENT_WINNING_AMOUNT = "currentWinningsAmount";
  static const GOLDENTICKET = "scratchCard";
  static const TAMBOLA = "tambola";
  static const ALL_GAMES = "allGames";
  static const ALL_GAMES_TITLE = "allGamesTitle";
  static const JOURNEY_SCREEN_TAG = "journeyScreenTag";
  static const SAVE_SCREEN_TAG = "saveScreenTag";
  static const WIN_SCREEN_TAG = "winScreenTag";
  static const PLAY_SCREEN_TAG = "playScreenTag";
  static const Game_WEB_VIEW_HOME = "gameWebViewHome";
  static const TAMBOLA_HOME_SCREEN = "tambolaHomeScreenTag";
  static const REWARDS = "rewards";
  static const LEADERBOARD = "leaderBoard";
  static const GET_TAMBOLA_TICKETS = "getTambolaTickets";

  static const FELLO_BALANCE = "felloBalance";

  /// The amount limit of investment after which the mandatory payment gateway
  /// switches to net-banking.
  static const int mandatoryNetBankingThreshold = 125;
}
