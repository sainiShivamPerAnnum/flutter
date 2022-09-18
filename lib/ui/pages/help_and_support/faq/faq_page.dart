import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/faq_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/help_and_support/faq/faq_page_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter_html/flutter_html.dart' as html;

class FAQPage extends StatelessWidget {
  final FaqsType type;

  const FAQPage({
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: FAppBar(
        title: 'FAQs',
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
      ),
      body: BaseView<FaqPageViewModel>(
        onModelReady: (model) => model.init(type),
        builder: (ctx, model, child) {
          return model.state == ViewState.Busy
              ? Center(
                  child: FullScreenLoader(),
                )
              : Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding8),
                  child: ListView.separated(
                    itemCount: model.list.length,
                    padding: EdgeInsets.only(
                      bottom: SizeConfig.padding12,
                    ),
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        model.list[index].title,
                        style: TextStyles.sourceSans.body3,
                      ),
                      minVerticalPadding: SizeConfig.padding8,
                      style: ListTileStyle.list,
                      onTap: () {
                        showFaqBottomSheet(context, model.list[index]);
                      },
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: UiConstants.kBackgroundColor,
                      thickness: 2,
                      endIndent: SizeConfig.padding20,
                      indent: SizeConfig.padding20,
                      height: SizeConfig.padding28,
                    ),
                  ),
                );
        },
      ),
    );
  }

  void showFaqBottomSheet(BuildContext context, FAQDataModel data) {
    final desc = data.description;
    final style = html.Style(
      color: Colors.white,
      fontSize: html.FontSize(14),
    );

    BaseUtil.openModalBottomSheet(
      backgroundColor: UiConstants.kBackgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness16),
        topRight: Radius.circular(SizeConfig.roundness16),
      ),
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: true,
      content: WillPopScope(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  data.title,
                  style: TextStyles.sourceSans.body1.semiBold,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding12,
                    horizontal: SizeConfig.pageHorizontalMargins),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins / 2,
                      ),
                      child: html.Html(
                        style: {
                          "html": style,
                          "body": style,
                          "p": style,
                          "span": style,
                          "ul": style,
                        },
                        data: desc,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          AppState.backButtonDispatcher.didPopRoute();
          return Future.value(true);
        },
      ),
    );
  }
}
