import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import '../../../ui/pages/static/app_widget.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isEnabled;
  final bool isLoading;
  final String? placeholder;

  const ChatInput({
    required this.onSendMessage,
    super.key,
    this.isEnabled = true,
    this.isLoading = false,
    this.placeholder,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.isEnabled && !widget.isLoading) {
      widget.onSendMessage(text);
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFF2A2A2A),
            width: 1.w,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            PropertyChangeConsumer<UserService, UserServiceProperties>(
              properties: const [
                UserServiceProperties.myUserDpUrl,
                UserServiceProperties.myAvatarId,
              ],
              builder: (context, model, properties) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: UiConstants.primaryColor,
                      width: 2.r,
                    ),
                  ),
                  child: CircleAvatar(
                    key: const ValueKey(Constants.PROFILE),
                    radius: 16.r,
                    backgroundColor: UiConstants.kTextColor4,
                    backgroundImage: (model!.avatarId != null &&
                            model.avatarId == 'CUSTOM' &&
                            model.myUserDpUrl != null &&
                            model.myUserDpUrl!.isNotEmpty)
                        ? CachedNetworkImageProvider(
                            model.myUserDpUrl!,
                          )
                        : const AssetImage(
                            Assets.profilePic,
                          ) as ImageProvider<Object>?,
                    child: model.avatarId != null && model.avatarId != 'CUSTOM'
                        ? AppImage(
                            "assets/vectors/userAvatars/${model.avatarId}.svg",
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(),
                  ),
                );
              },
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? const Color(0xFF2D7D7D)
                        : Colors.transparent,
                    width: 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: widget.isEnabled && !widget.isLoading,
                        decoration: InputDecoration(
                          hintText: widget.placeholder ?? 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 4.w),
                      child: IconButton(
                        onPressed: _isComposing &&
                                widget.isEnabled &&
                                !widget.isLoading
                            ? _handleSend
                            : null,
                        icon: widget.isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2D7D7D),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.send_rounded,
                                color: _isComposing && widget.isEnabled
                                    ? const Color(0xFF2D7D7D)
                                    : Colors.white.withOpacity(0.3),
                                size: 20.sp,
                              ),
                        padding: EdgeInsets.all(8.r),
                        constraints: BoxConstraints(
                          minWidth: 36.w,
                          minHeight: 36.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
