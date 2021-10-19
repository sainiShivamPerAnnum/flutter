import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/user_coin_service/coin_balance_text.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class FelloCoinBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<FelloCoinBarViewModel>(
      onModelReady: (model) => model.getFlc(),
      builder: (ctx, model, child) => model.state == ViewState.Busy
          ? CircularProgressIndicator()
          : GestureDetector(
              onTap: () {
                BaseUtil.openModalBottomSheet(
                  addToScreenStack: true,
                  backgroundColor: Colors.transparent,
                  content: WantMoreTicketsModalSheet(),
                  hapticVibrate: true,
                  isBarrierDismissable: true,
                );
              },
              child: Container(
                height: SizeConfig.avatarRadius * 2,
                width: SizeConfig.screenWidth * 0.258,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withOpacity(0.4),
                ),
                child: model.isLoadingFlc
                    ? SpinKitThreeBounce(
                        size: SizeConfig.body2,
                        color: Colors.white,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset(
                            Assets.tickets,
                            height: SizeConfig.iconSize1,
                          ),
                          CoinBalanceTextSE(),
                          //  Text("200", style: TextStyles.body2.bold),
                          Icon(
                            Icons.add_circle,
                            size: SizeConfig.iconSize1,
                            color: UiConstants.primaryColor,
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}
