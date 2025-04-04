import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableWidget extends StatefulWidget {
  final String title;
  final IconData leadingIcon;
  final String expandedText;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onExpansionChanged;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.75.sw,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.dark(
            primary: widget.textColor,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: ExpansionTile(
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
              widget.onExpansionChanged.call();
            },
            tilePadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 0,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            collapsedIconColor: widget.textColor,
            iconColor: widget.textColor,
            maintainState: true,
            visualDensity: const VisualDensity(
              horizontal: 0,
              vertical: -4,
            ),
            leading: Icon(
              widget.leadingIcon,
              color: widget.textColor,
              size: 12.sp,
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: Text(
                  widget.expandedText,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
