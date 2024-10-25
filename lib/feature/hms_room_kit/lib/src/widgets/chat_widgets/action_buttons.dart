import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatActionButtons extends StatelessWidget {
  const ChatActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Column(
            children: [
              IconButton(
                icon: AppImage(
                  Assets.video_share,
                  color: Colors.white,
                  height: SizeConfig.padding20,
                  width: SizeConfig.padding20,
                ),
                onPressed: (){},
              ),
              Text(
                'Share',
                style: GoogleFonts.sourceSans3(
                  fontSize: SizeConfig.body4,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
       
          Column(
            children: [
              IconButton(
                icon: AppImage(
                  Assets.video_like,
                  color: true ? Colors.red : Colors.white,
                  height: SizeConfig.padding20,
                  width: SizeConfig.padding20,
                ),
                onPressed: (){},
              ),
              Text(
                'Like',
                style: GoogleFonts.sourceSans3(
                  fontSize: SizeConfig.body4,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: AppImage(
                  Assets.book_call,
                  color: Colors.white,
                  height: SizeConfig.padding20,
                  width:  SizeConfig.padding20,
                ),
                onPressed: (){},
              ),
              Text(
                'Book a call',
                style: GoogleFonts.sourceSans3(
                  fontSize: SizeConfig.body4,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
      ],
    );
  }
}