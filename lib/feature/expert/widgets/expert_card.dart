import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/feature/chat/bloc/chat_bloc.dart';
import 'package:felloapp/feature/chat/chat_screen.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpertCard extends StatelessWidget {
  final Expert expert;
  final VoidCallback onBookCall;
  final VoidCallback onTap;
  final bool isFree;

  const ExpertCard({
    required this.expert,
    required this.onBookCall,
    required this.onTap,
    required this.isFree,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 16.h,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: Image.network(
                      expert.image,
                      height: SizeConfig.padding56,
                      width: SizeConfig.padding56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expert.name,
                          style: TextStyles.sourceSansSB.body2.colour(
                            UiConstants.kTextColor,
                          ),
                        ),
                        Wrap(
                          spacing: SizeConfig.padding6,
                          runSpacing: SizeConfig.padding6,
                          children: _buildExpertiseTags(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
              child: Column(
                children: [
                  const Divider(
                    color: UiConstants.grey6,
                    thickness: 0.6,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: UiConstants.kTextColor,
                              size: SizeConfig.body4,
                            ),
                            SizedBox(width: SizeConfig.padding8),
                            Text(
                              "${expert.experience} years",
                              style: TextStyles.sourceSansM.body4.colour(
                                UiConstants.kTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: SizeConfig.padding18),
                        SizedBox(
                          height: SizeConfig.padding16,
                          child: const VerticalDivider(
                            color: UiConstants.grey6,
                            thickness: 0.6,
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding18),
                        Row(
                          children: [
                            AppImage(
                              Assets.qualifications,
                              height: SizeConfig.body4,
                              width: SizeConfig.body4,
                              color: UiConstants.kTextColor,
                            ),
                            SizedBox(width: SizeConfig.padding4),
                            Text(
                              expert.qualifications,
                              style: TextStyles.sourceSansM.body4.colour(
                                UiConstants.kTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: SizeConfig.padding18),
                        SizedBox(
                          height: SizeConfig.padding16,
                          child: const VerticalDivider(
                            color: UiConstants.grey6,
                            thickness: 0.6,
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding18),
                        Row(
                          children: [
                            Icon(
                              Icons.message_rounded,
                              color: UiConstants.kTextColor,
                              size: SizeConfig.body4,
                            ),
                            SizedBox(width: SizeConfig.padding4),
                            Text(
                              "32 sessions",
                              style: TextStyles.sourceSansM.body4.colour(
                                UiConstants.kTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: UiConstants.grey6,
                    thickness: 0.6,
                  ),
                ],
              ),
            ),
            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 18.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                          page: ChatsPageConfig,
                          state: PageState.addWidget,
                          widget: BlocProvider(
                            create: (context) =>
                                ChatBloc(chatRepository: locator()),
                            child: ChatScreen(
                              advisorId: expert.advisorId,
                              advisorAvatar: expert.image,
                              advisorName: expert.name,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding6,
                          horizontal: SizeConfig.padding16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              UiConstants.kProfileBorderColor.withOpacity(.06),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                          border: Border.all(
                            width: SizeConfig.border1,
                            color: UiConstants.kTextColor6.withOpacity(.1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              color: UiConstants.kTextColor,
                              size: SizeConfig.body4,
                            ),
                            SizedBox(width: SizeConfig.padding4),
                            Text(
                              'Chat Now',
                              style: TextStyles.sourceSansSB.body4.colour(
                                UiConstants.kTextColor,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding14,
                              child: const VerticalDivider(
                                color: UiConstants.grey6,
                                thickness: 0.6,
                              ),
                            ),
                            Text(
                              'Free',
                              style: TextStyles.sourceSansSB.body4.colour(
                                UiConstants.teal3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<CartBloc>().add(
                              AddToCart(
                                advisor: expert,
                              ),
                            );
                        return onBookCall();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding6,
                          horizontal: SizeConfig.padding16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              UiConstants.kProfileBorderColor.withOpacity(.06),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                          border: Border.all(
                            width: SizeConfig.border1,
                            color: UiConstants.kTextColor6.withOpacity(.1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_outlined,
                              color: UiConstants.kTextColor,
                              size: SizeConfig.body4,
                            ),
                            SizedBox(width: SizeConfig.padding4),
                            Text(
                              'Book a Call',
                              style: TextStyles.sourceSansSB.body4.colour(
                                UiConstants.kTextColor,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding14,
                              child: const VerticalDivider(
                                color: UiConstants.grey6,
                                thickness: 0.6,
                              ),
                            ),
                            Text(
                              expert.rateNew.split('/').first,
                              style: TextStyles.sourceSansSB.body4.colour(
                                UiConstants.teal3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExpertiseTags() {
    final expertiseTags = expert.expertise.split(',');
    final tagsToUse = expertiseTags;

    return tagsToUse.map((tag) {
      return Container(
        margin: EdgeInsets.only(top: SizeConfig.padding6),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding8,
          vertical: SizeConfig.padding4,
        ),
        decoration: BoxDecoration(
          color: UiConstants.teal4.withOpacity(.3),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Text(
          tag.trim(),
          style: TextStyles.sourceSansM.body6.colour(
            UiConstants.teal3,
          ),
        ),
      );
    }).toList();
  }
}
