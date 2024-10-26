import 'package:felloapp/feature/live/widgets/video_card.dart';
import 'package:felloapp/feature/support-new/bloc/support_bloc.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Learn extends StatelessWidget {
  const Learn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding24),
        TitleSubtitleContainer(
          titleStyle: TextStyles.sourceSansSB.body1,
          title: "Learn about Fello",
          zeroPadding: true,
        ),
        const LearnFello(),
      ],
    );
  }
}

class LearnFello extends StatelessWidget {
  const LearnFello({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportBloc, SupportState>(
      builder: (context, state) {
        if (state is SupportData) {
          return Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding24),
            child: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < state.introData.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          right: SizeConfig.padding12,
                          bottom: SizeConfig.padding8,
                        ),
                        child: SizedBox(
                          child: VideoCardWidget(
                            title: state.introData[i]['title']!,
                            bgImage: state.introData[i]['bgImage']!,
                            duration: state.introData[i]['duration']!,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
