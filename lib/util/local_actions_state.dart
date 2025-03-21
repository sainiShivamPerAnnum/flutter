import 'package:shared_preferences/shared_preferences.dart';

class LocalActionsState {
  static const int ttl = 7200000;
  static SharedPreferences? _prefs;

  static Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> cleanupCache() async {
    await _init();
    final keys = _prefs!.getKeys();

    for (final String key in keys) {
      final timestampKey = '${key}_timestamp';
      final timestamp = _prefs!.getInt(timestampKey) ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime - timestamp > ttl) {
        await _prefs!.remove(key);
        await _prefs!.remove(timestampKey);
      }
    }
  }

  static Future<void> setVideoLiked(String videoId, bool isLiked) async {
    final key = 'video_${videoId}_liked';
    final timestampKey = 'video_${videoId}_liked_timestamp';

    await _prefs!.setBool(key, isLiked);
    await _prefs!.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  static bool getVideoLiked(String videoId, bool apiResponse) {
    final key = 'video_${videoId}_liked';
    final timestampKey = 'video_${videoId}_liked_timestamp';

    if (!_prefs!.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = _prefs!.getInt(timestampKey) ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      _prefs!.remove(key);
      _prefs!.remove(timestampKey);
      return apiResponse;
    }

    return _prefs!.getBool(key) ?? apiResponse;
  }

  static Future<void> setAdvisorFollowed(
    String advisorId,
    bool isFollowed,
  ) async {
    final key = 'advisor_${advisorId}_follow';
    final timestampKey = 'advisor_${advisorId}_follow_timestamp';

    await _prefs!.setBool(key, isFollowed);
    await _prefs!.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  static bool getAdvisorFollowed(
    String advisorId,
    bool apiResponse,
  ) {
    final key = 'advisor_${advisorId}_follow';
    final timestampKey = 'advisor_${advisorId}_follow_timestamp';

    if (!_prefs!.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = _prefs!.getInt(timestampKey) ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      _prefs!.remove(key);
      _prefs!.remove(timestampKey);
      return apiResponse;
    }

    return _prefs!.getBool(key) != null ? _prefs!.getBool(key)! : apiResponse;
  }

  static Future<void> setVideoSaved(String videoId, bool isSaved) async {
    final key = 'video_${videoId}_saved';
    final timestampKey = 'video_${videoId}_saved_timestamp';

    await _prefs!.setBool(key, isSaved);
    await _prefs!.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  static bool getVideoSaved(String videoId, bool apiResponse) {
    final key = 'video_${videoId}_saved';
    final timestampKey = 'video_${videoId}_saved_timestamp';

    if (!_prefs!.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = _prefs!.getInt(timestampKey) ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      _prefs!.remove(key);
      _prefs!.remove(timestampKey);
      return apiResponse;
    }

    return _prefs!.getBool(key) != null ? _prefs!.getBool(key)! : apiResponse;
  }

  static Future<void> setAdvisorSaved(String advisorId, bool isSaved) async {
    final key = 'advisor_${advisorId}_saved';
    final timestampKey = 'advisor_${advisorId}_saved_timestamp';

    await _prefs!.setBool(key, isSaved);
    await _prefs!.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> getAdvisorSaved(
    String advisorId,
    bool apiResponse,
  ) async {
    final key = 'advisor_${advisorId}_saved';
    final timestampKey = 'advisor_${advisorId}_saved_timestamp';

    if (!_prefs!.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = _prefs!.getInt(timestampKey) ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      await _prefs!.remove(key);
      await _prefs!.remove(timestampKey);
      return apiResponse;
    }

    return _prefs!.getBool(key) != null ? _prefs!.getBool(key)! : apiResponse;
  }
}
