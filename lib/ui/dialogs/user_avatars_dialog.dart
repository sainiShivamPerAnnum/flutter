import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserAvatarSelectionDialog extends StatefulWidget {
  const UserAvatarSelectionDialog(
      {required this.onCustomAvatarSelection,
      required this.onPresetAvatarSelection,
      Key? key,
      this.itemCount = 6})
      : super(key: key);
  final Function onCustomAvatarSelection;
  final Function onPresetAvatarSelection;
  final int itemCount;

  @override
  State<UserAvatarSelectionDialog> createState() =>
      _UserAvatarSelectionDialogState();
}

class _UserAvatarSelectionDialogState extends State<UserAvatarSelectionDialog> {
  int _currentSelectedAvatar = 0;

  get currentSelectedAvatar => _currentSelectedAvatar;

  set currentSelectedAvatar(value) {
    if (mounted) {
      setState(() {
        _currentSelectedAvatar = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: SizeConfig.padding16,
            ),
            child: Text(
              locale.obUpdateAvatar,
              style: TextStyles.rajdhaniB.title2,
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1,
              crossAxisSpacing: SizeConfig.padding24,
              mainAxisSpacing: SizeConfig.padding24,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.itemCount,
            itemBuilder: (ctx, i) => i == widget.itemCount - 1
                ? InkWell(
                    onTap: widget.onCustomAvatarSelection as void Function()?,
                    child: CircleAvatar(
                      backgroundColor: UiConstants.kBackgroundColor,
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: SizeConfig.screenWidth! * 0.16,
                      ),
                    ))
                : GestureDetector(
                    onTap: () => currentSelectedAvatar = i,
                    child: Container(
                      padding: EdgeInsets.all(SizeConfig.padding2),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: currentSelectedAvatar == i
                                ? UiConstants.primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                          shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        "assets/vectors/userAvatars/AV${i + 1}.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          SizedBox(height: SizeConfig.padding24),
          Row(
            children: [
              Expanded(
                child: AppNegativeBtn(
                  btnText: locale.btnCancel,
                  onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
                ),
              ),
              SizedBox(width: SizeConfig.padding12),
              Expanded(
                child: ReactivePositiveAppButton(
                  btnText: locale.btnUpdate,
                  onPressed: () => widget.onPresetAvatarSelection(
                      avatarId: "AV${currentSelectedAvatar + 1}"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
