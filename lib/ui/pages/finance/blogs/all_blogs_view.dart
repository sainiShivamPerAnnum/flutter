import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/blogs.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewAllBlogsView extends StatelessWidget {
  const ViewAllBlogsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<SaveViewModel>(
      onModelReady: (model) => model.getAllBlogs(),
      builder: ((context, model, child) => Scaffold(
            backgroundColor: UiConstants.kBackgroundColor,
            appBar: AppBar(
              leading: const FelloAppBarBackButton(),
              elevation: 0,
              backgroundColor: UiConstants.kBackgroundColor,
              title: Text(locale.blogs, style: TextStyles.rajdhaniSB.title5),
              centerTitle: false,
            ),
            body: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.padding24,
              ),
              child: Column(
                children: [
                  model.isLoading
                      ? BlogsLoadingShimmerWidget(
                          model: model,
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: model.blogPostsByCategory!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: SizeConfig.padding16,
                                  left: SizeConfig.padding24,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: SizeConfig.padding16,
                                      ),
                                      child: Text(
                                        '${model.blogPostsByCategory![index].category}',
                                        style: TextStyles.rajdhaniM.body2,
                                      ),
                                    ),
                                    Container(
                                      height: SizeConfig.screenWidth! * 0.4,
                                      child: ListView.builder(
                                        itemCount: model
                                            .blogPostsByCategory![index]
                                            .blogs!
                                            .length,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, j) => Padding(
                                          padding: EdgeInsets.only(
                                            right: SizeConfig.padding12,
                                          ),
                                          child: SaveBlogTile(
                                            onTap: () {
                                              model.navigateToBlogWebView(
                                                model
                                                    .blogPostsByCategory![index]
                                                    .blogs![j]
                                                    .slug,
                                                model
                                                    .blogPostsByCategory![index]
                                                    .category,
                                              );
                                            },
                                            title: model
                                                .blogPostsByCategory![index]
                                                .blogs![j]
                                                .acf!
                                                .categories,
                                            description: model
                                                .blogPostsByCategory![index]
                                                .blogs![j]
                                                .title!
                                                .rendered,
                                            imageUrl: model
                                                .blogPostsByCategory![index]
                                                .blogs![j]
                                                .yoastHeadJson,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding16,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          )),
    );
  }
}

class BlogsLoadingShimmerWidget extends StatelessWidget {
  final SaveViewModel? model;

  const BlogsLoadingShimmerWidget({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding24,
        ),
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                child: Container(
                  width: SizeConfig.screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: UiConstants.kUserRankBackgroundColor,
                        highlightColor: UiConstants.kBackgroundColor,
                        child: Container(
                          color: Colors.black,
                          height: SizeConfig.padding24,
                          width: 100,
                          margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                        ),
                      ),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                        child: Shimmer.fromColors(
                          baseColor: UiConstants.kUserRankBackgroundColor,
                          highlightColor: UiConstants.kBackgroundColor,
                          child: Container(
                            height: SizeConfig.screenWidth! * 0.4,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.roundness12,
                              ),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
