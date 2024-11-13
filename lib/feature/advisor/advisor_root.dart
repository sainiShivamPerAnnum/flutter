import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/advisor/advisor_components/call.dart';
import 'package:felloapp/feature/advisor/advisor_components/live.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvisorPage extends StatelessWidget {
  const AdvisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AdvisorBloc>()..add(const LoadAdvisorData()),
      child: const AdvisorViewWrapper(),
    );
  }
}

class AdvisorViewWrapper extends StatelessWidget {
  const AdvisorViewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: UiConstants.primaryColor,
      backgroundColor: Colors.black,
      onRefresh: () async {
        BlocProvider.of<AdvisorBloc>(
          context,
          listen: false,
        ).add(const LoadAdvisorData());
        return;
      },
      child: BlocBuilder<AdvisorBloc, AdvisorState>(
        builder: (context, state) {
          return switch (state) {
            LoadingAdvisorData() => const FullScreenLoader(),
            ErrorAdvisorData() => NewErrorPage(
                onTryAgain: () {
                  BlocProvider.of<AdvisorBloc>(
                    context,
                    listen: false,
                  ).add(
                    const LoadAdvisorData(),
                  );
                },
              ),
            AdvisorData() => Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.padding14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TitleSubtitleContainer(
                            title: "Advisor Section",
                            zeroPadding: true,
                            largeFont: true,
                          ),
                          GestureDetector(
                            onTap: () {
                              Haptic.vibrate();
                              AppState.delegate!.appState.currentAction =
                                  PageAction(
                                state: PageState.addPage,
                                page: FreshDeskHelpPageConfig,
                              );
                            },
                            child: Icon(
                              Icons.headset_mic_outlined,
                              color: UiConstants.kTextColor,
                              size: SizeConfig.body1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      const Live(),
                      const Call(callType: "upcoming"),
                      const Call(callType: "past"),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                    ],
                  ),
                ),
              ),
          };
        },
      ),
    );
  }
}
