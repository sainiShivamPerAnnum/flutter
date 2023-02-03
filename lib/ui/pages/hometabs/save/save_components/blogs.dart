import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Blogs extends StatelessWidget {
  final SaveViewModel model;
  const Blogs({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.padding8),
        GestureDetector(
          onTap: () {
            model.navigateToViewAllBlogs();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleSubtitleContainer(
                title: locale.blogsTitle,
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: SizeConfig.padding12,
                  bottom: SizeConfig.padding12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.padding2),
                      child: Text(
                        locale.btnSeeAll,
                        style: TextStyles.rajdhaniSB.body2,
                      ),
                    ),
                    SvgPicture.asset(
                      Assets.chevRonRightArrow,
                      height: SizeConfig.padding24,
                      width: SizeConfig.padding24,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SaveBlogSection(model: model),
      ],
    );
  }
}

class SaveBlogSection extends StatelessWidget {
  final SaveViewModel model;
  const SaveBlogSection({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.padding24, top: SizeConfig.padding10),
        child: Container(
          height: SizeConfig.screenWidth! * 0.4,
          child: model.isLoading
              ? ListView.builder(
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding10),
                      child: Container(
                        width: SizeConfig.screenWidth! - 80,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                            color: UiConstants.kSecondaryBackgroundColor),
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.padding6),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: UiConstants.kUserRankBackgroundColor,
                                highlightColor: UiConstants.kBackgroundColor,
                                child: Container(
                                  height: SizeConfig.screenWidth! * 0.23,
                                  width: SizeConfig.screenWidth! * 0.25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                      color: UiConstants.kBackgroundColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : model.blogPosts == null || model.blogPosts!.isEmpty
                  ? SizedBox()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: model.blogPosts!.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: SizeConfig.padding10),
                          child: SaveBlogTile(
                            onTap: () {
                              model.trackBannerClickEvent(index);

                              model.navigateToBlogWebView(
                                  model.blogPosts![index].slug,
                                  model.blogPosts![index].acf!.categories);
                            },
                            title: model.blogPosts![index].acf!.categories!,
                            description:
                                model.blogPosts![index].title!.rendered!,
                            imageUrl: model.blogPosts![index].yoastHeadJson!,
                          ),
                        );
                      },
                    ),
        ));
  }
}

class BlogWebView extends StatelessWidget {
  final String? initialUrl;
  final String? title;
  const BlogWebView({Key? key, this.initialUrl, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor3,
        leading: FelloAppBarBackButton(),
        centerTitle: true,
        title: Text(title ?? 'Title', style: TextStyles.rajdhaniSB.title5),
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: WebView(
        initialUrl: initialUrl,
        backgroundColor: UiConstants.kBackgroundColor,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class SaveBlogTile extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final String? description;
  final String? imageUrl;

  const SaveBlogTile({
    Key? key,
    this.onTap,
    this.title,
    this.description,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final document = parse(description);
    // final String parsedDesc = parse(document.body.text).documentElement.text;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.screenWidth! - 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            height: SizeConfig.screenWidth! * 0.4,
            width: SizeConfig.screenWidth,
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }
}
