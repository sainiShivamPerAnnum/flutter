import 'dart:convert';

import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/src/core/interaction_enum.dart';
import 'package:felloapp/feature/shorts/src/service/shorts_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';
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
      // Retrieve existing queue
      List<Map<String, dynamic>> queue = _getExistingQueue();

      // Check if an event for this videoId already exists
      final existingEvent = queue.firstWhere(
        (event) => event['videoId'] == videoId,
        orElse: () => {}, // Return an empty map if not found
      );

      if (existingEvent.isNotEmpty) {
        // If the existing event is 'skipped' and the new event is 'watched', overwrite it
        if (existingEvent['interaction'] ==
                InteractionType.skipped.toString() &&
            interaction == InteractionType.watched) {
          // Remove the skipped event and add the new watched event
          queue.remove(existingEvent);
        } else {
          // If it's watched, do nothing (watched should not be overridden)
          if (existingEvent['interaction'] ==
              InteractionType.watched.toString()) {
            return;
          }
        }
      }

      // Add new event to queue
      queue.add({
        'videoId': videoId,
        'interaction': interaction.toString(),
        'theme': theme,
        'category': category,
        'timestamp': DateTime.now().toIso8601String(),
      });

      List<String> stringList = queue.map((item) => json.encode(item)).toList();
      await PreferenceHelper.setStringList(_queueKey, stringList);
    } catch (e) {
      debugPrint('Error queueing analytics event: $e');
    }
  }

  /// Retry queued analytics events
  static Future<void> pushQueuedEvents(ShortsRepo repository) async {
    try {
      // Retrieve existing queue
      List<Map<String, dynamic>> queue = _getExistingQueue();

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
        await PreferenceHelper.remove(_queueKey);
      } else {
        List<String> stringList =
            queue.map((item) => json.encode(item)).toList();
        await PreferenceHelper.setStringList(_queueKey, stringList);
      }
    } catch (e) {
      debugPrint('Error in retrying queued events: $e');
    }
  }

  /// Helper method to get existing queue
  static List<Map<String, dynamic>> _getExistingQueue() {
    if (!PreferenceHelper.containsKey(_queueKey)) {
      return [];
    }
    final List<String> stringList = PreferenceHelper.getStringList(_queueKey);
    if (stringList.isEmpty) {
      return [];
    }
    try {
      return stringList.map((itemString) {
        return json.decode(itemString) as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      debugPrint('Error decoding analytics queue: $e');
      return [];
    }
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
        // Skipped (less than 3 seconds)
        if (position.inMilliseconds < 3 * 1000) {
          AnalyticsRetryManager.queueAnalyticsEvent(
            videoId: videoId,
            interaction: InteractionType.skipped,
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
