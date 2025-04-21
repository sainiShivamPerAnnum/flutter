import 'package:felloapp/feature/expert/widgets/scroll_to_index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rect_getter/rect_getter.dart';

/// Improved version of VerticalScrollableTabBarStatus that has a listener callback
class VerticalScrollableTabBarStatus {
  static bool isOnTap = false;
  static int isOnTapIndex = 0;
  static Function(int)? _onIndexChanged;

  static void initialize(Function(int) callback) {
    _onIndexChanged = callback;
  }

  static void setIndex(int index) {
    isOnTap = true;
    isOnTapIndex = index;
    if (_onIndexChanged != null) {
      _onIndexChanged!(index);
    }
  }
}

/// VerticalScrollPosition = is ann Animation style from scroll_to_index plugin's preferPosition,
/// It's show the item position in listView.builder
enum VerticalScrollPosition { begin, middle, end }

class ImprovedVerticalScrollableTabView extends StatefulWidget {
  /// TabController to let widget listening TabBar changed
  final TabController tabController;

  /// Required a List<dynamic> Type，you can put your data that you wanna put in item
  final List<dynamic> listItemData;

  /// A callback that return an Object inside listItemData and the index of ListView.Builder
  final Widget Function(dynamic data, int index) eachItemChild;

  /// VerticalScrollPosition = is ann Animation style from scroll_to_index,
  /// It's show the item position in listView.builder
  final VerticalScrollPosition verticalScrollPosition;

  /// Required SliverAppBar, And TabBar must inside of SliverAppBar
  final List<Widget> slivers;

  final AutoScrollController autoScrollController;

  /// Custom TabBar parameters
  final Function(int) onTabChanged;

  /// Copy Scrollbar parameters
  final bool? thumbVisibility;
  final bool? trackVisibility;
  final double? thickness;
  final Radius? radius;
  final bool Function(ScrollNotification)? notificationPredicate;
  final bool? interactive;
  final ScrollbarOrientation? scrollbarOrientation;

  /// Copy CustomScrollView parameters
  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;
  final bool shrinkWrap;
  final Key? center;
  final double anchor;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  const ImprovedVerticalScrollableTabView({
    Key? key,
    required this.autoScrollController,
    required this.tabController,
    required this.listItemData,
    required this.eachItemChild,
    required this.onTabChanged,
    this.verticalScrollPosition = VerticalScrollPosition.begin,
    this.thumbVisibility,
    this.trackVisibility,
    this.thickness,
    this.radius,
    this.notificationPredicate,
    this.interactive,
    this.scrollbarOrientation,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.shrinkWrap = false,
    this.center,
    this.anchor = 0.0,
    this.cacheExtent,
    required this.slivers,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  @override
  State<ImprovedVerticalScrollableTabView> createState() =>
      _ImprovedVerticalScrollableTabViewState();
}

class _ImprovedVerticalScrollableTabViewState
    extends State<ImprovedVerticalScrollableTabView> {
  /// Instantiate RectGetter
  final listViewKey = RectGetter.createGlobalKey();

  /// To save the item's Rect
  Map<int, dynamic> itemsKeys = {};

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabControllerTick);

    // Initialize the VerticalScrollableTabBarStatus with a callback
    VerticalScrollableTabBarStatus.initialize((index) {
      // This will be called when setIndex is triggered
      widget.tabController.animateTo(index);
      _scrollToIndex(index);
    });
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabControllerTick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RectGetter(
      key: listViewKey,
      child: NotificationListener<UserScrollNotification>(
        onNotification: onScrollNotification,
        child: Scrollbar(
          controller: widget.autoScrollController,
          thumbVisibility: widget.thumbVisibility,
          trackVisibility: widget.trackVisibility,
          thickness: widget.thickness,
          radius: widget.radius,
          notificationPredicate: widget.notificationPredicate,
          interactive: widget.interactive,
          scrollbarOrientation: widget.scrollbarOrientation,
          child: CustomScrollView(
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: widget.autoScrollController,
            primary: widget.primary,
            physics: widget.physics,
            scrollBehavior: widget.scrollBehavior,
            shrinkWrap: widget.shrinkWrap,
            center: widget.center,
            anchor: widget.anchor,
            cacheExtent: widget.cacheExtent,
            slivers: [
              ...widget.slivers,
              buildVerticalSliverList(),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 60.h,
                ),
              ),
            ],
            semanticChildCount: widget.semanticChildCount,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior,
          ),
        ),
      ),
    );
  }

  SliverList buildVerticalSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(widget.listItemData.length, (index) {
          itemsKeys[index] = RectGetter.createGlobalKey();
          return buildItem(index);
        }),
      ),
    );
  }

  Widget buildItem(int index) {
    dynamic category = widget.listItemData[index];
    return RectGetter(
      key: itemsKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: widget.autoScrollController,
        child: widget.eachItemChild(category, index),
      ),
    );
  }

  /// Scroll to specific index with animation
  void _scrollToIndex(int index) {
    switch (widget.verticalScrollPosition) {
      case VerticalScrollPosition.begin:
        widget.autoScrollController.scrollToIndex(
          index,
          preferPosition: AutoScrollPosition.begin,
          duration: const Duration(milliseconds: 300),
        );
        break;
      case VerticalScrollPosition.middle:
        widget.autoScrollController.scrollToIndex(
          index,
          preferPosition: AutoScrollPosition.middle,
        );
        break;
      case VerticalScrollPosition.end:
        widget.autoScrollController.scrollToIndex(
          index,
          preferPosition: AutoScrollPosition.end,
        );
        break;
    }
  }

  /// Handle scroll notifications
  bool onScrollNotification(UserScrollNotification notification) {
    // Only update tab position during user scrolls, not during programmatic scrolls
    if (notification.direction == ScrollDirection.idle &&
        !VerticalScrollableTabBarStatus.isOnTap) {
      List<int> visibleItems = getVisibleItemsIndex();
      if (visibleItems.isNotEmpty) {
        widget.tabController.animateTo(visibleItems[0]);
        widget.onTabChanged(visibleItems[0]);
      }
    }
    return false;
  }

  /// Get visible items index on screen
  List<int> getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;

    bool isHorizontalScroll = widget.scrollDirection == Axis.horizontal;
    itemsKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;

      switch (isHorizontalScroll) {
        case true:
          if (itemRect.left > rect.right) return;
          if (itemRect.right < rect.left) return;
          break;
        case false:
          if (itemRect.top > rect.bottom) return;
          if (itemRect.bottom <
              rect.top +
                  MediaQuery.of(context).viewPadding.top +
                  kToolbarHeight +
                  172) return;
          break;
      }

      items.add(index);
    });
    return items;
  }

  void _handleTabControllerTick() {
    if (VerticalScrollableTabBarStatus.isOnTap) {
      // Reset the flag
      VerticalScrollableTabBarStatus.isOnTap = false;

      // Scroll to the selected index
      _scrollToIndex(VerticalScrollableTabBarStatus.isOnTapIndex);
    }
  }
}
