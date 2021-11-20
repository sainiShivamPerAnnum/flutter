import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
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

  FAQCardView({@required this.category, this.catTitle});

  @override
  Widget build(BuildContext context) {
    return BaseView<FAQCardViewModel>(
        onModelReady: (model) => model.init(category),
        builder: (ctx, model, child) {
          return Container(
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(5, 5),
                      spreadRadius: 5,
                      blurRadius: 5)
                ]),
            margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            padding: EdgeInsets.only(
                top: 12, left: 10, bottom: SizeConfig.padding24),
            child: Column(
              children: [
                Text(
                  (catTitle != null && catTitle == true)
                      ? category.toUpperCase()
                      : "FAQs",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: SizeConfig.largeTextSize,
                    fontWeight: FontWeight.w500,
                  ),
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
                        ? _buildItems(model)
                        : Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(Assets.noData,
                                    height: SizeConfig.screenHeight * 0.2),
                                Text(
                                  "No FAQs available at the moment",
                                  style: TextStyles.body2.light,
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

  _buildItems(FAQCardViewModel model) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: SizeConfig.screenWidth,
        child: Column(
          children: [
            ExpansionPanelList(
              animationDuration: Duration(milliseconds: 600),
              expandedHeaderPadding: EdgeInsets.all(0),
              dividerColor: Colors.grey.withOpacity(0.2),
              elevation: 0,
              children: List.generate(
                model.faqHeaders.length,
                (index) => ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (ctx, isOpen) =>
                      _prizeFAQHeader(model.faqHeaders[index]),
                  isExpanded: model.detStatus[index],
                  body: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                    ),
                    child: Text(model.faqResponses[index],
                        textAlign: TextAlign.start, style: TextStyles.body2),
                  ),
                ),
              ),
              expansionCallback: (i, isOpen) {
                model.updateDetStatus(i, !isOpen);
              },
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
          left: SizeConfig.pageHorizontalMargins),
      child: Text(title, style: TextStyles.body2.bold),
    );
  }
}
