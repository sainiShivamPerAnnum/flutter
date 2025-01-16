import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorPage extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? btnLabel;

  const ErrorPage({
    this.onPressed,
    this.btnLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.h4(
              'Oops, this one is on us',
              color: AppColors.white,
            ),
            SizedBox(
              height: 16.h,
            ),
            AppText.body1(
              'Our team is trying to resolve it earliest possible',
              color: AppColors.textGray70,
            ),
            SizedBox(
              height: 42.h,
            ),
            AppImage(
              'assets/images/sip_error.png',
              height: 252.h,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
        child: SecondaryButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          label: Text(
            btnLabel ?? 'CLOSE',
          ),
        ),
      ),
    );
  }
}
