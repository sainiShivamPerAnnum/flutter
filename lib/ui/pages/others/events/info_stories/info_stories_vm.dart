import 'package:felloapp/core/model/story_model.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/assets.dart';
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

  _loadAssetsAndData() async {
    final response = await _getterRepo.getStory(topic: 'onboarding');
    if (response.code != 200) {
      //failed
    }

    storyItemData = response.model;
    storyItems = [];
    storyItemData.forEach((StoryItemModel element) {
      storyItems.add(StoryItem.pageImage(
          controller: controller,
          url: element.assetUri,
          caption: element.richText,
          textStyle: captionTextStyle,
          decoration: backgroundDecoration));
    });
  }

  init(String topic) {
    storyItems = [];
    storyItems = [
      StoryItem.text(
        title: "This is a story view",
        backgroundColor: Colors.black,
        textStyle: TextStyles.rajdhaniB.title3,
      ),
      StoryItem.pageImage(
          controller: controller,
          decoration: backgroundDecoration,
          textStyle: captionTextStyle,
          caption:
              "Fello is a game based savings and investment platform for users to save, grow and earn higher returns than a traditional savings bank account. For every ₹100 saved and invested through Fello, users get amazing rewards and incentives",
          url:
              'https://lottie.host/b5b4bc6b-7006-4c02-a29e-2758fa469c23/cF6rCFX8iD.json'),
      StoryItem.pageImage(
          controller: controller,
          decoration: backgroundDecoration,
          textStyle: captionTextStyle,
          caption:
              "We Manish & Shourya are two finance folks who started Fello with the vision of helping people save money in a better way",
          url: "https://assets6.lottiefiles.com/packages/lf20_tuzu65Bu6N.json"),
      StoryItem.pageImage(
          controller: controller,
          decoration: backgroundDecoration,
          textStyle: captionTextStyle,
          caption:
              "We are an AMFI registered mutual fund distributor and all your money is invested directly into a relevant mutual fund.",
          url: "https://assets6.lottiefiles.com/packages/lf20_mGXMLaVUoX.json"),
    ];
  }

  dump() {}
}
