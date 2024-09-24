import 'package:flutter/material.dart';

class ExpertCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String expertise;
  final String qualifications;
  final int availableSlots;
  final String experience;
  final double rating;
  final VoidCallback onBookCall;

  ExpertCard({
    required this.imageUrl,
    required this.name,
    required this.expertise,
    required this.qualifications,
    required this.availableSlots,
    required this.experience,
    required this.rating,
    required this.onBookCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '$experience Years',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '$rating',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Makes sure it aligns at the top
                    children: [
                      Icon(Icons.work, color: Colors.white60, size: 16),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          expertise,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                          maxLines: 2, // Optional, can set a max number of lines
                          overflow: TextOverflow
                              .visible, // Allows it to wrap to the next line
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Makes sure it aligns at the top
                    children: [
                      Icon(Icons.school, color: Colors.white60, size: 16),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          qualifications,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                          maxLines: 2, // Optional, can set a max number of lines
                          overflow: TextOverflow
                              .visible, // Allows it to wrap to the next line
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$availableSlots Slots Available',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onBookCall,
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.white,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          'Book a Call',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
