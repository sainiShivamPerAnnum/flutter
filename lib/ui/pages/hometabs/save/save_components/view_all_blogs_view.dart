import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewAllBlogsView extends StatelessWidget {
  const ViewAllBlogsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SaveViewModel>(
        onModelReady: (model) => model.getAllBlogs(),
        builder: ((context, model, child) => Scaffold(
              backgroundColor: UiConstants.kBackgroundColor,
              appBar: AppBar(
                leading: FelloAppBarBackButton(),
                elevation: 0,
                backgroundColor: UiConstants.kBackgroundColor,
                title: Text('Blogs', style: TextStyles.rajdhaniSB.title5),
                centerTitle: false,
              ),
              body: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.padding24,
                    right: SizeConfig.padding24,
                    top: SizeConfig.padding24),
                child: Column(
                  children: [
                    model.isLoading
                        ? BlogsLoadingShimmerWidget(
                            model: model,
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: model.blogPosts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig.padding16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        index == 0
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        SizeConfig.padding16),
                                                child: Text(
                                                  '${model.blogPosts[index].acf.categories}',
                                                  style: TextStyles
                                                      .rajdhaniM.body2,
                                                ),
                                              )
                                            : index ==
                                                    model.blogPosts.length - 1
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: SizeConfig
                                                            .padding16),
                                                    child: Text(
                                                      '${model.blogPosts[index].acf.categories}',
                                                      style: TextStyles
                                                          .rajdhaniM.body2,
                                                    ),
                                                  )
                                                : model.blogPosts[index].acf
                                                            .categories
                                                            .compareTo(model
                                                                .blogPosts[
                                                                    index - 1]
                                                                .acf
                                                                .categories) ==
                                                        0
                                                    ? SizedBox()
                                                    : Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: SizeConfig
                                                                .padding16),
                                                        child: Text(
                                                          '${model.blogPosts[index].acf.categories}',
                                                          style: TextStyles
                                                              .rajdhaniM.body2,
                                                        ),
                                                      ),
                                        SaveBlogTile(
                                          isFullScreen: true,
                                          blogSideFlagColor:
                                              model.getRandomColor(),
                                          onTap: () {
                                            model.navigateToBlogWebView(
                                                model.blogPosts[index].slug);
                                          },
                                          title: model
                                              .blogPosts[index].acf.categories,
                                          description: model
                                              .blogPosts[index].title.rendered,
                                          imageUrl: model
                                              .blogPosts[index].yoastHeadJson,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          )
                  ],
                ),
              ),
            )));
  }
}

class BlogsLoadingShimmerWidget extends StatelessWidget {
  final SaveViewModel model;

  const BlogsLoadingShimmerWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(top: SizeConfig.padding38),
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.padding16),
              child: Container(
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: Container(
                          height: SizeConfig.screenWidth * 0.4,
                          width: SizeConfig.padding28,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight:
                                    Radius.circular(SizeConfig.roundness12),
                                bottomRight:
                                    Radius.circular(SizeConfig.roundness12),
                              ),
                              color: model.getRandomColor())),
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                      child: Container(
                          color: UiConstants.kSecondaryBackgroundColor,
                          height: SizeConfig.screenWidth * 0.4,
                          width: SizeConfig.screenWidth * 0.5,
                          alignment: Alignment.centerLeft),
                    ),
                    Positioned(
                        left: SizeConfig.screenWidth * 0.34,
                        child: Container(
                          height: SizeConfig.screenWidth * 0.4,
                          width: SizeConfig.screenWidth * 0.525,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness12),
                              color: Colors.black),
                          child: Shimmer.fromColors(
                            baseColor: UiConstants.kUserRankBackgroundColor,
                            highlightColor: UiConstants.kBackgroundColor,
                            child: Container(
                              height: SizeConfig.screenWidth * 0.4,
                              width: SizeConfig.screenWidth * 0.525,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness12),
                                  color: Colors.black),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            );
          }),
    ));
  }
}
