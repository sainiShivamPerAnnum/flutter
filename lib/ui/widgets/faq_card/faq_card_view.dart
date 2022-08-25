import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FAQCardView extends StatelessWidget {
  final String category;
  final bool catTitle;
  final Color bgColor;

  FAQCardView({@required this.category, this.catTitle, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return BaseView<FAQCardViewModel>(
        onModelReady: (model) => model.init(category),
        builder: (ctx, model, child) {
          return Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              color: bgColor ?? UiConstants.kBackgroundColor,
            ),
            padding: EdgeInsets.only(
                top: SizeConfig.padding12, bottom: SizeConfig.padding24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (catTitle != null && catTitle == true)
                      ? category.replaceAll("_", " ").toUpperCase()
                      : "FAQs",
                  style: TextStyles.title3.semiBold.colour(Colors.white),
                ),
                SizedBox(height: 10),
                model.state == ViewState.Busy
                    ? Container(
                        height: SizeConfig.screenHeight * 0.2,
                        child: Center(
                          child: SpinKitWave(
                            color: UiConstants.primaryColor,
                            size: 30,
                          ),
                        ),
                      )
                    : (model.faqHeaders != null && model.faqHeaders.length > 0
                        ? _buildItems(model, context)
                        : Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(Assets.noData,
                                    height: SizeConfig.screenHeight * 0.2),
                                Text(
                                  "No FAQs available at the moment",
                                  style: TextStyles.body2.colour(Colors.white),
                                ),
                                SizedBox(height: SizeConfig.padding16)
                              ],
                            ),
                          ))
              ],
            ),
          );
        });
  }

  _buildItems(FAQCardViewModel model, BuildContext context) {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      child: Container(
        width: SizeConfig.screenWidth,
        child: Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white, // here for close state
                colorScheme: ColorScheme.light(
                  primary: Colors.white,
                ), // here for open state in replacement of deprecated accentColor
                dividerColor:
                    Colors.transparent, // if you want to remove the border
              ),
              child: Column(
                //   animationDuration: Duration(milliseconds: 600),
                //   expandedHeaderPadding: EdgeInsets.all(0),
                //   dividerColor: UiConstants.kDividerColor,

                //   elevation: 0,
                children: List.generate(
                  model.faqHeaders.length,
                  (index) => ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: _prizeFAQHeader(model.faqHeaders[index]),
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(model.faqResponses[index],
                            textAlign: TextAlign.start,
                            style: TextStyles.body3
                                .colour(UiConstants.kFAQsAnswerColor)),
                      ),
                    ],
                  ),
                ),
                // expansionCallback: (i, isOpen) {
                //   model.updateDetStatus(i, !isOpen);
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _prizeFAQHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.padding20,
        bottom: SizeConfig.padding20,
      ),
      child:
          Text(title, style: TextStyles.sourceSans.body2.colour(Colors.white)),
    );
  }
}
