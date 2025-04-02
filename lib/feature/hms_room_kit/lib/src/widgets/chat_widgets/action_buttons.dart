import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatActionButtons extends StatelessWidget {
  const ChatActionButtons({
    required this.advisorId,
    required this.advisorName,
    required this.advisorImage,
    required this.isLiked,
    required this.onLike,
    required this.onShare,
    super.key,
  });
  final String advisorId;
  final String advisorName;
  final String advisorImage;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            IconButton(
              icon: AppImage(
                Assets.video_share,
                color: Colors.white,
                height: SizeConfig.padding20,
                width: SizeConfig.padding20,
              ),
              onPressed: onShare,
            ),
            Text(
              'Share',
              style: GoogleFonts.sourceSans3(
                fontSize: SizeConfig.body4,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Column(
          children: [
            IconButton(
              icon: AppImage(
                Assets.video_like,
                color: isLiked ? Colors.red : Colors.white,
                height: SizeConfig.padding20,
                width: SizeConfig.padding20,
              ),
              onPressed: onLike,
            ),
            Text(
              'Like',
              style: GoogleFonts.sourceSans3(
                fontSize: SizeConfig.body4,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (advisorId != '' && advisorName != '')
          Column(
            children: [
              IconButton(
                icon: AppImage(
                  Assets.book_call,
                  color: Colors.white,
                  height: SizeConfig.padding20,
                  width: SizeConfig.padding20,
                ),
                onPressed: () {
                  AppState.screenStack.add(ScreenItem.modalsheet);
                  // a bug is here image won't come here
                  context.read<CartBloc>().add(
                        AddToCart(
                          advisor: Expert(
                            advisorId: advisorId,
                            name: advisorName,
                            image: '',
                            experience: '',
                            rate: 0,
                            rateNew: '',
                            rating: 0,
                            expertise: '',
                            qualifications: '',
                            isFree: false,
                          ),
                        ),
                      );
                  BaseUtil.openBookAdvisorSheet(
                    advisorId: advisorId,
                    advisorName: advisorName,
                    advisorImage: advisorImage,
                    isEdit: false,
                  );
                },
              ),
              Text(
                'Book a call',
                style: GoogleFonts.sourceSans3(
                  fontSize: SizeConfig.body4,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
