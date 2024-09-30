import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FindUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: Color(0xFF232326),
      padding: const EdgeInsets.all(20), // Add padding to the parent container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You can also find us on',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          // SizedBox(height: 16), // Add space between text and grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3, // To control the height of each item
              children: [
                buildSocialMediaButton(
                    'Whatsapp', 'assets/vectors/whatsapp_find.svg'),
                buildSocialMediaButton('Facebook', 'assets/vectors/fb.svg'),
                buildSocialMediaButton(
                    'Linkedin', 'assets/vectors/linkedIn.svg'),
                buildSocialMediaButton('Instagram', 'assets/vectors/insta.svg'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget buildSocialMediaButton(String title, String iconPath) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xFF2D3135), // Button background color
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 16,
          height: 16,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
          size: 16,
        ),
      ],
    ),
  );
}
