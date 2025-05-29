import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewChatWelcome extends StatelessWidget {
  final Function(String) onOptionSelected;
  final String advisorName;
  final VoidCallback? onWithdrawalSupportTap;

  const NewChatWelcome({
    required this.onOptionSelected,
    required this.advisorName,
    this.onWithdrawalSupportTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: UiConstants.grey6.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style:
                    TextStyles.sourceSans.body4.colour(const Color(0xffA6A6AC)),
                children: [
                  const TextSpan(
                    text:
                        'This chat is for financial advisory. If you are looking for withdrawal support, please ',
                  ),
                  TextSpan(
                    text: 'click here',
                    style: TextStyles.sourceSans.body4
                        .colour(const Color(0xffA6A6AC))
                        .copyWith(
                          decoration: TextDecoration.underline,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        onWithdrawalSupportTap?.call();
                      },
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptionChip(
                    'Investment Planning',
                    Icons.trending_up,
                    'Hi, I\'m looking for investment planning guidance',
                  ),
                  SizedBox(width: 12.h),
                  _buildOptionChip(
                    'Retirement Planning',
                    Icons.account_balance_wallet,
                    'Hi, I need help with retirement planning',
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptionChip(
                    'Portfolio Management',
                    Icons.pie_chart,
                    'Hi, I\'d like assistance with portfolio management',
                  ),
                  SizedBox(width: 12.h),
                  _buildOptionChip(
                    'Mutual Funds advice',
                    Icons.bar_chart,
                    'Hi, I need advice on mutual funds',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionChip(String title, IconData icon, String messageText) {
    return GestureDetector(
      onTap: () => onOptionSelected(messageText),
      child: Container(
        width: 167.w,
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: const Color(0xFF01656B).withOpacity(0.5),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   width: 32.w,
            //   height: 32.h,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF2D7D7D).withOpacity(0.2),
            //     borderRadius: BorderRadius.circular(16.r),
            //   ),
            //   child: Icon(
            //     icon,
            //     color: const Color(0xFF2D7D7D),
            //     size: 18.sp,
            //   ),
            // ),
            // SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyles.sourceSansM.body4.colour(
                UiConstants.teal3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
