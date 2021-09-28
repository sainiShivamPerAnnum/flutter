import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';

class BaseRemoteConfig {
  static RemoteConfig remoteConfig;
  static DBModel _dbProvider = locator<DBModel>();
  static BaseUtil _baseProvider = locator<BaseUtil>();

  ///Each config is set as a map = {name, default value}
  static const Map<String, String> _DRAW_PICK_TIME = {'draw_pick_time': '18'};
  static const Map<String, String> _TAMBOLA_HEADER_FIRST = {
    'tambola_header_1': 'Today\'s picks'
  };
  static const Map<String, String> _TAMBOLA_HEADER_SECOND = {
    'tambola_header_2': 'Pull to see the other picks'
  };
  static const Map<String, String> _TAMBOLA_DAILY_PICK_COUNT = {
    'tambola_daily_pick_count': '5'
  };
  static const Map<String, String> _FORCE_MIN_BUILD_NUMBER = {
    'force_min_build_number': '0'
  };
  static const Map<String, String> _DEPOSIT_UPI_ADDRESS = {
    'deposit_upi_address': '9769637379@okbizaxis'
  };
  static const Map<String, String> _PLAY_SCREEN_FIRST = {
    'play_screen_first': 'true'
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
  static const Map<String, String> _REFERRAL_BONUS = {'referral_bonus': '25'};
  static const Map<String, String> _REFERRAL_TICKET_BONUS = {
    'referral_ticket_bonus': '10'
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
    'kyc_completion_prize': 'You have won ₹50 and 10 Tambola tickets!'
  };
  static const Map<String, String> _UNLOCK_REFERRAL_AMT = {
    'min_principle_for_prize': '100'
  };

  static const Map<String, String> _WEEK_NUMBER = {'week_number': '12'};

  static const Map<String, dynamic> DEFAULTS = {
    ..._DRAW_PICK_TIME,
    ..._TAMBOLA_HEADER_FIRST,
    ..._TAMBOLA_HEADER_SECOND,
    ..._TAMBOLA_DAILY_PICK_COUNT,
    ..._FORCE_MIN_BUILD_NUMBER,
    ..._DEPOSIT_UPI_ADDRESS,
    ..._PLAY_SCREEN_FIRST,
    ..._TAMBOLA_WIN_CORNER,
    ..._TAMBOLA_WIN_TOP,
    ..._TAMBOLA_WIN_MIDDLE,
    ..._TAMBOLA_WIN_BOTTOM,
    ..._TAMBOLA_WIN_FULL,
    ..._REFERRAL_BONUS,
    ..._REFERRAL_TICKET_BONUS,
    ..._AWS_ICICI_KEY_INDEX,
    ..._AWS_AUGMONT_KEY_INDEX,
    ..._ICICI_DEPOSITS_ENABLED,
    ..._ICICI_DEPOSIT_PERMISSION,
    ..._AUGMONT_DEPOSITS_ENABLED,
    ..._AUGMONT_DEPOSIT_PERMISSION,
    ..._KYC_COMPLETION_PRIZE,
    ..._UNLOCK_REFERRAL_AMT,
    ..._WEEK_NUMBER,
  };

  static Future<bool> init() async {
    final Logger logger = locator<Logger>();
    logger.i('initializing remote config');
    remoteConfig = RemoteConfig.instance;
    try {
      // await remoteConfig.activateFetched();
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(milliseconds: 30000),
        minimumFetchInterval: const Duration(hours: 6),
      ));
      await remoteConfig.setDefaults(DEFAULTS);
      //RemoteConfigValue(null, ValueSource.valueStatic);
      await remoteConfig.fetchAndActivate();
      return true;
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
      if (_baseProvider.myUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_type': 'Remote config details fetch failed',
          'error_msg': 'Remote config fetch failed, using default values.'
        };
        _dbProvider.logFailure(_baseProvider.myUser.uid,
            FailType.RemoteConfigFailed, errorDetails);
      }
      return false;
    }
  }

  static String get FORCE_MIN_BUILD_NUMBER =>
      _FORCE_MIN_BUILD_NUMBER.keys.first;

  static String get DRAW_PICK_TIME => _DRAW_PICK_TIME.keys.first;

  static String get KYC_COMPLETION_PRIZE => _KYC_COMPLETION_PRIZE.keys.first;

  static String get AUGMONT_DEPOSIT_PERMISSION =>
      _AUGMONT_DEPOSIT_PERMISSION.keys.first;

  static String get AUGMONT_DEPOSITS_ENABLED =>
      _AUGMONT_DEPOSITS_ENABLED.keys.first;

  static String get ICICI_DEPOSIT_PERMISSION =>
      _ICICI_DEPOSIT_PERMISSION.keys.first;

  static String get ICICI_DEPOSITS_ENABLED =>
      _ICICI_DEPOSITS_ENABLED.keys.first;

  static String get AWS_AUGMONT_KEY_INDEX => _AWS_AUGMONT_KEY_INDEX.keys.first;

  static String get AWS_ICICI_KEY_INDEX => _AWS_ICICI_KEY_INDEX.keys.first;

  static String get REFERRAL_TICKET_BONUS => _REFERRAL_TICKET_BONUS.keys.first;

  static String get REFERRAL_BONUS => _REFERRAL_BONUS.keys.first;

  static String get TAMBOLA_WIN_FULL => _TAMBOLA_WIN_FULL.keys.first;

  static String get TAMBOLA_WIN_BOTTOM => _TAMBOLA_WIN_BOTTOM.keys.first;

  static String get TAMBOLA_WIN_MIDDLE => _TAMBOLA_WIN_MIDDLE.keys.first;

  static String get TAMBOLA_WIN_TOP => _TAMBOLA_WIN_TOP.keys.first;

  static String get TAMBOLA_WIN_CORNER => _TAMBOLA_WIN_CORNER.keys.first;

  static String get TAMBOLA_DAILY_PICK_COUNT =>
      _TAMBOLA_DAILY_PICK_COUNT.keys.first;

  static String get PLAY_SCREEN_FIRST => _PLAY_SCREEN_FIRST.keys.first;

  static String get DEPOSIT_UPI_ADDRESS => _DEPOSIT_UPI_ADDRESS.keys.first;

  static String get TAMBOLA_HEADER_SECOND => _TAMBOLA_HEADER_SECOND.keys.first;

  static String get TAMBOLA_HEADER_FIRST => _TAMBOLA_HEADER_FIRST.keys.first;

  static String get WEEK_NUMBER => _WEEK_NUMBER.keys.first;

  static int get UNLOCK_REFERRAL_AMT {
    String _val = _UNLOCK_REFERRAL_AMT.keys.first;
    if (_val != null || _val.isNotEmpty) {
      int iVal = BaseUtil.toInt(_val);
      return (iVal > 0) ? iVal : 100;
    }
    return 100;
  }
}
