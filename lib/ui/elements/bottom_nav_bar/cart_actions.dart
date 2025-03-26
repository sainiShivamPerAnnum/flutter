import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartActions extends StatelessWidget {
  const CartActions({
    required this.cart,
    super.key,
  });
  final CartItemAdded cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 10.h,
      ).copyWith(right: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xff094549).withOpacity(.8),
        borderRadius: BorderRadius.circular(
          12.r,
        ),
        border: Border.all(
          color: UiConstants.teal4,
          width: 1.5.r,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
            child: AppImage(
              cart.advisor.image,
              fit: BoxFit.cover,
              height: 40.h,
              width: 40.h,
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          GestureDetector(
            onTap: () {
              AppState.delegate!.appState.currentAction = PageAction(
                page: ExpertDetailsPageConfig,
                state: PageState.addWidget,
                widget: ExpertsDetailsView(
                  advisorID: cart.advisor.advisorId,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.advisor.name,
                  style: TextStyles.sourceSansSB.body4,
                ),
                Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyles.sourceSans.body4.colour(
                        const Color(0xffC2BDC2),
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 12.sp,
                      color: const Color(0xffC2BDC2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (cart.selectedDate != null &&
                  cart.selectedTime != null &&
                  cart.selectedDuration != null) {
                BaseUtil.openBookAdvisorSheet(
                  advisorId: cart.advisor.advisorId,
                  advisorName: cart.advisor.name,
                  advisorImage: cart.advisor.image,
                  isEdit: false,
                  cartPayment: true,
                  selectedDate: cart.selectedDate,
                  selectedDuration: cart.selectedDuration,
                  selectedTime: cart.selectedTime,
                );
              } else {
                BaseUtil.openBookAdvisorSheet(
                  advisorId: cart.advisor.advisorId,
                  advisorName: cart.advisor.name,
                  advisorImage: cart.advisor.image,
                  isEdit: false,
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: UiConstants.kTextColor,
                borderRadius: BorderRadius.circular(
                  5.r,
                ),
              ),
              child: Text(
                cart.selectedDate != null &&
                        cart.selectedTime != null &&
                        cart.selectedDuration != null
                    ? 'Make Payment'
                    : 'Book a Call',
                style: TextStyles.sourceSansSB.body4.colour(
                  UiConstants.kTextColor4,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          SizedBox(
            height: 32.r,
            width: 32.r,
            child: Center(
              child: Ink(
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  iconSize: 18.r,
                  onPressed: () {
                    context.read<CartBloc>().add(
                          ClearCart(),
                        );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
