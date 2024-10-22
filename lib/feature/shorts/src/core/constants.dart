class VideoPreloadConstants {
  static const int kPreloadLimit = 3;
  static const int kNextLimit = 5;
  static const int kLatency = 1;

  static int preloadLimit = kPreloadLimit;
  static int nextLimit = kNextLimit;
  static int latency = kLatency;

  static void updateConstants({
    int? preloadLimit,
    int? nextLimit,
    int? latency,
  }) {
    VideoPreloadConstants.preloadLimit = preloadLimit ?? kPreloadLimit;
    VideoPreloadConstants.nextLimit = nextLimit ?? kNextLimit;
    VideoPreloadConstants.latency = latency ?? kLatency;
  }
}