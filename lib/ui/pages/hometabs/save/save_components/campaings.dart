import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Campaigns extends StatelessWidget {
  const Campaigns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CampaignCardSection();
  }
}

class CampaignCardSection extends StatelessWidget {
  const CampaignCardSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SaveViewModel>(
      builder: (_, model, __) {
        return model.isChallengesLoading
            ? const SizedBox()
            : Container(
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding14,
                  horizontal: SizeConfig.padding20,
                ).copyWith(
                  bottom: SizeConfig.padding8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.padding16 + SizeConfig.padding2,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.padding152,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.padding16),
                        child: PageView.builder(
                          controller: model.offersController,
                          itemCount: model.ongoingEvents!.length,
                          onPageChanged: (page) {
                            model.currentPage = page;
                          },
                          itemBuilder: (context, index) {
                            final event = model.ongoingEvents![index];
                            return event.bgImage != ''
                                ? GestureDetector(
                                    onTap: () {
                                      model.trackChallengeTapped(
                                        event.bgImage,
                                        event.type,
                                        index,
                                      );
                                      AppState.delegate!
                                          .parseRoute(Uri.parse(event.type));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness16,
                                        ),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            event.bgImage,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : CustomCampaignCard(
                                    ontap: () {
                                      AppState.delegate!.parseRoute(
                                        Uri.parse(
                                          event.type + (event.misc['id'] ?? ''),
                                        ),
                                      );
                                      model.trackChallengeTapped(
                                        event.bgImage,
                                        event.type,
                                        index,
                                      );
                                    },
                                    title: event.title,
                                    description: event.subtitle,
                                    buttonText: event.ctaText,
                                    imageUrl: event.thumbnail,
                                  );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.padding14),
                      child: Wrap(
                        children: List.generate(
                          model.ongoingEvents!.length,
                          (index) => Padding(
                            padding: EdgeInsets.all(SizeConfig.padding2),
                            child: CircleAvatar(
                              backgroundColor: model.currentPage == index
                                  ? Colors.white
                                  : Colors.grey,
                              radius: SizeConfig.padding3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class CustomCampaignCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final String imageUrl;
  final VoidCallback ontap;

  const CustomCampaignCard({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.imageUrl,
    required this.ontap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding18,
          vertical: SizeConfig.padding14,
        ),
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyles.sourceSansSB.body6.colour(
                          UiConstants.kTabBorderColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding8),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyles.sourceSansSB.body2,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding12,
                  ),
                  ElevatedButton(
                    onPressed: ontap,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 0),
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding6,
                        horizontal: SizeConfig.padding12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.roundness5,
                        ),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyles.sourceSansSB.body4
                          .colour(UiConstants.textColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: SizeConfig.padding14,
            ),
            CircleAvatar(
              radius: SizeConfig.padding34,
              backgroundImage: NetworkImage(imageUrl),
            ),
          ],
        ),
      ),
    );
  }
}
