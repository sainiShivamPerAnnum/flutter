import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class Campaigns extends StatelessWidget {
  final SaveViewModel model;
  const Campaigns({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CampaignCardSection(saveVm: model);
  }
}

class CampaignCardSection extends StatelessWidget {
  final SaveViewModel saveVm;
  const CampaignCardSection({
    required this.saveVm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return saveVm.isChallengesLoading
        ? const SizedBox()
        : Container(
            height: SizeConfig.screenWidth! * 0.4,
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.padding14,
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  SizeConfig.padding16 + SizeConfig.padding2),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SizeConfig.padding16),
                    child: PageView.builder(
                      controller: saveVm.offersController,
                      itemCount: saveVm.ongoingEvents!.length,
                      onPageChanged: (page) {
                        saveVm.currentPage = page;
                      },
                      itemBuilder: (context, index) {
                        final event = saveVm.ongoingEvents![index];
                        return GestureDetector(
                          onTap: () {
                            saveVm.trackChallengeTapped(
                                event.bgImage, event.type, index);
                            AppState.delegate!
                                .parseRoute(Uri.parse(event.type));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness16),
                              image: DecorationImage(
                                  image:
                                      CachedNetworkImageProvider(event.bgImage),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.padding14),
                    child: Wrap(
                      children: List.generate(
                        saveVm.ongoingEvents!.length,
                        (index) => Padding(
                          padding: EdgeInsets.all(SizeConfig.padding2),
                          child: CircleAvatar(
                            backgroundColor: saveVm.currentPage == index
                                ? Colors.white
                                : Colors.grey,
                            radius: SizeConfig.padding3,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
