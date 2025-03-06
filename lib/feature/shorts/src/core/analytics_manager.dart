import 'dart:convert';

import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/src/core/interaction_enum.dart';
import 'package:felloapp/feature/shorts/src/service/shorts_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:video_player/video_player.dart';

class AnalyticsRetryManager {
  static const String _queueKey = 'analytics_retry_queue';

  /// Add an analytics event to the retry queue
  static Future<void> queueAnalyticsEvent({
    required String videoId,
    required InteractionType interaction,
    required String theme,
    required String category,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve existing queue
      List<Map<String, dynamic>> queue = _getExistingQueue(prefs);

      // Add new event to queue
      queue.add({
        'videoId': videoId,
        'interaction': interaction.toString(),
        'theme': theme,
        'category': category,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Save updated queue
      await prefs.setString(_queueKey, json.encode(queue));
    } catch (e) {
      debugPrint('Error queueing analytics event: $e');
    }
  }

  /// Retry queued analytics events
  static Future<void> pushQueuedEvents(ShortsRepo repository) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve existing queue
      List<Map<String, dynamic>> queue = _getExistingQueue(prefs);

      // Create a copy to iterate over
      final List<Map<String, dynamic>> queueCopy = List.from(queue);

      // Track successful events to remove
      List<Map<String, dynamic>> successfulEvents = [];

      for (final event in queueCopy) {
        try {
          // Convert interaction string back to enum
          final interaction = InteractionType.values
              .firstWhere((e) => e.toString() == event['interaction']);

          // Attempt to send the event
          final result = await repository.updateInteraction(
            videoId: event['videoId'],
            theme: event['theme'],
            category: event['category'],
            interaction: interaction,
          );

          // If successful, mark for removal
          if (result.isSuccess()) {
            successfulEvents.add(event);
          }
        } catch (e) {
          debugPrint('Error retrying analytics event: $e');
        }
      }

      // Remove successful events from the queue
      queue.removeWhere(
        (event) => successfulEvents.any(
          (successful) =>
              successful['videoId'] == event['videoId'] &&
              successful['interaction'] == event['interaction'],
        ),
      );

      // Update or clear the queue
      if (queue.isEmpty) {
        await prefs.remove(_queueKey);
      } else {
        await prefs.setString(_queueKey, json.encode(queue));
      }
    } catch (e) {
      debugPrint('Error in retrying queued events: $e');
    }
  }

  /// Helper method to get existing queue
  static List<Map<String, dynamic>> _getExistingQueue(SharedPreferences prefs) {
    final queueString = prefs.getString(_queueKey);
    if (queueString != null) {
      try {
        final List<dynamic> decoded = json.decode(queueString);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        debugPrint('Error decoding queue: $e');
        return [];
      }
    }
    return [];
  }
}

extension PreloadBlocAnalyticsRetry on PreloadBloc {
  void trackAnalytics(
    VideoPlayerController controller,
    String videoId,
    String theme,
    String category,
  ) {
    final duration = controller.value.duration;
    final position = controller.value.position;

    try {
      if (duration.inMilliseconds > 0) {
        // 50% watched
        if (position.inMilliseconds >= duration.inMilliseconds * 0.50) {
          AnalyticsRetryManager.queueAnalyticsEvent(
            videoId: videoId,
            interaction: InteractionType.watched,
            theme: theme,
            category: category,
          );
        } else

        // Skipped (less than 3 seconds)
        if (position.inMilliseconds < 3 * 1000) {
          AnalyticsRetryManager.queueAnalyticsEvent(
            videoId: videoId,
            interaction: InteractionType.skipped,
            theme: theme,
            category: category,
          );
        } else

        // Viewed (more than 3 seconds)
        if (position.inMilliseconds >= 3 * 1000) {
          AnalyticsRetryManager.queueAnalyticsEvent(
            videoId: videoId,
            interaction: InteractionType.viewed,
            theme: theme,
            category: category,
          );
        }
      }
      AnalyticsRetryManager.pushQueuedEvents(locator());
    } catch (e) {
      debugPrint('Error tracking analytics: $e');
    }
  }
}
