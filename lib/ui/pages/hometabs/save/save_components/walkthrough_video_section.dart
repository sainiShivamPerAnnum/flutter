import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/youtube_player_view.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class WalthroughVideosSection extends StatelessWidget {
  const WalthroughVideosSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List videos = [
      "https://www.youtube.com/watch?v=mzaIjBjUM1Y",
      "https://www.youtube.com/watch?v=CDokUdux0rc",
      "https://www.youtube.com/watch?v=zFhYJRqz_xk"
    ];
    return SizedBox(
      height: SizeConfig.screenWidth! * 0.36,
      width: SizeConfig.screenWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (ctx, i) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
          color: Colors.black,
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
          child: GestureDetector(
            onTap: () => AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addWidget,
                page: YoutubePlayerViewConfig,
                widget: YoutubePlayerView(url: videos[i])),
            child: Container(
              width: SizeConfig.screenWidth! * 0.66,
              height: SizeConfig.screenWidth! * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://img.youtube.com/vi/${videos[i].substring(videos[i].length - 11)}/0.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/e/ef/Youtube_logo.png",
                width: SizeConfig.padding54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
