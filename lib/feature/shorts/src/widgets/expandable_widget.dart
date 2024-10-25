import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableWidget extends StatefulWidget {
  final String title;
  final IconData leadingIcon;
  final String expandedText;
  final Color backgroundColor;
  final Color textColor;
  final void Function()
      onExpansionChanged; // Callback to notify about the expansion state change

  const ExpandableWidget({
    required this.title,
    required this.leadingIcon,
    required this.expandedText,
    required this.onExpansionChanged,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    super.key,
  });

  @override
  ExpandableWidgetState createState() => ExpandableWidgetState();
}

class ExpandableWidgetState extends State<ExpandableWidget> {
  bool _isExpanded = false;
  
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 0.95.sw,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        height: _isExpanded ? 120.h : 42.h,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.leadingIcon,
                  color: widget.textColor,
                  size: 12.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(color: widget.textColor, fontSize: 12.sp),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.textColor,
                    size: 16.sp,
                  ),
                  onPressed: _toggleExpanded,
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  widget.expandedText,
                  style: TextStyle(color: widget.textColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
