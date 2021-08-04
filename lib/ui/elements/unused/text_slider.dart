// import 'dart:async';

// import 'package:flutter/material.dart';

// class NavySlider extends StatefulWidget {
//   final List<String> infoList;

//   NavySlider({this.infoList});

//   @override
//   State createState() => NavySliderState();
// }

// class NavySliderState extends State<NavySlider> {
//   PageController _pageController;
//   int _pageIndex = 0;
//   Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _pageIndex = 0;
//     _pageController = PageController(initialPage: _pageIndex);

//     _timer = Timer.periodic(Duration(seconds: 9), (Timer timer) {
//       if (_pageIndex < widget.infoList.length - 1) {
//         _pageIndex++;
//       } else {
//         _pageIndex = 0;
//       }

//       if (_pageController.positions.isNotEmpty)
//         _pageController.animateToPage(
//           _pageIndex,
//           duration: Duration(milliseconds: 600),
//           curve: Curves.easeIn,
//         );
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     //BaseUtil.infoSliderIndex = _pageIndex;
//     _timer.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.blueGrey[100],
//         height: 25.0,
//         child: Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                     child: Container(
//                   height: 25,
//                   width: 400,
//                   child: PageView(
//                     physics: NeverScrollableScrollPhysics(),
//                     children: _buildTextPages(),
//                     onPageChanged: onPageChanged,
//                     controller: _pageController,
//                   ),
//                 )),
//                 Icon(
//                   Icons.info_outline,
//                   size: 20,
//                   color: Colors.black54,
//                 )
//               ],
//             )));
//   }

//   List<Widget> _buildTextPages() {
//     List<Widget> _pagerWidgets = [];
//     if (widget.infoList == null || widget.infoList.length == 0) {
//       _pagerWidgets.add(Text(''));
//     }
//     widget.infoList.forEach((info) {
//       _pagerWidgets.add(
//         Text(
//           info,
//           style: TextStyle(color: Colors.black54),
//         ),
//       );
//     });

//     return _pagerWidgets;
//   }

//   void onPageChanged(int page) {
//     setState(() {
//       this._pageIndex = page;
//     });
//   }
// }
