import 'package:felloapp/ui/pages/others/games/web/new_game_home/leaderboard/components/winner_widget.dart';
import 'package:flutter/material.dart';

class LeaderBoardView extends StatelessWidget {
  const LeaderBoardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF39393C),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const WinnerWidgets(),
          const UserRank(),
          const RemainingRank(),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/temp/chevron_right.png',
                  width: 16,
                  height: 16,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserRank extends StatelessWidget {
  const UserRank({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFF000000).withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 15, top: 35),
      child: ListTile(
        dense: true,
        title: Row(
          children: [
            const Text(
              '56',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Image.asset(
              'assets/temp/rank_one_profile.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "YOU",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        trailing: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Best : ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const TextSpan(
                text: '43 Runs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RemainingRank extends StatefulWidget {
  const RemainingRank({Key key}) : super(key: key);

  @override
  State<RemainingRank> createState() => _RemainingRankState();
}

class _RemainingRankState extends State<RemainingRank> {
  final List<Map<String, dynamic>> winnerDetails = [
    {
      'name': 'A5hwin_Singh',
      'image': 'rank_one_profile.png',
      'score': '100 Runs'
    },
    {
      'name': 'Mehul@Dutta',
      'image': 'rank_three_profile.png',
      'score': '76 Runs'
    },
    {
      'name': 'Ashutosh_27',
      'image': 'rank_two_profile.png',
      'score': '75 Runs'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: [
              Text(
                '${index + 4}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Image.asset(
                'assets/temp/${winnerDetails[index]['image']}',
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '${winnerDetails[index]['name']}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              )
            ],
          ),
          trailing: Text(
            '${winnerDetails[index]['score']}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 0.5,
          color: Color(0xFF9EA1A1),
        );
      },
    );
  }
}
