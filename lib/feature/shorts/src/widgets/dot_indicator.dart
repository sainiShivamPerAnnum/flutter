import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class DotIndicatorRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final String categoryName;
  final bool muted;

  const DotIndicatorRow({
    required this.currentPage,
    required this.categoryName,
    required this.totalPages,
    required this.muted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15.h,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(
              color: UiConstants.kTextColor,
              onPressed: () async {
                await AppState.backButtonDispatcher!.didPopRoute();
              },
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalPages, (index) {
                    return DotIndicator(
                      isActive: index == currentPage,
                    );
                  }),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  categoryName,
                  style: TextStyles.sourceSansM.body3,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<PreloadBloc>(
                    context,
                    listen: false,
                  ).add(
                    const PreloadEvent.toggleVolume(),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 24.r,
                  width: 24.r,
                  child: Icon(
                    !muted ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                    size: 21.r,
                    color: UiConstants.kTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
