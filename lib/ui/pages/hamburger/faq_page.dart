import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_view.dart';
import 'package:felloapp/ui/widgets/faq_card/faq_card_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    FAQCardView(
                      category: FAQCardViewModel.FAQ_CAT_GENERAL,
                      catTitle: true,
                    ),
                    FAQCardView(
                      category: FAQCardViewModel.FAQ_CAT_AUGMONT,
                      catTitle: true,
                    ),
                    FAQCardView(
                      category: FAQCardViewModel.FAQ_CAT_REFERRALS,
                      catTitle: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
