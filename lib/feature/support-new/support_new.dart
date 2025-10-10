import 'package:felloapp/feature/support-new/bloc/support_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportNewPage extends StatelessWidget {
  const SupportNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc()..add(const LoadSupportData()),
      child: const SupportViewWrapper(),
    );
  }
}

class SupportViewWrapper extends StatelessWidget {
  const SupportViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: false,
      backgroundColor: UiConstants.bg,
      body: SafeArea(
        child: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: UiConstants.primaryColor,
          backgroundColor: Colors.black,
          onRefresh: () async {
            BlocProvider.of<SupportBloc>(
              context,
              listen: false,
            ).add(const LoadSupportData());
            return;
          },
          child: BlocBuilder<SupportBloc, SupportState>(
            builder: (context, state) {
              return switch (state) {
                LoadingSupportData() => const FullScreenLoader(),
                SupportData() => SingleChildScrollView(
                    controller: RootController.controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            BackButton(
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                              ),
                              color: UiConstants.kTextColor,
                              onPressed: () {
                                AppState.backButtonDispatcher!.didPopRoute();
                              },
                            ),
                            const TitleSubtitleContainer(
                              title: "Support",
                              zeroPadding: true,
                              largeFont: true,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...state.supportItems,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}
