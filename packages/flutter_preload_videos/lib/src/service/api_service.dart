import '../core/constants.dart';

class ApiService {
  static final List<String> _videos = [
    'https://ik.imagekit.io/9xfwtu0xm/Stories/safety.mp4?updatedAt=1704869029986',
    'https://ik.imagekit.io/9xfwtu0xm/Stories/rewards.mp4?updatedAt=1704869015848',
    'https://ik.imagekit.io/9xfwtu0xm/Stories/digital_gold.mp4?updatedAt=1704868996019',
    'https://ik.imagekit.io/9xfwtu0xm/Stories/fello_p2p.mp4?updatedAt=1716804779987',
    'https://ik.imagekit.io/9xfwtu0xm/Stories/know_fello.mp4?updatedAt=1716805219579',
  ];


  /// Simulate api call
  static Future<List<String>> getVideos({int id = 0}) async {
    if (id >= _videos.length) return [];

    await Future.delayed(Duration(seconds: VideoPreloadConstants.latency));

    if (id + VideoPreloadConstants.nextLimit >= _videos.length) {
      return _videos.sublist(id, _videos.length);
    }

    return _videos.sublist(id, id + VideoPreloadConstants.nextLimit);
  }
}
