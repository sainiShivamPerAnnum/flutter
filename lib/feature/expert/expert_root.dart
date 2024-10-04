import 'package:felloapp/feature/expert/expert_card.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class ExpertHome extends StatefulWidget {
  const ExpertHome({super.key});

  @override
  State<ExpertHome> createState() => _ExpertHomeState();
}

class _ExpertHomeState extends State<ExpertHome>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  final double tabBarHeight = 50.0;
  String _currentSection = 'Personal Finance';

  GlobalKey personalFinanceKey = GlobalKey();
  GlobalKey stockMarketKey = GlobalKey();
  GlobalKey mutualFundsKey = GlobalKey();

  void _onWidgetInView(String id, bool isInView) {
    if (isInView) {
      setState(() {
            _currentSection = id;
          });
    }
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(key.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    return InViewNotifierCustomScrollView(
      controller: _scrollController,
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double vpHeight) {
        return deltaTop < (0.5 * vpHeight) && deltaBottom > (0.5 * vpHeight);
      },
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Our top experts',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ExpertCard(
                name: 'Vibhor Varshney',
                expertise: 'Personal Finance',
                qualifications: '₹10/min',
                experience: '₹10/min',
                onBookCall: () {},
                rating: 3.2,
                availableSlots: 2,
                imageUrl:
                    'https://ik.imagekit.io/9xfwtu0xm/experts/randomuser2.jpg?updatedAt=1726836184236',
              );
            },
            childCount: 3,
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(
            currentSection: _currentSection,
            scrollToSection: _scrollToSection,
            stockMarketKey: stockMarketKey,
            personalFinanceKey: personalFinanceKey,
            mutualFundsKey: mutualFundsKey,
          ),
        ),
        SliverToBoxAdapter(
          key: personalFinanceKey,
          child: InViewNotifierWidget(
            id: 'Personal Finance',
            builder: (BuildContext context, bool isInView, Widget? child) {
              // Trigger the state change when this widget is in view
              _onWidgetInView('Personal Finance', isInView);
              return Container(
                height: 100,
                color: isInView ? Colors.green : Colors.amber,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    'Personal Finance',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ExpertCard(
                name: 'Vibhor Varshney',
                expertise: 'Personal Finance',
                qualifications: '₹10/min',
                experience: '₹10/min',
                onBookCall: () {},
                rating: 3.2,
                availableSlots: 2,
                imageUrl:
                    'https://ik.imagekit.io/9xfwtu0xm/experts/randomuser2.jpg?updatedAt=1726836184236',
              );
            },
            childCount: 3,
          ),
        ),
        SliverToBoxAdapter(
          key: stockMarketKey,
          child: InViewNotifierWidget(
            id: 'Stock Market',
            builder: (BuildContext context, bool isInView, Widget? child) {
              // Trigger the state change when this widget is in view
              _onWidgetInView('Stock Market', isInView);
              return Container(
                height: 100,
                color: isInView ? Colors.green : Colors.amber,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    'Stock Market',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ExpertCard(
                name: 'Vibhor Varshney',
                expertise: 'Stock Market',
                qualifications: '₹10/min',
                experience: '₹10/min',
                onBookCall: () {},
                rating: 3.2,
                availableSlots: 2,
                imageUrl:
                    'https://ik.imagekit.io/9xfwtu0xm/experts/randomuser2.jpg?updatedAt=1726836184236',
              );
            },
            childCount: 3,
          ),
        ),
        SliverToBoxAdapter(
          key: mutualFundsKey,
          child: InViewNotifierWidget(
            id: 'Mutual Funds',
            builder: (BuildContext context, bool isInView, Widget? child) {
              // Trigger the state change when this widget is in view
              _onWidgetInView('Mutual Funds', isInView);
              return Container(
                height: 100,
                color: isInView ? Colors.green : Colors.amber,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    'Mutual Funds',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ExpertCard(
                name: 'Vibhor Varshney',
                expertise: 'Mutual Funds',
                qualifications: '₹10/min',
                experience: '₹10/min',
                onBookCall: () {},
                rating: 3.2,
                availableSlots: 2,
                imageUrl:
                    'https://ik.imagekit.io/9xfwtu0xm/experts/randomuser2.jpg?updatedAt=1726836184236',
              );
            },
            childCount: 3,
          ),
        ),
      ],
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String currentSection;
  final GlobalKey personalFinanceKey;
  final GlobalKey stockMarketKey;
  final GlobalKey mutualFundsKey;
  final Function(GlobalKey) scrollToSection;

  _StickyHeaderDelegate({
    required this.currentSection,
    required this.personalFinanceKey,
    required this.stockMarketKey,
    required this.mutualFundsKey,
    required this.scrollToSection,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: UiConstants.bg,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => scrollToSection(personalFinanceKey),
              child: Text(
                'Personal Finance',
                style: TextStyle(
                    color: currentSection == 'Personal Finance'
                        ? Colors.blueAccent
                        : Colors.white,
                    fontSize: 20),
              ),
            ),
            GestureDetector(
              onTap: () => scrollToSection(stockMarketKey),
              child: Text(
                'Stock Market',
                style: TextStyle(
                    color: currentSection == 'Stock Market'
                        ? Colors.blueAccent
                        : Colors.white,
                    fontSize: 20),
              ),
            ),
            GestureDetector(
              onTap: () => scrollToSection(mutualFundsKey),
              child: Text(
                'Mutual Funds',
                style: TextStyle(
                    color: currentSection == 'Mutual Funds'
                        ? Colors.blueAccent
                        : Colors.white,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return false;
  }
}
