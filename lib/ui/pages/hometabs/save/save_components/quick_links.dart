import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/quick_links_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickLinks extends StatelessWidget {
  const QuickLinks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<QuickLinksModel> quickLinks = QuickLinksModel.fromJsonList(
      AppConfig.getValue(AppConfigKey.quickActionsV2),
    );

    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleSubtitleContainer(
                title: "In-house investment options",
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 14.h,
              left: 20.w,
              right: 20.w,
            ),
            width: 1.sw,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(
                quickLinks.length,
                (index) => GestureDetector(
                  onTap: () {
                    Haptic.vibrate();
                    AppState.delegate!
                        .parseRoute(Uri.parse(quickLinks[index].deeplink));
                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.iconTrayTapped,
                      properties: {'icon': quickLinks[index].name},
                    );
                  },
                  child: _InvestmentCard(
                    tag: quickLinks[index].tag,
                    title: quickLinks[index].name,
                    icon: quickLinks[index].asset,
                    description: quickLinks[index].description,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final String? tag;

  const _InvestmentCard({
    required this.title,
    required this.icon,
    required this.description,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110.w,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                width: 110.w,
                padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 12.r),
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: AppImage(icon),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      title,
                      style: GoogleFonts.sourceSans3(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xff292B2F),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                ),
                child: Text(
                  description,
                  style: GoogleFonts.sourceSans3(
                    color: UiConstants.teal3,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (tag != null)
            Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xff14A085),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  tag!,
                  style: GoogleFonts.sourceSans3(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
