import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/custom_card/save_container.dart';
import 'package:felloapp/ui/pages/static/save_assets_footer.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../util/assets.dart';

class NewUserSaveView extends StatelessWidget {
  const NewUserSaveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff232326),
      appBar: FAppBar(
        showAvatar: false,
        title: "Save",
        type: FaqsType.savings,
        style: TextStyle(
          color: Color(0xffBDBDBE),
        ),
      ),

      //Horizontal Padding for each widget is 24px
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
              child: Text(
                "Take your first step\nto start an investment",
                style: TextStyles.rajdhaniSB.body1,
              ),
            ),
            SizedBox(
              height: SizeConfig.padding14,
            ),
            ...getAssetWidget(),
            SizedBox(
              height: SizeConfig.padding28,
            ),
            Center(
              child: Text(
                "100% Safe & Secure",
                style: TextStyles.sourceSans.body3
                    .colour(
                      Colors.white.withOpacity(0.6),
                    )
                    .copyWith(letterSpacing: 1.12),
              ),
            ),
            SizedBox(
              height: SizeConfig.padding10,
            ),
            SaveAssetsFooter(),
            SizedBox(height: SizeConfig.navBarHeight),

            
          ],
        ),
      ),
    );
  }

  List<Widget> getAssetWidget() {
    List<Widget> children = [];
    DynamicUiUtils.saveViewOrder[0].forEach(
      (element) {
        if (element == "LB") {
          children.add(
            SaveContainer(
              investmentType: InvestmentType.LENDBOXP2P,
              isPopular: true,
            ),
          );
        } else if (element == "AG") {
          children.add(SaveContainer(
            investmentType: InvestmentType.AUGGOLD99,
          ));
        }
      },
    );

    return children;
  }
}
