import '../core/constants.dart';

class VideoData {
  final String url;
  final String title;
  final String author;
  final String subtitle;
  final int views;
  final String duration;
  final List<Map<String, dynamic>> comments;
  final Set<String> categories;

  VideoData({
    required this.url,
    required this.title,
    required this.author,
    required this.subtitle,
    required this.views,
    required this.duration,
    required this.comments,
    required this.categories,
  });
}

class ApiService {
  // static final List<String> _videos = [
  //   'https://ik.imagekit.io/9xfwtu0xm/Stories/safety.mp4?updatedAt=1704869029986',
  //   'https://ik.imagekit.io/9xfwtu0xm/Stories/rewards.mp4?updatedAt=1704869015848',
  //   'https://ik.imagekit.io/9xfwtu0xm/Stories/digital_gold.mp4?updatedAt=1704868996019',
  //   'https://ik.imagekit.io/9xfwtu0xm/Stories/fello_p2p.mp4?updatedAt=1716804779987',
  //   'https://ik.imagekit.io/9xfwtu0xm/Stories/know_fello.mp4?updatedAt=1716805219579',
  // ];

  static Future<List<VideoData>> getVideos({int id = 0}) async {
    // Simulated delay to mimic API call latency
    await Future.delayed(Duration(seconds: VideoPreloadConstants.latency));

    // Mock API data based on the given structure, including video details
    List<VideoData> videos = [
      VideoData(
        url: 'https://d18gbwu7fwwwtf.cloudfront.net/fello-experts/Introduction.mp4',
        title: 'Lorem Ipsum is simply dummy text ',
        author: 'John Doe',
        subtitle: 'Exploring safety protocols',
        views: 150,
        duration: '5:00',
        comments: [
          {
            'comment': 'Great video!,Great video! Great video! Great video! Great video!',
            'name': 'Devanshu Verma',
            'timestamp': '5 days ago',
            'image': 'https://ik.imagekit.io/9xfwtu0xm/experts/live1.png'
          },
          {
            'comment': 'Great video!',
            'name': 'Devanshu Verma',
            'timestamp': '5 days ago',
            'image': 'https://ik.imagekit.io/9xfwtu0xm/experts/live1.png'
          },
          {
            'comment': 'Great video!',
            'name': 'Devanshu Verma',
            'timestamp': '5 days ago',
            'image': 'https://ik.imagekit.io/9xfwtu0xm/experts/live1.png'
          },
           {
            'comment': 'Great video!',
            'name': 'Devanshu Verma',
            'timestamp': '5 days ago',
            'image': 'https://ik.imagekit.io/9xfwtu0xm/experts/live1.png'
          },
           {
            'comment': 'Great video!',
            'name': 'Devanshu Verma',
            'timestamp': '5 days ago',
            'image': 'https://ik.imagekit.io/9xfwtu0xm/experts/live1.png'
          }
        ],
        categories: {'Health', 'Safety'},
      ),
      VideoData(
        url: 'https://d18gbwu7fwwwtf.cloudfront.net/fello-experts/annual-return-video.mp4',
        title: 'Safety First',
        author: 'John Doe2',
        subtitle: 'Exploring safety protocols',
        views: 150,
        duration: '5:00',
        comments: [],
        categories: {'Health', 'Safety'},
      ),
      VideoData(
        url: 'https://d18gbwu7fwwwtf.cloudfront.net/fello-experts/expectations-from-webinar.mp4',
        title: 'Safety First',
        author: 'John Doe3',
        subtitle: 'Exploring safety protocols',
        views: 150,
        duration: '5:00',
        comments: [],
        categories: {'Health', 'Safety'},
      ),
      VideoData(
        url: 'https://d18gbwu7fwwwtf.cloudfront.net/fello-experts/personal-finance-fundamentals.mp4',
        title: 'Safety First',
        author: 'John Doe3',
        subtitle: 'Exploring safety protocols',
        views: 150,
        duration: '5:00',
        comments: [],
        categories: {'Health', 'Safety'},
      ),
      // Add more videos with complete data here
    ];

    // Return a subset based on the requested index
    if (id >= videos.length) return [];
    if (id + VideoPreloadConstants.nextLimit >= videos.length) {
      return videos.sublist(id, videos.length);
    }
    return videos.sublist(id, id + VideoPreloadConstants.nextLimit);
  }
}
