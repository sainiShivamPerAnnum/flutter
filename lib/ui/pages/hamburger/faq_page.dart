import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/faq_card.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_view.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FAQPage extends StatefulWidget {
  FAQPage({this.onPush});

  final ValueChanged<String> onPush;

  @override
  State createState() {
    return _FAQList(onPush: onPush);
  }
}

class _FAQList extends State<FAQPage> {
  _FAQList({this.onPush});

  final ValueChanged<String> onPush;
  Log log = new Log('FAQPage');
  BaseUtil baseProvider;
  List<Item> _faqs;

  @override
  void initState() {
    super.initState();
    _faqs = generateItems(8);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    List<String> faqheaders = [], faqAnswers = [];
    faqheaders.addAll(Assets.faqHeaders);
    faqheaders.addAll(Assets.goldFaqHeaders);
    faqAnswers.addAll(Assets.faqAnswers);
    faqAnswers.addAll(Assets.goldFaqAnswers);
    return new Scaffold(
        body: HomeBackground(
      whiteBackground: WhiteBackground(
        height: SizeConfig.screenHeight * 0.2,
      ),
      child: Column(
        children: [
          FelloAppBar(
            leading: FelloAppBarBackButton(),
            title: "FAQs",
          ),
          Expanded(
            child: Container(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  // FAQCard(
                  //   faqheaders,
                  //   faqAnswers,
                  // ),
                  FAQCardView(
                    category: FAQCardViewModel.FAQ_CAT_GENERAL,
                    catTitle: true,
                  ),
                  FAQCardView(
                    category: FAQCardViewModel.FAQ_CAT_AUGMONT,
                    catTitle: true,
                  ),
                ],
              ),
              //  ListView(
              //   children: [_buildFAQBody()],
              // ),
            ),
          ),
        ],
      ),
    ));
  }

  List<Item> generateItems(int numberOfItems) {
    List<Item> _list = [];
    for (int i = 0; i < Assets.faqHeaders.length; i++) {
      _list.add(Item(
          headerValue: Assets.faqHeaders[i],
          expandedValue: Assets.faqAnswers[i],
          isExpanded: false));
    }
    return _list;
  }

  Widget _buildFAQBody() {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        _faqs[index].isExpanded = !isExpanded;
        setState(() {});
      },
      children: _faqs.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            canTapOnHeader: true,
            body: ListTile(
              contentPadding: EdgeInsets.only(
                bottom: SizeConfig.blockSizeHorizontal * 5,
                left: SizeConfig.blockSizeHorizontal * 5,
                right: SizeConfig.blockSizeHorizontal * 5,
              ),
              title: Text(
                item.expandedValue,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.grey[800],
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w500),
              ),
              //subtitle: Text(item.expandedValue),
            ),
            isExpanded: item.isExpanded);
      }).toList(),
    );
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
