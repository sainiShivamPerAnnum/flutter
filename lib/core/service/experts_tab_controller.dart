import 'package:flutter/material.dart';

class GlobalTabController extends ChangeNotifier {
  static final GlobalTabController _instance = GlobalTabController._internal();
  factory GlobalTabController() => _instance;
  GlobalTabController._internal();

  TabController? _tabController;
  late TickerProvider _tickerProvider;
  bool _isInitialized = false;

  void initialize(TickerProvider tickerProvider) {
    if (_isInitialized) {
      _tabController?.dispose();
    }

    _tickerProvider = tickerProvider;
    _tabController = TabController(length: 3, vsync: _tickerProvider);
    _tabController!.addListener(_onTabChanged);
    _isInitialized = true;
    // Remove this notifyListeners() call as it's not needed here
  }

  TabController? get tabController => _tabController;
  bool get isInitialized => _isInitialized;
  int get currentIndex => _tabController?.index ?? 0;

  void setIndex(int index) {
    if (_tabController != null && index >= 0 && index < 3) {
      _tabController!.animateTo(index);
    }
  }

  void _onTabChanged() {
    notifyListeners();
  }

  String getTabTitle([int? index]) {
    final tabIndex = index ?? currentIndex;
    switch (tabIndex) {
      case 0:
        return 'Experts';
      case 1:
        return 'Shorts';
      case 2:
        return 'Chats';
      default:
        return 'Experts';
    }
  }

  String getTabSubtitle([int? index]) {
    final tabIndex = index ?? currentIndex;
    switch (tabIndex) {
      case 0:
        return 'Book a call with an expert instantly';
      case 1:
        return 'Learn investing with quick and insightful shorts';
      case 2:
        return 'Chat with an expert instantly';
      default:
        return 'Book a call with an expert instantly';
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    _tabController = null;
    _isInitialized = false;
    super.dispose();
  }
}
