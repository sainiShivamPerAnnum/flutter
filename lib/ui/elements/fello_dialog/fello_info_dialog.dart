import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloInfoDialog extends StatelessWidget {
  final String? title, subtitle, asset, png, nPng;
  final Widget? action;

  final Widget? customContent;
  final bool isAddedToScreenStack;
  final bool defaultPadding;

  const FelloInfoDialog({
    super.key,
    this.title,
    this.asset,
    this.subtitle,
    this.customContent,
    this.action,
    this.png,
    this.nPng,
    this.defaultPadding = true,
    this.isAddedToScreenStack = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      // defaultPadding: defaultPadding,
      // isAddedToScreenStack: isAddedToScreenStack,
      content: customContent ??
          SizedBox(
            width: SizeConfig.screenWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (asset != null)
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                if (asset != null)
                  SvgPicture.asset(
                    asset!,
                    height: SizeConfig.screenHeight! * 0.16,
                  ),
                if (asset != null)
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                if (png != null)
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                if (png != null)
                  Image.asset(
                    png!,
                    height: SizeConfig.screenHeight! * 0.16,
                  ),
                if (png != null)
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                if (nPng != null)
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                if (nPng != null)
                  Image.network(
                    nPng!,
                    height: SizeConfig.screenHeight! * 0.16,
                    fit: BoxFit.cover,
                  ),
                if (nPng != null)
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                if ((title ?? '').isNotEmpty)
                  Text(
                    title!,
                    style: TextStyles.title3.bold,
                    textAlign: TextAlign.center,
                  ),
                if ((title ?? '').isNotEmpty)
                  SizedBox(height: SizeConfig.padding16),
                if ((subtitle ?? '').isNotEmpty)
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyles.body2.colour(Colors.grey),
                  ),
                if ((subtitle ?? '').isNotEmpty)
                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                action!
              ],
            ),
          ),
    );
  }
}
