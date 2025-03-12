import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Blogs extends StatelessWidget {
  const Blogs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: 24.h,
      ),
      child: Consumer<SaveViewModel>(
        builder: (_, model, __) {
          return Column(
            children: [
              SizedBox(height: SizeConfig.padding14),
              GestureDetector(
                onTap: model.navigateToViewAllBlogs,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "Fin-gyan",
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: SizeConfig.padding12,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'VIEW ALL',
                            style: TextStyles.sourceSans.body4,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 10.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SaveBlogSection(model: model),
            ],
          );
        },
      ),
    );
  }
}

class SaveBlogSection extends StatelessWidget {
  final SaveViewModel model;
  const SaveBlogSection({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, top: 24.h),
      child: SizedBox(
        height: SizeConfig.padding252,
        child: model.isLoading
            ? ListView.builder(
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                cacheExtent: 500,
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
                ? const SizedBox()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.blogPosts!.length,
                    cacheExtent: 500,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: SizeConfig.padding10),
                        child: SaveBlogTile(
                          onTap: () {
                            model.trackBannerClickEvent(index);

                            model.navigateToBlogWebView(
                              model.blogPosts![index].slug,
                              model.blogPosts![index].acf!.categories,
                            );
                          },
                          title: model.blogPosts![index].acf!.categories!,
                          description: model.blogPosts![index].title!.rendered!,
                          imageUrl: model.blogPosts![index].yoastHeadJson!,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class BlogWebView extends StatefulWidget {
  final String? initialUrl;
  final String? title;

  const BlogWebView({Key? key, this.initialUrl, this.title}) : super(key: key);

  @override
  State<BlogWebView> createState() => _BlogWebViewState();
}

class _BlogWebViewState extends State<BlogWebView> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(Colors.black)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.initialUrl!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor3,
        surfaceTintColor: UiConstants.kBackgroundColor3,
        leading: const FelloAppBarBackButton(),
        centerTitle: true,
        title:
            Text(widget.title ?? 'Title', style: TextStyles.rajdhaniSB.title5),
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: WebViewWidget(
        controller: controller!,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.screenWidth! - SizeConfig.padding54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          color: UiConstants.greyVarient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: double.infinity,
                  height: SizeConfig.padding152,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness8),
                      topRight: Radius.circular(SizeConfig.roundness8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness8),
                      topRight: Radius.circular(SizeConfig.roundness8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.fill,
                      fadeInCurve: Curves.easeIn,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.padding16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.padding4),
                  // Title
                  Text(
                    title ?? '',
                    style: TextStyles.sourceSansSB.body2.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),

                  // Subtitle
                  Text(
                    description ?? '',
                    style: TextStyles.sourceSans.body4.colour(
                      UiConstants.kTextColor5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //    Container(
    //     height: SizeConfig.screenWidth! * 0.4,
    //     width: SizeConfig.screenWidth! - SizeConfig.padding54,
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //           image: CachedNetworkImageProvider(imageUrl!),
    //           fit: BoxFit.cover,
    //           alignment: Alignment.centerLeft),
    //       borderRadius: BorderRadius.circular(SizeConfig.roundness12),
    //     ),
    //   ),
    // );
  }
}
