import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart'
    as sections;
import 'package:felloapp/util/action_resolver.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart' hide Action;

class ImageSection extends StatelessWidget {
  const ImageSection({required this.data, super.key});
  final sections.ImageSectionData data;

  void _onTapImage() {
    final action = data.action;
    if (action == null) return;

    ActionResolver.instance.resolve(action);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: InkWell(
        onTap: _onTapImage,
        child: CachedNetworkImage(
          imageUrl: data.url,
        ),
      ),
    );
  }
}
