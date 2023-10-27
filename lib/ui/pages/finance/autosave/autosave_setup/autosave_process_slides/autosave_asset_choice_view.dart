import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AutosaveAssetChoiceView extends StatelessWidget {
  final AutosaveProcessViewModel model;
  const AutosaveAssetChoiceView({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          Text("Setup Autosave", style: TextStyles.rajdhaniSB.title2),
          SizedBox(height: SizeConfig.padding32),
          Text(
            "Choose an asset to Autosave",
            style: TextStyles.rajdhaniSB.title4,
          ),
          SizedBox(height: SizeConfig.padding10),
          Selector<BankAndPanService, bool>(
              selector: (ctx, bankAndPanService) =>
                  bankAndPanService.isKYCVerified,
              builder: (context, isSimpleKycVerified, child) {
                return Column(
                  children: [
                    Column(
                      children: List.generate(
                        model.autosaveAssetOptionList.length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding10),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5),
                            child: ColorFiltered(
                              colorFilter: index == 2
                                  ? const ColorFilter.mode(
                                      Colors.transparent, BlendMode.color)
                                  : isSimpleKycVerified
                                      ? const ColorFilter.mode(
                                          Colors.transparent, BlendMode.color)
                                      : const ColorFilter.mode(
                                          Colors.grey,
                                          BlendMode.saturation,
                                        ),
                              child: Container(
                                width: SizeConfig.screenWidth,
                                // height: SizeConfig.screenWidth! * 0.24,

                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xff4F4F4F),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness5),
                                    color: const Color(0xff303030)),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: ListTile(
                                        onTap: () {
                                          if (isSimpleKycVerified) {
                                            model.selectedAssetOption = index;
                                          } else {
                                            if (index != 2) {
                                              BaseUtil.showNegativeAlert(
                                                  "Complete your KYC to autosave in both Flo & Gold",
                                                  "Option not available");
                                            }
                                          }
                                          model.trackAssetChoice(
                                              isSimpleKycVerified);
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        minVerticalPadding:
                                            SizeConfig.padding10,
                                        leading: index == 0
                                            ? SvgPicture.asset(
                                                model
                                                    .autosaveAssetOptionList[
                                                        index]
                                                    .asset,
                                                width: SizeConfig.padding70,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                model
                                                    .autosaveAssetOptionList[
                                                        index]
                                                    .asset,
                                                width: SizeConfig.padding70,
                                                fit: BoxFit.cover,
                                              ),
                                        title: Text(
                                          model.autosaveAssetOptionList[index]
                                              .title,
                                          style: TextStyles.sourceSansB.body1,
                                        ),
                                        subtitle: Text(
                                            index != 2 && !isSimpleKycVerified
                                                ? "Complete KYC to unlock"
                                                : model
                                                    .autosaveAssetOptionList[
                                                        index]
                                                    .subtitle,
                                            style: TextStyles.sourceSans.body3),
                                        trailing: Radio(
                                          value: index,
                                          groupValue: model.selectedAssetOption,
                                          onChanged: (_) {
                                            if (isSimpleKycVerified) {
                                              model.selectedAssetOption = index;
                                            } else {
                                              BaseUtil.showNegativeAlert(
                                                  "KYC Incomplete",
                                                  "Complete your KYC to autosave in this asset");
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    if (model.autosaveAssetOptionList[index]
                                        .isPopular)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IgnorePointer(
                                          child: CustomPaint(
                                            size: Size(
                                                SizeConfig.padding64,
                                                (SizeConfig.padding64 *
                                                        0.6538461538461539)
                                                    .toDouble()),
                                            painter: RPSCustomPainter(),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isSimpleKycVerified)
                      GestureDetector(
                        onTap: () {
                          Haptic.vibrate();
                          AppState.showAutosaveBt = false;
                          AppState.delegate!.appState.currentAction =
                              PageAction(
                                  state: PageState.addPage,
                                  page: KycDetailsPageConfig);
                          model.trackAssetChoiceKyc();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding10,
                              horizontal: SizeConfig.pageHorizontalMargins),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                  Icons.info_outline,
                                  size: SizeConfig.padding24,
                                  color: UiConstants.kTextColor3,
                                )),
                                const TextSpan(
                                  text: " Want to do your KYC now? ",
                                ),
                                TextSpan(
                                  text: "Tap here ",
                                  style: TextStyles.sourceSansSB
                                      .colour(UiConstants.primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Haptic.vibrate();
                                      AppState.showAutosaveBt = false;
                                      AppState.delegate!.appState
                                              .currentAction =
                                          PageAction(
                                              state: PageState.addPage,
                                              page: KycDetailsPageConfig);
                                    },
                                )
                              ],
                            ),
                            style: TextStyles.sourceSans.body2
                                .colour(UiConstants.kTextColor3),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }),
          const Spacer(),
          AppPositiveBtn(btnText: "NEXT", onPressed: model.proceed),
          SizedBox(height: SizeConfig.pageHorizontalMargins)
        ],
      ),
    );
  }
}

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*0.6538461538461539).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4134615, 0);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width, size.height * 0.5882353);
    path_0.lineTo(size.width * 0.4134615, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffF7C780);
    canvas.drawPath(path_0, paint0Fill);

    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: SizeConfig.body5,
    );
    final textSpan = TextSpan(
      text: 'POPULAR',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    // final xCenter = (size.width - textPainter.width) / 2;
    // final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(size.width * 0.3, size.height * -0.3);
    canvas.save();
    canvas.rotate(0.6);
    textPainter.paint(canvas, offset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
