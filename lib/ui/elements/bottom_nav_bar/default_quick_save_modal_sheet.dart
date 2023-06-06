import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DefaultQuickSaveModalSheet extends StatelessWidget {
  const DefaultQuickSaveModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher?.didPopRoute();
        return true;
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding32),
          decoration: BoxDecoration(
            color: const Color(0xff1B262C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.padding16),
              topRight: Radius.circular(SizeConfig.padding16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Quick Actions with Fello
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding24),
                child: Text('Quick Actions with Fello',
                    style: TextStyles.rajdhaniSB.body1),
              ),
              SizedBox(height: SizeConfig.padding4),
              //Select anyone option to perform a quick action
              Text('One click options for your favourite actions!',
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.6))),
              SizedBox(height: SizeConfig.padding20),

              GestureDetector(
                onTap: () {
                  AppState.backButtonDispatcher?.didPopRoute();
                  BaseUtil().openRechargeModalSheet(
                      investmentType: InvestmentType.AUGGOLD99, amt: 500);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding26,
                      vertical: SizeConfig.padding16),
                  // height: SizeConfig.padding70,
                  margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                      border: Border.all(
                          color: const Color(0xffD3D3D3).withOpacity(0.2))),
                  child: Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.padding38,
                        // child: Lottie.asset(
                        //   'assets/lotties/nav/journey.json',
                        //   fit: BoxFit.contain,
                        //   width: SizeConfig.padding54,
                        // ),
                        child: SvgPicture.asset(
                          'assets/svg/digitalgold.svg',
                          fit: BoxFit.contain,
                          width: SizeConfig.padding54,
                        ),
                      ),
                      SizedBox(width: SizeConfig.padding32),
                      // const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Save ₹500 in Gold',
                              style: TextStyles.rajdhaniB.title5),
                          Flexible(
                            child: Text(
                              'Buy Gold worth ₹500 with fello',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white.withOpacity(0.6)),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppState.backButtonDispatcher?.didPopRoute();
                  BaseUtil().openRechargeModalSheet(
                      investmentType: InvestmentType.LENDBOXP2P, amt: 1000);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding26,
                      vertical: SizeConfig.padding16),
                  // height: SizeConfig.padding70,
                  // margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                      border: Border.all(
                          color: const Color(0xffD3D3D3).withOpacity(0.2))),
                  child: Row(
                    children: [
                      SizedBox(
                          width: SizeConfig.padding38,
                          child: SvgPicture.asset(
                            'assets/svg/fello_flo.svg',
                            fit: BoxFit.cover,
                            width: SizeConfig.padding54,
                            // height: SizeConfig.padding46,
                          )),
                      SizedBox(width: SizeConfig.padding32),
                      // const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Save ₹1000 in Flo',
                              style: TextStyles.rajdhaniB.title5),
                          Flexible(
                            child: Text(
                              'Save in Fello flo worth ₹1000',
                              style: TextStyles.sourceSans.body4
                                  .colour(Colors.white.withOpacity(0.6)),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.padding20),
            ],
          ),
        ),
      ),
    );
  }
}
