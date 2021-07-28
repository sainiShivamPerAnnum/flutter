import 'package:felloapp/base_util.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class BaseRemoteConfig {
  static RemoteConfig remoteConfig;

  ///Each config is set as a map = {name, default value}
  static const Map<String, String> _DRAW_PICK_TIME = {'draw_pick_time': '18'};
  static const Map<String, String> _TAMBOLA_HEADER_FIRST = {
    'tambola_header_1': 'Today\'s picks'
  };
  static const Map<String, String> _TAMBOLA_HEADER_SECOND = {
    'tambola_header_2': 'Click to see the other picks'
  };
  static const Map<String, String> _DEPOSIT_UPI_ADDRESS = {
    'deposit_upi_address': '9769637379@okbizaxis'
  };
  static const Map<String, String> _PLAY_SCREEN_FIRST = {
    'play_screen_first': 'true'
  };
  static const Map<String, String> _TAMBOLA_WIN_CORNER = {
    'tambola_win_corner': '500'
  };
  static const Map<String, String> _TAMBOLA_WIN_TOP = {
    'tambola_win_top': '1500'
  };
  static const Map<String, String> _TAMBOLA_WIN_MIDDLE = {
    'tambola_win_middle': '1500'
  };
  static const Map<String, String> _TAMBOLA_WIN_BOTTOM = {
    'tambola_win_bottom': '1500'
  };
  static const Map<String, String> _TAMBOLA_WIN_FULL = {
    'tambola_win_full': '10,000'
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
    'icici_deposits_enabled': '1'
  };
  static const Map<String, String> _ICICI_DEPOSIT_PERMISSION = {
    'icici_deposit_permission': '1'
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

  static const Map<String, dynamic> DEFAULTS = {
    ..._DRAW_PICK_TIME,
    ..._TAMBOLA_HEADER_FIRST,
    ..._TAMBOLA_HEADER_SECOND,
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
    ..._UNLOCK_REFERRAL_AMT
  };

  static Future<bool> init() async {
    print('initializing remote config');
    remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(DEFAULTS);
    try {
      // Fetches every 6 hrs
      await remoteConfig.fetch();
      await remoteConfig.activateFetched();
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeoutMillis: 30000,
        minimumFetchIntervalMillis: 21600000,
      ));
      return true;
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
      return false;
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
      return false;
    }
  }

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

  static String get PLAY_SCREEN_FIRST => _PLAY_SCREEN_FIRST.keys.first;

  static String get DEPOSIT_UPI_ADDRESS => _DEPOSIT_UPI_ADDRESS.keys.first;

  static String get TAMBOLA_HEADER_SECOND => _TAMBOLA_HEADER_SECOND.keys.first;

  static String get TAMBOLA_HEADER_FIRST => _TAMBOLA_HEADER_FIRST.keys.first;

  static int get UNLOCK_REFERRAL_AMT {
    String _val = _UNLOCK_REFERRAL_AMT.keys.first;
    if (_val != null || _val.isNotEmpty) {
      int iVal = BaseUtil.toInt(_val);
      return (iVal > 0) ? iVal : 100;
    }
    return 100;
  }
}
