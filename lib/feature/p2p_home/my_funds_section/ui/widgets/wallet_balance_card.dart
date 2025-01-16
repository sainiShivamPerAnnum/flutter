import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/feature/p2p_home/rps/view/learn_more.dart';
import 'package:felloapp/feature/p2p_home/rps/view/view_rps.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.fundBloc,
    super.key,
  });
  final MyFundsBloc fundBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.grey5,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness12,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding12,
        horizontal: SizeConfig.padding18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View your repayments against your deposits',
                  style: TextStyles.sourceSansSB.body2,
                  maxLines: 2,
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          widget: const LearmMoreOnRPS(),
                          page: RpsLearnMorePageConfig,
                        );
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size(0, 0),
                        ),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding12,
                            vertical: SizeConfig.padding6,
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          const BorderSide(
                            color: UiConstants.kTextColor,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.roundness5),
                            ),
                            side: const BorderSide(
                              color: UiConstants.kTextColor,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        'Learn More',
                        style: TextStyles.sourceSansSB.body4
                            .colour(UiConstants.kTextColor),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.padding14,
                    ),
                    GestureDetector(
                      onTap: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          widget: const RpsView(),
                          page: FlexiBalancePageConfig,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding12,
                          vertical: SizeConfig.padding6,
                        ),
                        decoration: BoxDecoration(
                          color: UiConstants.kTextColor,
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                        child: Text(
                          'View Now',
                          style: TextStyles.sourceSansSB.body4.colour(
                            UiConstants.kTextColor4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: SizeConfig.padding16,
          ),
          AppImage(
            Assets.rpsSvg,
            width: SizeConfig.padding82,
            height: SizeConfig.padding64,
          ),
        ],
      ),
    );
  }
}
