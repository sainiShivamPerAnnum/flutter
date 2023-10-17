import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps until there is find against the [finder] or function has not hit the
/// [timeout] duration.
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();

    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

/// A helper extensions for mapping any key to the finder.
extension FinderMapperExtension on Key {
  /// Maps a key to finder by using [find].
  Finder get mapToFinder => find.byKey(this);
}
