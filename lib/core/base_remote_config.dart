import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class BaseRemoteConfig {
  static late RemoteConfig remoteConfig;
  static final UserService _userService = locator<UserService>();
  static final InternalOpsService _internalOpsService =
      locator<InternalOpsService>();

  ///Each config is set as a map = {name, default value}

  static const Map<String, String> _LOGIN_ASSET_URL = {
    'loginAssetUrl':
        'https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/temp%2Fmain.svg?alt=media&token=2d4ceda1-2d0b-44c4-8433-1de255da8664'
  };
  static const Map<String, String> _DRAW_PICK_TIME = {'draw_pick_time': '18'};

  static const Map<String, String> _TAMBOLA_HEADER_FIRST = {
    'tambola_header_1': 'Today\'s picks'
  };

  static const Map<String, int> _TAMBOLA_COST = {'tambolaCost': 500};
  static const Map<String, String> _TAMBOLA_HEADER_SECOND = {
    'tambola_header_2': 'Pull to see the other picks'
  };
  static const Map<String, String> _TAMBOLA_DAILY_PICK_COUNT = {
    'tambolaDailyPickCount': '3'
  };
  static const Map<String, String> _FORCE_MIN_BUILD_NUMBER_IOS = {
    'force_min_build_number_ios': '0'
  };
  static const Map<String, String> _FORCE_MIN_BUILD_NUMBER_ANDROID = {
    'force_min_build_number_android': '0'
  };
  static const Map<String, String> _FORCE_MIN_BUILD_NUMBER_IOS_2 = {
    'force_min_build_number_ios_2': '0'
  };
  static const Map<String, String> _FORCE_MIN_BUILD_NUMBER_ANDROID_2 = {
    'force_min_build_number_android_2': '0'
  };
  static const Map<String, String> _AMZ_VOUCHER_REDEMPTION = {
    'amz_voucher_redemption': '0'
  };
  static const Map<String, String> _DEPOSIT_UPI_ADDRESS = {
    'deposit_upi_address': '9769637379@okbizaxis'
  };
  static const Map<String, String> _PLAY_SCREEN_FIRST = {
    'play_screen_first': 'true'
  };
  static const Map<String, String> _CANDY_FIESTA_ONLINE = {
    'candy_fiesta_online': 'false'
  };
  static const Map<String, String> _TAMBOLA_WIN_CORNER = {
    'tambola_win_corner': '1000'
  };
  static const Map<String, String> _TAMBOLA_WIN_TOP = {
    'tambola_win_top': '5000'
  };
  static const Map<String, String> _TAMBOLA_WIN_MIDDLE = {
    'tambola_win_middle': '5000'
  };
  static const Map<String, String> _TAMBOLA_WIN_BOTTOM = {
    'tambola_win_bottom': '5000'
  };
  static const Map<String, String> _TAMBOLA_WIN_FULL = {
    'tambola_win_full': '25,000'
  };
  static const Map<String, String> _REFERRAL_BONUS = {'referralBonus': '25'};
  static const Map<String, String> _REFERRAL_TICKET_BONUS = {
    'referral_ticket_bonus': '10'
  };
  static const Map<String, String> _REFERRAL_FLC_BONUS = {
    'referralFlcBonus': '100'
  };
  static const Map<String, String> _AWS_ICICI_KEY_INDEX = {
    'aws_icici_key_index': '1'
  };
  static const Map<String, String> _AWS_AUGMONT_KEY_INDEX = {
    'aws_augmont_key_index': '1'
  };
  static const Map<String, String> _ICICI_DEPOSITS_ENABLED = {
    'icici_deposits_enabled': '0'
  };
  static const Map<String, String> _ICICI_DEPOSIT_PERMISSION = {
    'icici_deposit_permission': '0'
  };
  static const Map<String, String> _AUGMONT_DEPOSITS_ENABLED = {
    'augmont_deposits_enabled': '1'
  };
  static const Map<String, String> _AUGMONT_DEPOSIT_PERMISSION = {
    'augmont_deposit_permission': '1'
  };
  static const Map<String, String> _KYC_COMPLETION_PRIZE = {
    'kyc_completion_prize': 'You have won ₹50 and 10 tickets!'
  };
  static const Map<String, String> _UNLOCK_REFERRAL_AMT = {
    'unlock_referral_amt': '100'
  };

  static const Map<String, String> _WEEK_NUMBER = {'week_number': '12'};

  static const Map<String, String> _OCT_FEST_OFFER_TIMEOUT = {
    'oct_fest_offer_timeout': '10'
  };

  static const Map<String, String> _OCT_FEST_MIN_DEPOSIT = {
    'oct_fest_min_deposit': '100'
  };

  static const Map<String, String> _TAMBOLA_PLAY_COST = {
    'tambola_play_cost': '10'
  };
  static const Map<String, String> _TAMBOLA_PLAY_PRIZE = {
    'tambola_play_prize': '25,000'
  };
  static const Map<String, String> _FOOTBALL_PLAY_COST = {
    'football_play_cost': '10'
  };
  static const Map<String, String> _CRICKET_PLAY_COST = {
    'cricket_play_cost': '10'
  };
  static const Map<String, String> _CRICKET_PLAY_PRIZE = {
    'cricket_play_prize': '25,000'
  };
  static const Map<String, String> _FOOTBALL_PLAY_PRIZE = {
    'football_play_prize': '25,000'
  };

  static const Map<String, String> _CANDYFIESTA_PLAY_COST = {
    'candyfiesta_play_cost': '10'
  };
  static const Map<String, String> _CANDYFIESTA_PLAY_PRIZE = {
    'candyfiesta_play_prize': '25,000'
  };

  static const Map<String, String> _POOLCLUB_PLAY_COST = {
    'poolclub_play_cost': '10'
  };
  static const Map<String, String> _POOLCLUB_PLAY_PRIZE = {
    'poolclub_play_prize': '25,000'
  };

  static const Map<String, String> _FOOTBALL_THUMBNAIL_URI = {
    'football_thumbnail':
        'https://img.freepik.com/free-vector/gradient-football-field-background_52683-67789.jpg?t=st=1651147964~exp=1651148564~hmac=4d7297e0201d5f1513486c39fb6b0d0beeb2b5abbe8051ded63454464e438605&w=1800'
  };
  static const Map<String, String> _CANDYFIESTA_THUMBNAIL_URI = {
    'candyfiesta_thumbnail':
        'https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/games%2FCandy%20Fiesta-Thumbnail.jpg?alt=media&token=19bfc19e-2f1d-457a-8350-dec9674a8269'
  };
  static const Map<String, String> _CRICKET_THUMBNAIL_URI = {
    'cricket_thumbnail':
        'https://fello-assets.s3.ap-south-1.amazonaws.com/fello_cricket.png'
  };
  static const Map<String, String> _TAMBOLA_THUMBNAIL_URI = {
    'tambola_thumbnail':
        'https://fello-assets.s3.ap-south-1.amazonaws.com/fello_tambola.png'
  };

  static const Map<String, String> _POOLCLUB_THUMBNAIL_URI = {
    'poolclub_thumbnail':
        'https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/test%2Fpoolclub.png?alt=media&token=23403ec7-1c55-4ce7-827e-045ad6d059de'
  };

  static const Map<String, String> _GAME_POSITION = {
    'games_position': "FO-CR-PO-CA-TA"
  };

  static const Map<String, String> _NEW_USER_GAMES_ORDER = {
    'new_user_games_order': "FO-PO"
  };

  static const Map<String, String> _MIN_WITHDRAWABLE_PRIZE = {
    'minWithdrawablePrize': '100'
  };
  static const Map<String, String> _GAME_TAMBOLA_ANNOUNCEMENT = {
    'game_tambola_announcement':
        'Stand to win big prizes every week by matching your tickets! Winners are announced every Monday'
  };
  static const Map<String, String> _GAME_CRICKET_FPL_ANNOUNCEMENT = {
    'game_cricket_fpl_announcement': ''
  };
  static const Map<String, String> _GAME_CRICKET_ANNOUNCEMENT = {
    'game_cricket_announcement':
        'The highest scorers of the week win prizes every Sunday at midnight'
  };
  static const Map<String, String> _APP_SHARE_MSG = {
    'appShareMessage':
        'Hey I am gifting you ₹10 and 200 gaming tokens. Lets start saving and playing together ! '
  };
  static const Map<String, String> _RESTRICT_PAYTM_APP_INVOKE = {
    'restrict_paytm_app_invoke': 'false'
  };
  static const Map<String, int> _CACHE_INVALIDATION = {'invalidateBefore': 0};

  static const Map<String, String> _ACTIVE_PG_ANDROID = {
    'activePgAndroid': 'RZP-PG'
  };

  static const Map<String, String> _ACTIVE_PG_IOS = {'activePgIos': 'RZP-PG'};

  static const Map<String, String> _ENABLED_PSP_APPS = {
    'enabledPspApps': 'EGP'
  };

  static const Map<String, String> _PAYTM_PROD_MID = {'paytmMid': 'ppm'};

  static const Map<String, String> _PAYTM_DEV_MID = {'paytm_dev_mid': 'pdm'};

  static final Map<String, String> _RZP_PROD_MID = {
    'rzpMid': FlavorConfig.isDevelopment()
        ? 'rzp_test_UqHw6vJBbC8dR8'
        : 'rzp_live_RaxovywGPsLp2I'
  };

  static const Map<String, String> _RZP_DEV_MID = {'rzp_dev_mid': 'rdm'};

  static const Map<String, bool> _AUTOSAVE_ACTIVE = {'autosaveActive': false};
  static const Map<String, bool> _SHOW_NEW_AUTOSAVE = {'showNewAutosave': true};
  static const Map<String, List<String>> _YOUTUBE_VIDEOS = {
    'youtubeVideos': [
      "https://www.youtube.com/watchv=mzaIjBjUM1Y",
      "https://www.youtube.com/watch?v=CDokUdux0rc",
      "https://www.youtube.com/watch?v=zFhYJRqz_xk"
    ]
  };

  static const Map<String, List<String>> _TICKETS_YOUTUBE_VIDEOS = {
    'ticketsYoutubeVideos': [
      "https://www.youtube.com/watchv=mzaIjBjUM1Y",
      "https://www.youtube.com/watch?v=CDokUdux0rc",
      "https://www.youtube.com/watch?v=zFhYJRqz_xk"
    ]
  };

  static const Map<String, String> _APP_REFERRAL_MESSAGE = {
    "appReferralMessage":
        "Earn upto *₹20* and *200* tokens from every scratch card. Highest referrer wins an iPad every month"
  };

  static const Map<String, bool> _PAYMENT_BRIEF_VIEW = {
    "paymentBriefView": true
  };

  static const Map<String, bool> _USE_NEW_URL_FOR_USEROPS = {
    "useNewUrlUserOps": false
  };

  static const Map<String, bool> _SPECIAL_EFFECTS_ON_TXN_DETAILS_VIEW = {
    "specialEffectsOnTxnDetailsView": true
  };

  static const Map<String, double> _GOLD_PRO_INTEREST = {
    "goldProInterest": 2.75
  };

  static const Map<String, List<double>> _GOLDPRO_INVESTMENT_CHIPS = {
    "goldProInvestmentChips": [5.0, 10.0, 15.0, 20.0, 25.0]
  };

  static Map<String, dynamic> DEFAULTS = {
    ..._LOGIN_ASSET_URL,
    ..._DRAW_PICK_TIME,
    ..._TAMBOLA_HEADER_FIRST,
    ..._TAMBOLA_HEADER_SECOND,
    ..._TAMBOLA_COST,
    ..._TAMBOLA_DAILY_PICK_COUNT,
    ..._FORCE_MIN_BUILD_NUMBER_IOS,
    ..._FORCE_MIN_BUILD_NUMBER_ANDROID,
    ..._FORCE_MIN_BUILD_NUMBER_IOS_2,
    ..._FORCE_MIN_BUILD_NUMBER_ANDROID_2,
    ..._DEPOSIT_UPI_ADDRESS,
    ..._PLAY_SCREEN_FIRST,
    ..._TAMBOLA_WIN_CORNER,
    ..._TAMBOLA_WIN_TOP,
    ..._TAMBOLA_WIN_MIDDLE,
    ..._TAMBOLA_WIN_BOTTOM,
    ..._TAMBOLA_WIN_FULL,
    ..._REFERRAL_BONUS,
    ..._REFERRAL_TICKET_BONUS,
    ..._REFERRAL_FLC_BONUS,
    ..._AWS_ICICI_KEY_INDEX,
    ..._AWS_AUGMONT_KEY_INDEX,
    ..._ICICI_DEPOSITS_ENABLED,
    ..._ICICI_DEPOSIT_PERMISSION,
    ..._AUGMONT_DEPOSITS_ENABLED,
    ..._AUGMONT_DEPOSIT_PERMISSION,
    ..._KYC_COMPLETION_PRIZE,
    ..._UNLOCK_REFERRAL_AMT,
    ..._WEEK_NUMBER,
    ..._OCT_FEST_OFFER_TIMEOUT,
    ..._OCT_FEST_MIN_DEPOSIT,
    ..._TAMBOLA_PLAY_COST,
    ..._TAMBOLA_PLAY_PRIZE,
    ..._FOOTBALL_PLAY_COST,
    ..._CRICKET_PLAY_COST,
    ..._CRICKET_PLAY_PRIZE,
    ..._FOOTBALL_PLAY_PRIZE,
    ..._POOLCLUB_PLAY_COST,
    ..._POOLCLUB_PLAY_PRIZE,
    ..._CANDYFIESTA_PLAY_COST,
    ..._CANDYFIESTA_PLAY_PRIZE,
    ..._CANDY_FIESTA_ONLINE,
    ..._FOOTBALL_THUMBNAIL_URI,
    ..._CRICKET_THUMBNAIL_URI,
    ..._TAMBOLA_THUMBNAIL_URI,
    ..._POOLCLUB_THUMBNAIL_URI,
    ..._CANDYFIESTA_THUMBNAIL_URI,
    ..._MIN_WITHDRAWABLE_PRIZE,
    ..._GAME_TAMBOLA_ANNOUNCEMENT,
    ..._GAME_CRICKET_ANNOUNCEMENT,
    ..._GAME_CRICKET_FPL_ANNOUNCEMENT,
    ..._AMZ_VOUCHER_REDEMPTION,
    ..._APP_SHARE_MSG,
    ..._GAME_POSITION,
    ..._RESTRICT_PAYTM_APP_INVOKE,
    ..._NEW_USER_GAMES_ORDER,
    ..._CACHE_INVALIDATION,
    ..._ENABLED_PSP_APPS,
    ..._ACTIVE_PG_ANDROID,
    ..._ACTIVE_PG_IOS,
    ..._PAYTM_PROD_MID,
    ..._PAYTM_DEV_MID,
    ..._RZP_PROD_MID,
    ..._RZP_DEV_MID,
    ..._AUTOSAVE_ACTIVE,
    "changeAppIcon": false,
    ..._SHOW_NEW_AUTOSAVE,
    ..._YOUTUBE_VIDEOS,
    ..._APP_REFERRAL_MESSAGE,
    ..._PAYMENT_BRIEF_VIEW,
    ..._USE_NEW_URL_FOR_USEROPS,
    ..._SPECIAL_EFFECTS_ON_TXN_DETAILS_VIEW,
    ..._TICKETS_YOUTUBE_VIDEOS,
    ..._GOLD_PRO_INTEREST,
    ..._GOLDPRO_INVESTMENT_CHIPS
  };

  static Future<bool> init() async {
    final CustomLogger logger = locator<CustomLogger>();
    logger.i('initializing remote config');
    remoteConfig = RemoteConfig.instance;
    try {
      // await remoteConfig.activateFetched();
      //TODO remoteConfig lazy?

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(milliseconds: 30000),
        minimumFetchInterval: const Duration(seconds: 6),
      ));
      await remoteConfig.setDefaults(DEFAULTS);
      //RemoteConfigValue(null, ValueSource.valueStatic);
      await remoteConfig.fetchAndActivate();
      return true;
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
      if (_userService.baseUser?.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_type': 'Remote config details fetch failed',
          'error_msg': 'Remote config fetch failed, using default values.'
        };
        _internalOpsService.logFailure(
          _userService.baseUser!.uid,
          FailType.RemoteConfigFailed,
          errorDetails,
        );
      }
      return false;
    }
  }

  static String get LOGIN_ASSET_URL => _LOGIN_ASSET_URL.keys.first;
  static String get FORCE_MIN_BUILD_NUMBER_IOS =>
      _FORCE_MIN_BUILD_NUMBER_IOS.keys.first;

  static String get FORCE_MIN_BUILD_NUMBER_ANDROID =>
      _FORCE_MIN_BUILD_NUMBER_ANDROID.keys.first;

  static String get FORCE_MIN_BUILD_NUMBER_IOS_2 =>
      _FORCE_MIN_BUILD_NUMBER_IOS_2.keys.first;
  static String get FORCE_MIN_BUILD_NUMBER_ANDROID_2 =>
      _FORCE_MIN_BUILD_NUMBER_ANDROID_2.keys.first;

  static String get DRAW_PICK_TIME => _DRAW_PICK_TIME.keys.first;

  static String get KYC_COMPLETION_PRIZE => _KYC_COMPLETION_PRIZE.keys.first;

  static String get AUGMONT_DEPOSIT_PERMISSION =>
      _AUGMONT_DEPOSIT_PERMISSION.keys.first;

  static String get AUGMONT_DEPOSITS_ENABLED =>
      _AUGMONT_DEPOSITS_ENABLED.keys.first;

  static String get AMZ_VOUCHER_REDEMPTION =>
      _AMZ_VOUCHER_REDEMPTION.keys.first;

  static String get ICICI_DEPOSIT_PERMISSION =>
      _ICICI_DEPOSIT_PERMISSION.keys.first;

  static String get ICICI_DEPOSITS_ENABLED =>
      _ICICI_DEPOSITS_ENABLED.keys.first;

  static String get AWS_AUGMONT_KEY_INDEX => _AWS_AUGMONT_KEY_INDEX.keys.first;

  static String get AWS_ICICI_KEY_INDEX => _AWS_ICICI_KEY_INDEX.keys.first;

  static String get REFERRAL_TICKET_BONUS => _REFERRAL_TICKET_BONUS.keys.first;

  static String get REFERRAL_BONUS => _REFERRAL_BONUS.keys.first;

  static String get REFERRAL_FLC_BONUS => _REFERRAL_FLC_BONUS.keys.first;

  static String get TAMBOLA_WIN_FULL => _TAMBOLA_WIN_FULL.keys.first;

  static String get TAMBOLA_WIN_BOTTOM => _TAMBOLA_WIN_BOTTOM.keys.first;

  static String get TAMBOLA_WIN_MIDDLE => _TAMBOLA_WIN_MIDDLE.keys.first;

  static String get TAMBOLA_WIN_TOP => _TAMBOLA_WIN_TOP.keys.first;

  static String get TAMBOLA_WIN_CORNER => _TAMBOLA_WIN_CORNER.keys.first;

  static String get TAMBOLA_DAILY_PICK_COUNT =>
      _TAMBOLA_DAILY_PICK_COUNT.keys.first;

  static String get PLAY_SCREEN_FIRST => _PLAY_SCREEN_FIRST.keys.first;

  static String get DEPOSIT_UPI_ADDRESS => _DEPOSIT_UPI_ADDRESS.keys.first;

  static String get TAMBOLACOST => _TAMBOLA_COST.keys.first;
  static String get TAMBOLA_HEADER_SECOND => _TAMBOLA_HEADER_SECOND.keys.first;

  static String get TAMBOLA_HEADER_FIRST => _TAMBOLA_HEADER_FIRST.keys.first;

  static String get WEEK_NUMBER => _WEEK_NUMBER.keys.first;

  static String get OCT_FEST_OFFER_TIMEOUT =>
      _OCT_FEST_OFFER_TIMEOUT.keys.first;

  static String get OCT_FEST_MIN_DEPOSIT => _OCT_FEST_MIN_DEPOSIT.keys.first;

  static String get TAMBOLA_PLAY_COST => _TAMBOLA_PLAY_COST.keys.first;

  static String get TAMBOLA_PLAY_PRIZE => _TAMBOLA_PLAY_PRIZE.keys.first;

  static String get FOOTBALL_PLAY_COST => _FOOTBALL_PLAY_COST.keys.first;

  static String get CANDYFIESTA_PLAY_PRIZE =>
      _CANDYFIESTA_PLAY_PRIZE.keys.first;

  static String get CANDY_FIESTA_ONLINE => _CANDY_FIESTA_ONLINE.keys.first;

  static String get CANDYFIESTA_PLAY_COST => _CANDYFIESTA_PLAY_COST.keys.first;

  static String get CRICKET_PLAY_COST => _CRICKET_PLAY_COST.keys.first;

  static String get FOOTBALL_PLAY_PRIZE => _FOOTBALL_PLAY_PRIZE.keys.first;

  static String get CRICKET_PLAY_PRIZE => _CRICKET_PLAY_PRIZE.keys.first;

  static String get POOLCLUB_PLAY_COST => _POOLCLUB_PLAY_COST.keys.first;

  static String get POOLCLUB_PLAY_PRIZE => _POOLCLUB_PLAY_PRIZE.keys.first;

  static String get FOOTBALL_THUMBNAIL_URI =>
      _FOOTBALL_THUMBNAIL_URI.keys.first;

  static String get CRICKET_THUMBNAIL_URI => _CRICKET_THUMBNAIL_URI.keys.first;

  static String get TAMBOLA_THUMBNAIL_URI => _TAMBOLA_THUMBNAIL_URI.keys.first;

  static String get CANDYFIESTA_THUMBNAIL_URI =>
      _CANDYFIESTA_THUMBNAIL_URI.keys.first;

  static String get POOLCLUB_THUMBNAIL_URI =>
      _POOLCLUB_THUMBNAIL_URI.keys.first;

  static String get UNLOCK_REFERRAL_AMT => _UNLOCK_REFERRAL_AMT.keys.first;

  static String get MIN_WITHDRAWABLE_PRIZE =>
      _MIN_WITHDRAWABLE_PRIZE.keys.first;

  static String get GAME_TAMBOLA_ANNOUNCEMENT =>
      _GAME_TAMBOLA_ANNOUNCEMENT.keys.first;

  static String get GAME_CRICKET_ANNOUNCEMENT =>
      _GAME_CRICKET_ANNOUNCEMENT.keys.first;

  static String get GAME_CRICKET_FPL_ANNOUNCEMENT =>
      _GAME_CRICKET_FPL_ANNOUNCEMENT.keys.first;

  static String get APP_SHARE_MSG => _APP_SHARE_MSG.keys.first;

  static String get GAME_POSITION => _GAME_POSITION.keys.first;

  static String get RESTRICT_PAYTM_APP_INVOKE =>
      _RESTRICT_PAYTM_APP_INVOKE.keys.first;

  static String get NEW_USER_GAMES_ORDER => _NEW_USER_GAMES_ORDER.keys.first;

  static String get ACTIVE_PG_ANDROID => _ACTIVE_PG_ANDROID.keys.first;

  static String get ACTIVE_PG_IOS => _ACTIVE_PG_IOS.keys.first;

  static String get ENABLED_PSP_APPS => _ENABLED_PSP_APPS.keys.first;

  static String get PATYM_PROD_MID => _PAYTM_PROD_MID.keys.first;

  static String get PATYM_DEV_MID => _PAYTM_DEV_MID.keys.first;

  static String get RZP_PROD_MID => _RZP_PROD_MID.keys.first;

  static String get RZP_DEV_MID => _RZP_DEV_MID.keys.first;

  static bool get AUTOSAVE_ACTIVE =>
      remoteConfig.getBool(_AUTOSAVE_ACTIVE.keys.first);

  static bool get USE_NEW_URL_FOR_USEROPS =>
      remoteConfig.getBool(_USE_NEW_URL_FOR_USEROPS.keys.first);

  static String get APP_REFERRAL_MESSAGE =>
      remoteConfig.getString(_APP_REFERRAL_MESSAGE.keys.first);

  static bool get PAYMENT_BRIEF_VIEW =>
      remoteConfig.getBool(_PAYMENT_BRIEF_VIEW.keys.first);

  static bool get SPECIAL_EFFECTS_ON_TXN_DETAILS_VIEW =>
      remoteConfig.getBool(_SPECIAL_EFFECTS_ON_TXN_DETAILS_VIEW.keys.first);

  static double get GOLD_PRO_INTEREST =>
      remoteConfig.getDouble(_GOLD_PRO_INTEREST.keys.first);

  static int get invalidationBefore {
    return remoteConfig.getInt(_CACHE_INVALIDATION.keys.first);
  }
}
