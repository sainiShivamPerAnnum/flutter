import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.only(top: 14, bottom: 14, left: 18, right: 18),
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
                  'Need help?',
                  style: TextStyle(
                    color: Color(0xFF62E3C4),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // SizedBox(height: 8),
                Text(
                  'For more help contact us at: 1800-123-123455',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.white,
                    // onPrimary: Colors.black,
                    // padding: const EdgeInsets.all(0),
                    padding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 12, right: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Call Us Now',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right side image
          SizedBox(
            width: 64,
            height: 64,
            child: Image.asset(
              Assets.help, // Path to your image asset
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
