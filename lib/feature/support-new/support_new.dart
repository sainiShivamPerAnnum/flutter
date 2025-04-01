import 'package:felloapp/feature/support-new/bloc/support_bloc.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  const SupportViewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
            SupportData() => Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
                child: SingleChildScrollView(
                  controller: RootController.controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.padding14),
                      const TitleSubtitleContainer(
                        title: "Support",
                        zeroPadding: true,
                        largeFont: true,
                      ),
                      ...state.supportItems,
                      SizedBox(
                        height: 60.h,
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
