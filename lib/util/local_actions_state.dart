import 'package:felloapp/util/preference_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LocalActionsState {
  static const int ttl = 7200000;

  static Future cleanupCache() async {
    final allKeys = PreferenceHelper.getKeys();
    final timestampKeys =
        allKeys.where((key) => key.endsWith('_timestamp')).toList();

    for (final String timestampKey in timestampKeys) {
      final timestamp = PreferenceHelper.getInt(timestampKey);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (timestamp == 0) continue;

      if (currentTime - timestamp > ttl) {
        final baseKey = timestampKey.substring(
          0,
          timestampKey.length - '_timestamp'.length,
        );
        await PreferenceHelper.remove(baseKey);
        await PreferenceHelper.remove(timestampKey);
      }
    }
  }

  static Future<void> setVideoLiked(String videoId, bool isLiked) async {
    final key = 'video_${videoId}_liked';
    final timestampKey = 'video_${videoId}_liked_timestamp';

    await PreferenceHelper.setBool(key, isLiked);
    await PreferenceHelper.setInt(
      timestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static bool getVideoLiked(String videoId, bool apiResponse) {
    final key = 'video_${videoId}_liked';
    final timestampKey = 'video_${videoId}_liked_timestamp';

    if (!PreferenceHelper.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = PreferenceHelper.getInt(timestampKey);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      PreferenceHelper.remove(key);
      PreferenceHelper.remove(timestampKey);
      return apiResponse;
    }

    return PreferenceHelper.getBool(key, def: apiResponse);
  }

  static Future<void> setAdvisorFollowed(
    String advisorId,
    bool isFollowed,
  ) async {
    final key = 'advisor_${advisorId}_follow';
    final timestampKey = 'advisor_${advisorId}_follow_timestamp';

    await PreferenceHelper.setBool(key, isFollowed);
    await PreferenceHelper.setInt(
      timestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static bool getAdvisorFollowed(
    String advisorId,
    bool apiResponse,
  ) {
    final key = 'advisor_${advisorId}_follow';
    final timestampKey = 'advisor_${advisorId}_follow_timestamp';

    if (!PreferenceHelper.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = PreferenceHelper.getInt(timestampKey);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      PreferenceHelper.remove(key);
      PreferenceHelper.remove(timestampKey);
      return apiResponse;
    }

    return PreferenceHelper.getBool(key, def: apiResponse);
  }

  static Future<void> setVideoSaved(String videoId, bool isSaved) async {
    final key = 'video_${videoId}_saved';
    final timestampKey = 'video_${videoId}_saved_timestamp';

    await PreferenceHelper.setBool(key, isSaved);
    await PreferenceHelper.setInt(
      timestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static bool getVideoSaved(String videoId, bool apiResponse) {
    final key = 'video_${videoId}_saved';
    final timestampKey = 'video_${videoId}_saved_timestamp';

    if (!PreferenceHelper.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = PreferenceHelper.getInt(timestampKey);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      PreferenceHelper.remove(key);
      PreferenceHelper.remove(timestampKey);
      return apiResponse;
    }

    return PreferenceHelper.getBool(key, def: apiResponse);
  }

  static Future<void> setAdvisorSaved(String advisorId, bool isSaved) async {
    final key = 'advisor_${advisorId}_saved';
    final timestampKey = 'advisor_${advisorId}_saved_timestamp';

    await PreferenceHelper.setBool(key, isSaved);
    await PreferenceHelper.setInt(
      timestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<bool> getAdvisorSaved(
    String advisorId,
    bool apiResponse,
  ) async {
    final key = 'advisor_${advisorId}_saved';
    final timestampKey = 'advisor_${advisorId}_saved_timestamp';

    if (!PreferenceHelper.containsKey(key)) {
      return apiResponse;
    }

    final timestamp = PreferenceHelper.getInt(timestampKey);
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - timestamp > ttl) {
      await PreferenceHelper.remove(key);
      await PreferenceHelper.remove(timestampKey);
      return apiResponse;
    }

    return PreferenceHelper.getBool(key, def: apiResponse);
  }
}
