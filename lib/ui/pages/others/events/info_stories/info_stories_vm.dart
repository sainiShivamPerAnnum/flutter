import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/story_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/widgets/fello_rich_text.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:story_view/story_view.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/core/repository/getters_repo.dart';

// import 'story';
class InfoStoriesViewModel extends BaseViewModel {
  final controller = StoryController();
  final _getterRepo = locator<GetterRepository>();
  BoxDecoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
        colors: [Color(0xFF009D91), Color(0xFF032A2E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter),
  );
  TextStyle captionTextStyle = TextStyles.sourceSans.body2;
  List<StoryItemModel> storyItemData;
  List<StoryItem> storyItems;

  _loadAssetsAndData(String topic) async {
    setState(ViewState.Busy);
    final response = await _getterRepo.getStory(topic: topic ?? 'onboarding');
    if (response.isSuccess()) {
      storyItemData = response.model;
      storyItems = [];
      storyItemData.forEach((StoryItemModel element) {
        storyItems.add(StoryItem.pageImage(
            controller: controller,
            duration: Duration(seconds: 5),
            url: element.assetUri,
            captionWidget: Wrap(
              children: [
                Container(
                    width: SizeConfig.navBarWidth,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                      vertical: SizeConfig.screenHeight * 0.16,
                    ),
                    alignment: Alignment.center,
                    child: FelloRichText(paragraph: element.richText)),
              ],
            ),
            textStyle: captionTextStyle,
            decoration: backgroundDecoration));
      });
      setState(ViewState.Idle);
    } else {
      //What to do on Api Failure
    }
  }

  init(String topic) async {
    await _loadAssetsAndData(topic);
  }

  dump() {}
}
