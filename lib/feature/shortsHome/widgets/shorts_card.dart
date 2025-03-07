import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/feature/shorts/video_page.dart';
import 'package:felloapp/feature/shortsHome/bloc/pagination_bloc.dart';
import 'package:felloapp/feature/shortsHome/widgets/more_options_sheet.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/local_actions_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShortsCard extends StatelessWidget {
  const ShortsCard({
    required this.videos,
    required this.categories,
    required this.i,
    required this.searchFocusNode,
    required this.themeVideosBloc,
    required this.themeName,
    required this.theme,
    super.key,
  });
  final List<VideoData> videos;
  final List<String> categories;
  final String themeName;
  final String theme;
  final int i;
  final FocusNode searchFocusNode;
  final ThemeVideosBloc themeVideosBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        searchFocusNode.unfocus();
        final preloadBloc = BlocProvider.of<PreloadBloc>(
          context,
        );
        final switchCompleter = Completer<void>();
        final themeCompleter = Completer<void>();
        final cate = videos[i].categoryV1;
        final normalizedCategories = categories
            .map(
              (category) => category.trim().toLowerCase(),
            )
            .toList();
        final normalizedIndex = normalizedCategories.indexOf(
          cate.trim().toLowerCase(),
        );
        final List<String> reorderedCategories = [
          ...categories,
        ];
        if (normalizedIndex != -1) {
          final clickedCategory = reorderedCategories.removeAt(
            normalizedIndex,
          );
          reorderedCategories.insert(
            0,
            clickedCategory,
          );
        }
        reorderedCategories.insert(
          0,
          themeName,
        );
        preloadBloc.add(
          PreloadEvent.updateThemes(
            categories: reorderedCategories,
            theme: theme,
            index: 0,
            completer: themeCompleter,
          ),
        );
        await themeCompleter.future;
        preloadBloc.add(
          PreloadEvent.getThemeVideos(
            initailVideo: videos[i],
            theme: theme,
            completer: switchCompleter,
          ),
        );
        await switchCompleter.future;
        AppState.delegate!.appState.currentAction = PageAction(
          page: ShortsPageConfig,
          state: PageState.addWidget,
          widget: BaseScaffold(
            showBackgroundGrid: false,
            backgroundColor: UiConstants.bg,
            bottomNavigationBar: const BottomNavBar(),
            body: ShortsVideoPage(
              categories: reorderedCategories,
            ),
          ),
        );
      },
      child: Container(
        // width: 130.w,
        constraints: BoxConstraints(
          maxWidth: 130.w,
        ),
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(
            8.r,
          ),
        ),
        margin: EdgeInsets.only(
          right: 8.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 130.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              8.r,
                            ),
                            topRight: Radius.circular(
                              8.r,
                            ),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              videos[i].thumbnail,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  buildMoreIcon(
                    videos[i].id,
                    videos[i].isSaved,
                    theme,
                    videos[i].categoryV1,
                    searchFocusNode,
                    context,
                    themeVideosBloc,
                  ),
                  buildPlayIcon(),
                  buildViewIndicator(
                    videos[i].views.toDouble(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 14.h,
              ),
              decoration: BoxDecoration(
                color: UiConstants.greyVarient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    8.r,
                  ),
                  bottomRight: Radius.circular(
                    8.r,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videos[i].title,
                    style: TextStyles.sourceSansM.body4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    videos[i].categoryV1,
                    style: TextStyles.sourceSans.body6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildMoreIcon(
  String id,
  bool isSaved,
  String theme,
  String category,
  FocusNode searchFocusNode,
  BuildContext context,
  ThemeVideosBloc themeVideosBloc,
) {
  return Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: EdgeInsets.only(top: 10.h, right: 8.w),
      child: GestureDetector(
        onTap: () {
          searchFocusNode.unfocus();
          BaseUtil.openModalBottomSheet(
            isScrollControlled: true,
            enableDrag: false,
            isBarrierDismissible: true,
            addToScreenStack: true,
            backgroundColor: UiConstants.kBackgroundColor,
            hapticVibrate: true,
            content: MoreOptionsSheet(
              id: id,
              isSaved: LocalActionsState.getVideoSaved(id, isSaved),
              theme: theme,
              category: category,
              onSave: () {
                BlocProvider.of<PreloadBloc>(
                  context,
                  listen: false,
                ).add(
                  PreloadEvent.saveVideo(
                    isSaved: isSaved,
                    videoId: id,
                    theme: theme,
                    category: category,
                  ),
                );
                themeVideosBloc.updateItemsWhere(
                  (video) => video.id == id,
                  (currentVideo) {
                    return currentVideo.copyWith(
                      isSaved: !currentVideo.isSaved,
                    );
                  },
                );
              },
            ),
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 24.r,
          width: 24.r,
          alignment: Alignment.center,
          child: Icon(
            Icons.more_vert_rounded,
            color: Colors.white,
            size: 18.r,
          ),
        ),
      ),
    ),
  );
}

Widget buildPlayIcon() {
  return Align(
    alignment: Alignment.center,
    child: Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: UiConstants.kTextColor.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: SizeConfig.iconSize5,
      ),
    ),
  );
}

Widget buildViewIndicator(double views) {
  return Positioned(
    bottom: SizeConfig.padding10,
    left: SizeConfig.padding10,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding8,
        vertical: SizeConfig.padding4,
      ),
      decoration: BoxDecoration(
        color: UiConstants.kTextColor4,
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.remove_red_eye,
            color: UiConstants.titleTextColor,
            size: SizeConfig.iconSize4,
          ),
          SizedBox(
            width: SizeConfig.padding4,
          ),
          Text(
            BaseUtil.formatShortNumber(views),
            style: TextStyles.sourceSansSB.body4.colour(
              UiConstants.titleTextColor,
            ),
          ),
        ],
      ),
    ),
  );
}
