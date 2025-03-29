import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/fd_web_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BlostemRedirectionSheet extends StatelessWidget {
  const BlostemRedirectionSheet({
    required this.blostemUrl,
    required this.onCloseWebView,
    super.key,
  });
  final String blostemUrl;
  final VoidCallback onCloseWebView;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ).copyWith(
            top: 6.h,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Redirecting to Partner Site',
                    style: TextStyles.sourceSansSB.body1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 18.r,
                    splashRadius: 18.r,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                    icon: Icon(
                      Icons.close,
                      size: 18.r,
                      color: UiConstants.kTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.zero,
          child: Divider(
            color: UiConstants.kTextColor5.withOpacity(.3),
            thickness: 1,
            height: 1,
          ),
        ),
        SizedBox(
          height: 18.h,
        ),
        AppImage(
          Assets.webRedirect,
          height: 50.h,
          width: 50.w,
        ),
        SizedBox(
          height: 16.h,
        ),
        Text(
          'We\'ll redirect you to our \npartner\'s website',
          style: TextStyles.sourceSansM.body0,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 30.h,
        ),
        _buildFeatureRow(
          icon: Icon(
            Icons.account_balance,
            color: UiConstants.teal4,
            size: 14.sp,
          ),
          title: "Partner's website",
          subtitle: "Invest in FDs in a few easy steps",
          iconColor: const Color(0xffDFDFDF),
        ),
        SizedBox(height: 18.h),
        _buildFeatureRow(
          icon: AppImage(
            Assets.logoWhite,
            width: 14.w,
            height: 14.h,
          ),
          title: "Fello app",
          subtitle: "Track all your FDs on Fello",
          iconColor: UiConstants.teal4,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          child: Divider(
            color: UiConstants.kTextColor5.withOpacity(.3),
            thickness: 1,
            height: 1,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              AppState.delegate!.appState.currentAction = PageAction(
                page: WebViewPageConfig,
                state: PageState.addWidget,
                widget: FdWebView(
                  url: blostemUrl,
                  onPageClosed: onCloseWebView,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UiConstants.kTextColor,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
            ),
            child: Text(
              'Continue to partner\'s website',
              style:
                  TextStyles.sourceSans.body3.colour(UiConstants.kTextColor4),
            ),
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImage(
              Assets.securityCheck,
              height: 14.h,
            ),
            SizedBox(
              width: 8.h,
            ),
            Text(
              'Partner\'s website is completely safe',
              style: TextStyles.sourceSans.body4.colour(
                UiConstants.kProfileBorderColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  Widget _buildFeatureRow({
    required Widget icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: icon,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sourceSans3(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: const Color(0xff96989A),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyles.sourceSans.body3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
