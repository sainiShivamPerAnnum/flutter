import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart';

class ConsultationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xff2D3135),
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        // color: Color(0xff2D3135),
        //     blurRadius: 5,
        //     spreadRadius: 2,
        //   ),
        // ],
      ),
      child: Row(
        children: [
          // Left side text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERSONALISED CONSULTATION',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Get expert advice and start\nachieving financial goals!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.white,
                    // onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Book Now!'),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '135 users booked an appointment today',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // Right side image
          Container(
            width: 50,
            height: 50,
            child: Image.network(
              Assets.calender, // Path to your image asset
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
