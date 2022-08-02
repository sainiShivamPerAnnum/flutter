// import 'package:felloapp/ui/architecture/base_view.dart';
// import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_view.dart';
// import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
// import 'package:felloapp/ui/pages/static/new_square_background.dart';
// import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class NewWebHomeView extends StatefulWidget {
//   const NewWebHomeView({Key key, @required this.game}) : super(key: key);
//   final String game;

//   @override
//   State<NewWebHomeView> createState() => _NewWebHomeViewState();
// }

// class _NewWebHomeViewState extends State<NewWebHomeView> {
//   // dummy bg color and text
//   List<Color> _color = [
//     Color(0xff5948B2),
//     Color(0xff9A3538),
//   ];
//   List<String> _text = [
//     '100',
//     '200',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<WebHomeViewModel>(
//       onModelReady: (model) {
//         model.newInit(widget.game);
//       },
//       onModelDispose: (model) {
//         model.clear();
//       },
//       builder: (context, model, child) {
//         return RefreshIndicator(
//           onRefresh: () => model.refreshLeaderboard(),
//           child: Scaffold(
//             body: Stack(
//               children: [
//                 NewSquareBackground(),
//                 CustomScrollView(
//                   physics: BouncingScrollPhysics(),
//                   slivers: [
//                     SliverPersistentHeader(
//                       delegate: MySliverAppBar(
//                         expandedHeight: SizeConfig.screenHeight * 0.3,
//                       ),
//                     ),
//                     SliverList(
//                       delegate: SliverChildListDelegate(
//                         [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Container(
//                                 height: SizeConfig.screenWidth * 0.266,
//                                 width: SizeConfig.screenWidth * 0.266,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.white,
//                                   ),
//                                   borderRadius: BorderRadius.circular(
//                                       SizeConfig.roundness8),
//                                   image: DecorationImage(
//                                     fit: BoxFit.fill,
//                                     image: NetworkImage(
//                                         'https://fello-assets.s3.ap-south-1.amazonaws.com/cricket-thumbnail-2022.png'),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: SizeConfig.padding20,
//                               ),
//                               Text(
//                                 'Cricket',
//                                 style: TextStyles.rajdhaniB.title2,
//                               ),
//                               SizedBox(
//                                 height: SizeConfig.padding35,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   GameInfoBlock(
//                                     coin: '2K+',
//                                     coinText: 'Playing',
//                                     assetHeight: SizeConfig.padding16,
//                                     assetUrl: 'assets/svg/circle_svg.svg',
//                                   ),
//                                   GameInfoBlock(
//                                     coin: '25K',
//                                     coinText: 'Win upto',
//                                     assetHeight: SizeConfig.padding16,
//                                     assetUrl: 'assets/svg/reward_svg.svg',
//                                   ),
//                                   GameInfoBlock(
//                                     coin: '30',
//                                     coinText: 'Per Game',
//                                     assetHeight: SizeConfig.padding16,
//                                     assetUrl: Assets.aFelloToken,
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: SizeConfig.padding32,
//                               ),
//                               Container(
//                                 width: SizeConfig.screenWidth * 0.874,
//                                 height: SizeConfig.screenWidth * 0.117,
//                                 child: Text(
//                                   'Swing your wicket, throw fast pitches, and win upto ?\nRs. 25,000 in one of our many free, online games!',
//                                   style: TextStyles.sourceSans.body2
//                                       .colour(Colors.grey.shade600),
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: SizeConfig.padding32,
//                               ),
//                             ],
//                           ),
//                           RewardLeaderboardView(game: widget.game),
//                           SizedBox(
//                             height: SizeConfig.screenWidth * .098,
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: SizeConfig.padding16),
//                                 child: Text(
//                                   'Recharge Options',
//                                   style: TextStyles.sourceSansSB.title5,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: SizeConfig.screenWidth * 0.277,
//                                 width: SizeConfig.screenWidth,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: 3,
//                                   itemBuilder: (ctx, i) {
//                                     if (i == 2) {
//                                       return Container(
//                                         margin:
//                                             EdgeInsets.all(SizeConfig.padding8),
//                                         height: SizeConfig.screenWidth * 0.277,
//                                         width: SizeConfig.screenWidth * 0.317,
//                                         color: Color(0xff39393C),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Icon(
//                                               Icons.add,
//                                               size: SizeConfig.screenWidth *
//                                                   0.081,
//                                               color: Colors.grey,
//                                             ),
//                                             Text(
//                                               'Custom',
//                                               style:
//                                                   TextStyles.sourceSans.body3,
//                                             )
//                                           ],
//                                         ),
//                                       );
//                                     }
//                                     return RechargeBox(
//                                       bgColor: _color[i],
//                                       coin: _text[i],
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: SizeConfig.padding16,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class RechargeBox extends StatelessWidget {
//   final Color bgColor;
//   final String coin;

//   const RechargeBox({Key key, this.bgColor, this.coin}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(SizeConfig.padding8),
//       height: SizeConfig.screenWidth * 0.277,
//       width: SizeConfig.screenWidth * 0.317,
//       color: bgColor,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//             margin: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.padding8, vertical: SizeConfig.padding8),
//             width: SizeConfig.screenWidth * 0.148,
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(SizeConfig.roundness8),
//             ),
//             child: InkWell(
//               onTap: () {},
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     Assets.aFelloToken,
//                   ),
//                   Text(
//                     coin,
//                     style: TextStyles.sourceSansSB.body2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             height: SizeConfig.screenWidth * 0.085,
//             width: SizeConfig.screenWidth * 0.261,
//             decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white),
//                 borderRadius: BorderRadius.circular(SizeConfig.roundness8)),
//             child: Center(
//               child: Text(
//                 '₹$coin',
//                 style: TextStyles.rajdhaniB.body3,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GameInfoBlock extends StatelessWidget {
//   final String coin, coinText, assetUrl;
//   final double assetHeight;

//   const GameInfoBlock({
//     Key key,
//     this.coin,
//     this.coinText,
//     this.assetHeight,
//     this.assetUrl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: SizeConfig.screenWidth * 0.155,
//       height: SizeConfig.screenWidth * 0.120,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               SvgPicture.asset(
//                 assetUrl,
//                 height: assetHeight,
//               ),
//               Text(
//                 coin,
//                 style: TextStyles.sourceSans.title4.colour(Colors.grey),
//               ),
//             ],
//           ),
//           Text(
//             coinText,
//             style: TextStyles.sourceSansSB.body3,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MySliverAppBar extends SliverPersistentHeaderDelegate {
//   final double expandedHeight;

//   MySliverAppBar({@required this.expandedHeight});

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Stack(
//       fit: StackFit.expand,
//       overflow: Overflow.visible,
//       children: [
//         Image.network(
//           "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
//           fit: BoxFit.cover,
//         ),
//         Center(
//           child: Opacity(
//             opacity: shrinkOffset / expandedHeight,
//             child: Text(
//               "MySliverAppBar",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 23,
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: expandedHeight / 2 - shrinkOffset,
//           left: MediaQuery.of(context).size.width / 4,
//           child: Opacity(
//             opacity: (1 - shrinkOffset / expandedHeight),
//             child: Card(
//               elevation: 10,
//               child: SizedBox(
//                 height: expandedHeight,
//                 width: MediaQuery.of(context).size.width / 2,
//                 child: FlutterLogo(),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   double get maxExtent => expandedHeight;

//   @override
//   double get minExtent => kToolbarHeight;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
// }


