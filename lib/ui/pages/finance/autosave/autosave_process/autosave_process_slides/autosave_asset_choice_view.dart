import 'package:felloapp/ui/pages/finance/autosave/autosave_process/autosave_process_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosaveAssetChoiceView extends StatelessWidget {
  final AutosaveProcessViewModel model;
  const AutosaveAssetChoiceView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          Text("Setup Autosave", style: TextStyles.rajdhaniSB.title2),
          SizedBox(height: SizeConfig.padding14),
          Text(
            "You are just a step away from compounded returns",
            style: TextStyles.sourceSans,
          ),
          SizedBox(height: SizeConfig.padding32),
          Text(
            "Choose an asset to do an SIP in:",
            style: TextStyles.rajdhaniSB.title4,
          ),
          SizedBox(height: SizeConfig.padding10),
          Column(
            children: List.generate(
              model.autosaveAssetOptionList.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  child: ColorFiltered(
                    colorFilter: model.autosaveAssetOptionList[index].isEnabled
                        ? ColorFilter.mode(Colors.transparent, BlendMode.color)
                        : ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenWidth! * 0.24,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0xff4F4F4F),
                          ),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness5),
                          color: Color(0xff303030)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ListTile(
                              onTap: () {
                                if (model
                                    .autosaveAssetOptionList[index].isEnabled)
                                  model.selectedAssetOption = index;
                              },
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: SizeConfig.padding10,
                              leading: index == 0
                                  ? SvgPicture.asset(
                                      model
                                          .autosaveAssetOptionList[index].asset,
                                      width: SizeConfig.padding70,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      model
                                          .autosaveAssetOptionList[index].asset,
                                      width: SizeConfig.padding70,
                                      fit: BoxFit.cover,
                                    ),
                              title: Text(
                                model.autosaveAssetOptionList[index].title,
                                style: TextStyles.sourceSansB.body1,
                              ),
                              subtitle: Text(
                                  model.autosaveAssetOptionList[index].subtitle,
                                  style: TextStyles.sourceSans.body3),
                              trailing: Radio(
                                value: index,
                                groupValue: model.selectedAssetOption,
                                onChanged: (val) {
                                  if (model
                                      .autosaveAssetOptionList[index].isEnabled)
                                    model.selectedAssetOption = index;
                                },
                              ),
                            ),
                          ),
                          if (model.autosaveAssetOptionList[index].isPopular)
                            Align(
                              alignment: Alignment.topRight,
                              child: IgnorePointer(
                                child: CustomPaint(
                                  size: Size(
                                      SizeConfig.padding64,
                                      (SizeConfig.padding64 *
                                              0.6538461538461539)
                                          .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
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
          Spacer(),
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

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF7C780).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

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
