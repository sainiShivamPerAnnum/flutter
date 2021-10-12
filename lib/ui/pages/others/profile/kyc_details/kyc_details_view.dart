import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/augmont_state_list.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class KYCDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                title: "PAN & KYC",
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.scaffoldMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.scaffoldMargin),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name as per PAN",
                            style: TextStyles.body3,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            //initialValue: model.myname,
                            enabled: model.inEditMode,
                            controller: model.nameController,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PAN Number",
                            style: TextStyles.body3,
                          ),
                          SizedBox(height: 6),
                          TextFormField(
                            //initialValue: model.myname,
                            enabled: model.inEditMode,
                            controller: model.panController,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "State",
                            style: TextStyles.body3,
                          ),
                          SizedBox(height: 6),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      UiConstants.primaryColor.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            iconEnabledColor: UiConstants.primaryColor,
                            hint: Text("Which state do you live in?"),
                            value: model.stateChosenValue,
                            onChanged: model.onStateSelected,
                            items: AugmontResources.augmontStateList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e["id"],
                                    child: Text(
                                      e["name"],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(height: 24),
                          if (model.inEditMode)
                            FelloButtonLg(
                                child: model.isUpadtingKycDetails
                                    ? SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : Text(
                                        'SUBMIT',
                                        style: TextStyles.body2
                                            .colour(Colors.white)
                                            .bold,
                                      ),
                                onPressed: () {
                                  model.updateKYCDetails();
                                }),
                          SizedBox(height: 24),
                        ],
                      ),
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
