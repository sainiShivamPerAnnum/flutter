import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../util/styles/textStyles.dart';

class NoChats extends StatelessWidget {
  const NoChats({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: .7.sh,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImage(
              Assets.noChats,
              height: 82.r,
              width: 82.r,
            ),
            SizedBox(height: 24.h),
            Text(
              'No chats found',
              style: TextStyles.sourceSansM.body0,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 294.w,
              child: Text(
                'Start chatting with an expert to start seeing them here',
                style:
                    TextStyles.sourceSans.body2.colour(UiConstants.kTextColor5),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
