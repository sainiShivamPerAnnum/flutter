import 'package:felloapp/core/model/ui_config_models/instant_save_card.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class InstantSaveCard extends StatefulWidget {
  const InstantSaveCard({
    super.key,
  });

  @override
  State<InstantSaveCard> createState() => _InstantSaveCardState();
}

class _InstantSaveCardState extends State<InstantSaveCard> {
  InstantSaveCardConfig? config;
  GetterRepository? repository;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    repository = locator<GetterRepository>();
    repository?.getInstantSaveCardConfig().then((value) {
      isLoading = false;
      if (value.isSuccess()) {
        config = value.model?.data;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    repository = null; // For better GC.
    config = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = config?.leftImg;
    final foregroundImage = config?.rightImg;

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (backgroundImage == null && foregroundImage == null) {
      return const SizedBox.square();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding20,
        vertical: SizeConfig.padding20,
      ),
      child: Column(
        children: [
          const Row(
            children: [
              TitleSubtitleContainer(
                padding: EdgeInsets.zero,
                title: "Instant Save",
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          AspectRatio(
            aspectRatio: config!.aspectRatio.toDouble(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (backgroundImage != null)
                  ActionableImage(
                    config: backgroundImage,
                  ),
                if (foregroundImage != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ActionableImage(
                      config: foregroundImage,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the the image as configuration from [config].
class ActionableImage extends StatelessWidget {
  final ImageConfig config;

  const ActionableImage({
    required this.config,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppState.delegate!.parseRoute(
        Uri.parse(config.actionUri),
      ),
      child: Image.network(
        config.imgUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
