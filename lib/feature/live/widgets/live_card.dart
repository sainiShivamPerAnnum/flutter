import 'package:flutter/material.dart';

class LiveCardWidget extends StatelessWidget {
  final String status;
  final String title;
  final String subTitle;
  final String author;
  final String category;
  final String bgImage;
  final int? liveCount;
  final String? duration;

  LiveCardWidget({
    required this.status,
    required this.title,
    required this.subTitle,
    required this.author,
    required this.category,
    required this.bgImage,
    this.liveCount,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff2D3135),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with play button overlay
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                    image: NetworkImage(bgImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (status == 'live')
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              Positioned(
                bottom: 15,
                left: 65,
                child: Row(
                  children: [
                    if (liveCount != null)
                      Icon(Icons.visibility, color: Colors.white, size: 16),
                    if (liveCount != null) SizedBox(width: 4),
                    if (liveCount != null)
                      Text(
                        '${liveCount! ~/ 1000}K',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
              if (status == 'live')
                Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.play_circle_filled,
                      color: Colors.white, size: 50),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: getCategoryColor(category),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                SizedBox(height: 5),

                // Title
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),

                // Subtitle (time started or duration)
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 5),

                // Author's name
                Text(
                  author,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          )
          // Category tag
        ],
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'stocks':
        return Colors.green;
      case 'crypto':
        return Colors.blue;
      case 'investments':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
