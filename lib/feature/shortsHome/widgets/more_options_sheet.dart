import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreOptionsSheet extends StatelessWidget {
  const MoreOptionsSheet({
    required this.id,
    super.key,
  });
  final String id;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ).copyWith(
            top: SizeConfig.padding12,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: SizeConfig.body1,
                      color: UiConstants.kTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: const Color(0xffA2A0A2).withOpacity(.3),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ).copyWith(top: 10.h, bottom: 20.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      size: 14.r,
                      color: UiConstants.kTextColor,
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      'Save',
                      style: TextStyles.sourceSansM.body3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              BlocBuilder<PreloadBloc, PreloadState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if (state.isShareAlreadyClicked == false) {
                        BlocProvider.of<PreloadBloc>(
                          context,
                          listen: false,
                        ).add(
                          PreloadEvent.generateDynamicLink(
                            videoId: id,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: UiConstants.greyVarient,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          AppImage(
                            Assets.video_share,
                            color: Colors.white,
                            height: 12.r,
                            width: 12.r,
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Text(
                            'Share',
                            style: TextStyles.sourceSansM.body3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
