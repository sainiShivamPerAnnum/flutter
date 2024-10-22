import 'package:felloapp/feature/live/live_root.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class TopLive extends StatelessWidget {
  final SaveViewModel model;
  const TopLive({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (model.liveData == null)
        ? const SizedBox.shrink()
        : model.liveData!.recent.isEmpty && model.liveData!.live.isEmpty
            ? const SizedBox.shrink()
            : Column(
                children: [
                  SizedBox(height: SizeConfig.padding14),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TitleSubtitleContainer(
                          title: model.liveData!.live.isNotEmpty
                              ? "Live"
                              : "Recent Live Streams",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding14),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding16,
                    ),
                    child: SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            buildLiveSection(model.liveData!.live),
                            if (model.liveData!.live.isEmpty)
                              buildRecentSection(model.liveData!.recent),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}
