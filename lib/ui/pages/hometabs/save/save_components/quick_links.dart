import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/quick_links_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class QuickLinks extends StatelessWidget {
  const QuickLinks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<QuickLinksModel> quickLinks = [];
    try {
      quickLinks = QuickLinksModel.fromJsonList(
        AppConfig.getValue(AppConfigKey.quickActionsV3),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  "Invest in",
                  style: TextStyles.sourceSansSB.body2,
                ),
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
            child: Column(
              children: List.generate(
                quickLinks.length,
                (index) => Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quickLinks[index].deeplink != '') {
                          Haptic.vibrate();
                          AppState.delegate!.parseRoute(
                            Uri.parse(quickLinks[index].deeplink),
                          );
                        } 
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
                        meta: quickLinks[index].meta,
                        color: quickLinks[index].color,
                        link: quickLinks[index].deeplink,
                      ),
                    ),
                    if (index < quickLinks.length - 1) SizedBox(height: 16.h),
                  ],
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
  final Map meta;
  final Color color;
  final String link;

  const _InvestmentCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.meta,
    required this.color,
    required this.link,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return CustomPaint(
      painter: GradientBorderPainter(
        borderWidth: 0.5,
        borderRadius: BorderRadius.all(
          Radius.circular(16.r),
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.transparent,
            color,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        backgroundGradient: LinearGradient(
          colors: [
            UiConstants.greyVarient,
            UiConstants.greyVarient.withOpacity(0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 23.w),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: AppImage(icon),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.sourceSans3(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                            if (link != '')
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white.withOpacity(.5),
                                size: 20.sp,
                              ),

                          if(link == '' && tag != null)
                           Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: UiConstants.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: UiConstants.primaryColor.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Text(
                              tag!,
                              style: GoogleFonts.sourceSans3(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                ),
                              ),
                              ),
                            ],
                          ),
                    
                          if (description == 'livevalue')
                            BaseView<GoldBuyViewModel>(
                              onModelReady: (model) {
                                model.fetchGoldRates();
                              },
                              builder: (ctx, model, child) {
                                return Text(
                                  'Live: ${formatter.format(model.goldRates?.goldBuyPrice ?? 0)}/gm',
                                  style: GoogleFonts.sourceSans3(
                                    color:
                                        UiConstants.kTextColor.withOpacity(.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          if (description != 'livevalue')
                            Text(
                              description,
                              style: GoogleFonts.sourceSans3(
                                color: UiConstants.kTextColor.withOpacity(.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (meta.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Divider(
                      color: UiConstants.grey6,
                    ),
                  ),
                if (meta.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildMetaDetails(),
                    ),
                  ),
              ],
            ),
            // if (tag != null)
            //   Positioned(
            //     top: 0,
            //     child: Container(
            //       padding:
            //           EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            //       decoration: BoxDecoration(
            //         color: const Color(0xff14A085),
            //         borderRadius: BorderRadius.circular(16.r),
            //       ),
            //       child: Text(
            //         tag!,
            //         style: GoogleFonts.sourceSans3(
            //           color: Colors.white,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 8.sp,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMetaDetails() {
    List<Widget> metaWidgets = [];
    List<MapEntry> metaEntries = meta.entries.toList();

    for (int i = 0; i < metaEntries.length; i++) {
      MapEntry entry = metaEntries[i];

      metaWidgets.add(
        _buildDetailRow(
          entry.key.toString(),
          entry.value.toString(),
          entry.key.toString().toLowerCase().contains('interest')
              ? UiConstants.teal3
              : null,
        ),
      );
      if (i < metaEntries.length - 1) {
        metaWidgets.add(
          Container(
            height: 40.h,
            width: 1.w,
            color: UiConstants.grey6,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
          ),
        );
      }
    }

    return metaWidgets;
  }

  Widget _buildDetailRow(String label, String value, Color? textColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyles.sourceSansM.body4.colour(
              UiConstants.kTextColor.withOpacity(.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyles.sourceSansM.body3.colour(
              textColor ?? UiConstants.kTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final double borderWidth;
  final BorderRadius borderRadius;
  final Gradient borderGradient;
  final Gradient? backgroundGradient;

  GradientBorderPainter({
    required this.borderWidth,
    required this.borderRadius,
    required this.borderGradient,
    this.backgroundGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);

    // Draw background if provided
    if (backgroundGradient != null) {
      final backgroundPaint = Paint()
        ..shader = backgroundGradient!.createShader(rect);
      canvas.drawRRect(rrect, backgroundPaint);
    }

    // Draw border
    final borderPaint = Paint()
      ..shader = borderGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
