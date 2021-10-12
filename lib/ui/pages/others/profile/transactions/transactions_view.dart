import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/transactions/tran_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Transactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    print(query.devicePixelRatio);
    print(query.textScaleFactor);
    return BaseView<TranViewModel>(
      onModelReady: (model) {
        model.init();
      },
      child: NoTransactionsContent(),
      builder: (ctx, model, child) {
        return Scaffold(
          appBar: BaseUtil.getAppBar(context, "Transactions"),
          body: model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 3),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 2),
                        height: SizeConfig.screenHeight * 0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilterOption(
                              filterItems: model.tranTypeFilterItems,
                              type: TranFilterType.Type,
                            ),
                            FilterOption(
                              filterItems: model.tranSubTypeFilterItems,
                              type: TranFilterType.Subtype,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: (model.filteredList.length == 0
                            ? child
                            : ListView(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(10),
                                controller: model.tranListController,
                                children: model.getTxns(),
                              )),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class NoTransactionsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/no-transactions.png",
            width: SizeConfig.screenWidth * 0.8,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "No transactions to show yet",
            style: TextStyle(
              fontSize: SizeConfig.largeTextSize,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final Map<String, int> filterItems;
  final TranFilterType type;
  FilterOption({this.filterItems, this.type});

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items = [];

    filterItems.forEach((key, value) {
      items.add(
        DropdownMenuItem(
          child: Text(
            key,
            style: TextStyle(fontSize: SizeConfig.mediumTextSize),
          ),
          value: value,
        ),
      );
    });

    return Consumer<TranViewModel>(builder: (ctx, model, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: UiConstants.primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value:
                  type == TranFilterType.Type ? model.filter : model.subFilter,
              items: items,
              onChanged: (value) {
                if (type == TranFilterType.Type)
                  model.filter = value;
                else
                  model.subFilter = value;
                model.filterTransactions();
              }),
        ),
      );
    });
  }
}
