import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/augmont_state_list.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class KYCDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<KYCDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: locale.dPanNkyc,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: model.state == ViewState.Busy
                      ? ListLoader()
                      : ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: SizeConfig.scaffoldMargin),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.obNameLabel,
                                  style: TextStyles.body3,
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  autofocus: true,
                                  //initialValue: model.myname,
                                  enabled: model.inEditMode,
                                  controller: model.nameController,
                                  keyboardType: TextInputType.name,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.pkPanLabel,
                                  style: TextStyles.body3,
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  //initialValue: model.myname,
                                  enabled: model.inEditMode,
                                  controller: model.panController,
                                  focusNode: model.panFocusNode,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  keyboardType: model.panTextInputType,
                                  onChanged: (val) {
                                    // if (model.onPanEntered()) {
                                    //   Future.delayed(Duration(milliseconds: 5),
                                    //       () {
                                    //     FocusScope.of(context)
                                    //         .requestFocus(model.panFocusNode);
                                    //   });
                                    // }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            if (model.inEditMode)
                              Container(
                                width: SizeConfig.screenWidth,
                                child: FelloButtonLg(
                                    child: model.isKycInProgress
                                        ? SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : Text(
                                            locale.btnSumbit,
                                            style: TextStyles.body2
                                                .colour(Colors.white)
                                                .bold,
                                          ),
                                    onPressed: () {
                                      model.onSubmit(context);
                                    }),
                              ),
                            SizedBox(height: 24),
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
