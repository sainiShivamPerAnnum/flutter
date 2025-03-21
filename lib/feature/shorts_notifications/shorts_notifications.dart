import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/shorts/shorts_notification.dart' as nf;
import 'package:felloapp/feature/shorts/src/bloc/preload_bloc.dart';
import 'package:felloapp/feature/shorts/video_page.dart';
import 'package:felloapp/feature/shorts_notifications/shorts_notification_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../util/bloc_pagination/pagination_bloc.dart';

class ShortsNotificationPage extends StatefulWidget {
  const ShortsNotificationPage({super.key});

  @override
  State<ShortsNotificationPage> createState() => _ShortsNotificationPageState();
}

class _ShortsNotificationPageState extends State<ShortsNotificationPage> {
  late final ShortsNotificationWrapperBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ShortsNotificationWrapperBloc(
      shortsRepository: locator(),
    )..fetchFirstPage();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: _ShortsNotification(),
    );
  }
}

class _ShortsNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shortsNotificationBloc =
        context.read<ShortsNotificationWrapperBloc>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        shortsNotificationBloc.reset();
      },
      child: BaseScaffold(
        showBackgroundGrid: false,
        backgroundColor: UiConstants.bg,
        appBar: FAppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leadingPadding: false,
          titleWidget: Text(
            'Notifications',
            style: TextStyles.sourceSansSB.body1,
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
          showAvatar: false,
          showCoinBar: false,
        ),
        body: BlocBuilder<ShortsNotificationWrapperBloc,
            PaginationState<dynamic, int, Object>>(
          builder: (context, state) {
            if (state.status.isFailedToLoadInitial) {
              return NewErrorPage(
                onTryAgain: shortsNotificationBloc.reset,
              );
            }

            if (state.status.isFetchingInitialPage) {
              return Center(
                child: SizedBox.square(
                  dimension: SizeConfig.padding200,
                  child: const AppImage(
                    Assets.fullScreenLoaderLottie,
                  ),
                ),
              );
            }
            if (shortsNotificationBloc.state.entries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppImage(
                      Assets.noNotifications,
                      height: 82.r,
                      width: 82.r,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Text(
                      'New notifications will show up here',
                      style: TextStyles.sourceSansM.body0,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    SizedBox(
                      width: 294.w,
                      child: Text(
                        'You\'ll be notified when new shorts is uploaded',
                        style: TextStyles.sourceSans.body2
                            .colour(UiConstants.kTextColor5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: shortsNotificationBloc.state.entries.length,
                    itemBuilder: (context, index) {
                      final notification = shortsNotificationBloc
                          .state.entries[index] as nf.Notification;
                      final notificationIsSeen = notification.isSeen;
                      if (!notificationIsSeen) {
                        shortsNotificationBloc
                            .trackUnseenNotification(notification.videoId);
                      }
                      return shortsNotificationBloc.state.entries[index]
                              is nf.Notification
                          ? GestureDetector(
                              onTap: () async {
                                final preloadBloc =
                                    BlocProvider.of<PreloadBloc>(
                                  context,
                                );
                                final switchCompleter = Completer<void>();
                                preloadBloc.add(
                                  PreloadEvent.initializeFromDynamicLink(
                                    videoId: notification.videoId,
                                    completer: switchCompleter,
                                  ),
                                );
                                await switchCompleter.future;
                                AppState.delegate!.appState.currentAction =
                                    PageAction(
                                  page: ShortsPageConfig,
                                  state: PageState.addWidget,
                                  widget: BaseScaffold(
                                    showBackgroundGrid: false,
                                    backgroundColor: UiConstants.bg,
                                    appBar: FAppBar(
                                      backgroundColor: Colors.transparent,
                                      centerTitle: true,
                                      titleWidget: Text(
                                        'Notifications',
                                        style: TextStyles.rajdhaniSB.body1,
                                      ),
                                      leading: BackButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          AppState.backButtonDispatcher!
                                              .didPopRoute();
                                        },
                                      ),
                                      showAvatar: false,
                                      showCoinBar: false,
                                      action: BlocBuilder<PreloadBloc,
                                          PreloadState>(
                                        builder: (context, preloadState) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.w),
                                            child: GestureDetector(
                                              onTap: () {
                                                BlocProvider.of<PreloadBloc>(
                                                  context,
                                                  listen: false,
                                                ).add(
                                                  const PreloadEvent
                                                      .toggleVolume(),
                                                );
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              child: SizedBox(
                                                height: 24.r,
                                                width: 24.r,
                                                child: Icon(
                                                  !preloadState.muted
                                                      ? Icons.volume_up_rounded
                                                      : Icons
                                                          .volume_off_rounded,
                                                  size: 21.r,
                                                  color: UiConstants.kTextColor,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    body: const ShortsVideoPage(
                                      categories: [],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(18.r),
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: notification.isSeen
                                        ? const BorderSide(
                                            color: UiConstants.primaryColor,
                                            width: 0,
                                          )
                                        : BorderSide(
                                            color: UiConstants.primaryColor,
                                            width: 3.w,
                                          ),
                                    bottom: const BorderSide(
                                      color: UiConstants.greyVarient,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 18.r,
                                      backgroundColor: Colors.transparent,
                                      child: notification
                                              .advisorProfilePhoto.isNotEmpty
                                          ? ClipOval(
                                              child: AppImage(
                                                height: 32.r,
                                                width: 32.r,
                                                notification
                                                    .advisorProfilePhoto,
                                              ),
                                            )
                                          : AppImage(
                                              height: 32.r,
                                              width: 32.r,
                                              Assets.logoWhite,
                                            ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                notification.title,
                                                style: TextStyles
                                                    .sourceSansM.body3,
                                              ),
                                              if (!notification.isSeen)
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 4.w,
                                                  ),
                                                  width: 6.r,
                                                  height: 6.r,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: UiConstants
                                                        .primaryColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                notification.categoryV1,
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(
                                                  const Color(0xffC2BDC2),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 4.w,
                                                ),
                                                width: 4.r,
                                                height: 4.r,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffC2BDC2),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Text(
                                                timeago.format(
                                                  DateTime.parse(
                                                    notification.createdAt,
                                                  ),
                                                ),
                                                style: TextStyles
                                                    .sourceSans.body4
                                                    .colour(
                                                  const Color(0xffC2BDC2),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16.h,
                                              horizontal: 14.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: UiConstants.greyVarient,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.r),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .play_circle_filled_rounded,
                                                  size: 30.r,
                                                  color:
                                                      UiConstants.primaryColor,
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notification.subtitle,
                                                        style: TextStyles
                                                            .sourceSansM.body4,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        '${notification.duration} watch',
                                                        style: TextStyles
                                                            .sourceSans.body4
                                                            .colour(
                                                          const Color(
                                                            0xffC2BDC2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  if (state.status.isFetchingSuccessive)
                    const CupertinoActivityIndicator(
                      radius: 15,
                      color: Colors.white24,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
