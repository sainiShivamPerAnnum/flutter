import 'dart:developer';

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/help_and_support/faq/faq_page_vm.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter_html/flutter_html.dart';

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
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.only(top: SizeConfig.padding8),
                  child: ListView.separated(
                    itemCount: model.list.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        model.list[index].title,
                        style: TextStyles.sourceSans.body1,
                      ),
                      minVerticalPadding: SizeConfig.padding8,
                      style: ListTileStyle.list,
                      onTap: () {
                        final desc = model.list[index].description;
                        // log(desc);
                        showBottomSheet(
                          context: context,
                          backgroundColor: UiConstants.kBackgroundColor,
                          constraints: BoxConstraints(
                            maxHeight: SizeConfig.screenHeight * 0.6,
                          ),
                          enableDrag: true,
                          elevation: 2,
                          builder: (ctx) => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: SizeConfig.padding8,
                                width: SizeConfig.screenWidth * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      SizeConfig.roundness16,
                                    ),
                                  ),
                                  color: Colors.white,
                                ),
                                margin: EdgeInsets.only(
                                  top: SizeConfig.padding6,
                                  bottom: SizeConfig.padding8,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  model.list[index].title,
                                  style: TextStyles.sourceSans.body2,
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children: [
                                    Html(
                                      style: {
                                        "html": Style(color: Colors.white),
                                        "body": Style(color: Colors.white),
                                        "p": Style(color: Colors.white),
                                        "span": Style(color: Colors.white),
                                      },
                                      data: desc,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
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
}
