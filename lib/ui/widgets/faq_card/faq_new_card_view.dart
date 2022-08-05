import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../../util/styles/size_config.dart';
import '../../../util/styles/textStyles.dart';
import '../../../util/styles/ui_constants.dart';
import '../../architecture/base_view.dart';
import '../../pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'faq_card_vm.dart';

class FAQsComponent extends StatelessWidget {
  const FAQsComponent({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    return BaseView<FAQCardViewModel>(
        onModelReady: (model) => model.init(category),
        builder: (ctx, model, child) {
          return Container(
            padding: EdgeInsets.all(SizeConfig.padding26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FAQs",
                  style: TextStyles.title3.bold.colour(Colors.white),
                ),
                SizedBox(
                  height: SizeConfig.padding26,
                ),
                model.faqHeaders.isEmpty
                    ? ListLoader(bottomPadding: true)
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: model.faqHeaders.length,
                        itemBuilder: (context, index) {
                          return FAQItemView(
                            header: model.faqHeaders[index],
                            response: model.faqResponses[index],
                            isLastIndex: index == model.faqHeaders.length - 1
                                ? true
                                : false,
                          );
                        },
                      ),
                SizedBox(
                  height: SizeConfig.padding26,
                ),
              ],
            ),
          );
        });
  }
}

//Following is the itemview, for the FAQ Component
class FAQItemView extends StatefulWidget {
  const FAQItemView({
    Key key,
    @required this.header,
    @required this.response,
    @required this.isLastIndex,
  }) : super(key: key);
  final String header;
  final String response;
  final bool isLastIndex;

  @override
  State<FAQItemView> createState() => _FAQItemViewState();
}

class _FAQItemViewState extends State<FAQItemView> {
  bool isBoxOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: SizeConfig.padding12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Question with exapnd button
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              setState(() {
                isBoxOpen = !isBoxOpen;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.header,
                    style: TextStyles.body2.colour(Colors.white),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                Icon(
                  isBoxOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.white,
                )
              ],
            ),
          ),
          isBoxOpen
              ? SizedBox(
                  height: SizeConfig.padding16,
                )
              : SizedBox.shrink(),
          //Answer
          isBoxOpen
              ? Text(
                  widget.response,
                  style: TextStyles.body3.colour(UiConstants.kFAQsAnswerColor),
                )
              : SizedBox.shrink(),

          isBoxOpen
              ? SizedBox(
                  height: SizeConfig.padding12,
                )
              : SizedBox.shrink(),

          //Acts as the divider
          widget.isLastIndex
              ? SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
                  width: double.infinity,
                  height: 1.5,
                  color: UiConstants.kFAQDividerColor,
                )
        ],
      ),
    );
  }
}
