import 'package:felloapp/core/model/shorts/shorts_notification.dart' as nf;
import 'package:felloapp/feature/shorts_notifications/shorts_notification_bloc.dart';
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

import '../../util/bloc_pagination/pagination_bloc.dart';

class ShortsNotificationPage extends StatelessWidget {
  const ShortsNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShortsNotificationBloc(shortsRepository: locator())..fetchFirstPage(),
      child: const _ShortsNotification(),
    );
  }
}

class _ShortsNotification extends StatefulWidget {
  const _ShortsNotification();

  @override
  State<_ShortsNotification> createState() => _ShortsNotificationState();
}

class _ShortsNotificationState extends State<_ShortsNotification> {
  final Set<String> _unseenNotificationIds = {};
  @override
  void dispose() {
    super.dispose();
    if (_unseenNotificationIds.isNotEmpty) {
      // context
      //     .read<ShortsNotificationBloc>()
      //     .add(UpdateUnseenNotifications(_unseenNotificationIds.toList()));
      // context.read<ShortsNotificationBloc>().add(MarkNotificationsAsSeen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final shortsNotificationBloc = context.read<ShortsNotificationBloc>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        shortsNotificationBloc.reset();
      },
      child: BaseScaffold(
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
        body: BlocBuilder<ShortsNotificationBloc,
            PaginationState<dynamic, int, Object>>(
          builder: (context, state) {
            if (state.status.isFailedToLoadInitial) {
              return const NewErrorPage();
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
              return Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding82),
                child: Text('No notifications'),
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
                        _unseenNotificationIds.add(notification.advisorId);
                      }
                      return shortsNotificationBloc.state.entries[index]
                              is nf.Notification
                          ? Container(
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
                                    backgroundImage: NetworkImage(
                                      notification.advisorProfilePhoto,
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
                                              style:
                                                  TextStyles.sourceSansM.body3,
                                            ),
                                            if (!notification.isSeen)
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 4.w,
                                                ),
                                                width: 6.r,
                                                height: 6.r,
                                                decoration: const BoxDecoration(
                                                  color:
                                                      UiConstants.primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              notification.categoryV1,
                                              style: TextStyles.sourceSans.body4
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
                                              notification.duration,
                                              style: TextStyles.sourceSans.body4
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
                                                color: UiConstants.primaryColor,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    notification.subtitle,
                                                    style: TextStyles
                                                        .sourceSansM.body4,
                                                  ),
                                                  Text(
                                                    '${notification.duration} watch',
                                                    style: TextStyles
                                                        .sourceSans.body4
                                                        .colour(
                                                      const Color(0xffC2BDC2),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
