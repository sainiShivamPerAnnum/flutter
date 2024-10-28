import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/feature/live/live_root.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopLive extends StatelessWidget {
  const TopLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, LiveHome?>(
      builder: (_, liveData, __) {
        return (liveData == null)
            ? const SizedBox.shrink()
            : liveData.recent.isEmpty && liveData.live.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.padding14),
                      TitleSubtitleContainer(
                        title: liveData.live.isNotEmpty
                            ? "Live"
                            : "Recent Live Streams",
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
                                if (liveData.live.isNotEmpty)
                                  buildLiveSection(liveData.live),
                                if (liveData.live.isEmpty)
                                  buildRecentSection(liveData.recent),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
      },
      selector: (_, model) => model.liveData,
    );
  }
}
