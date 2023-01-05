import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

class WebGameModalSheet extends StatelessWidget {
  const WebGameModalSheet({Key? key, required this.game}) : super(key: key);
  final String game;

  @override
  Widget build(BuildContext context) {
    return BaseView<WebHomeViewModel>(onModelReady: (model) {
      model.init(game);
    }, onModelDispose: (model) {
      model.clear();
    }, builder: (context, model, child) {
      if (model.isLoading) {
        return FullScreenLoader();
      }
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight! * 0.01,
            ),
            Container(
              height: 3,
              width: SizeConfig.screenWidth! * 0.4,
              decoration: BoxDecoration(
                  color: Color(0xffD9D9D9).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8)),
            ),
            SvgPicture.network(model.currentGameModel!.icon!),
            StreamView(model: model, game: game),
            SizedBox(
              height: SizeConfig.padding10,
            ),
            Text(
              model.currentGameModel!.gameName!,
              style: TextStyles.sourceSansSB.title5.colour(Colors.white),
            ),
            SizedBox(
              height: 2,
            ),
            SizedBox(
              width: SizeConfig.screenWidth! * 0.8,
              child: Text(
                model.currentGameModel!.description!,
                textAlign: TextAlign.center,
                style: TextStyles.sourceSans.body3.colour(Color(0xffBDBDBE)),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 14, right: 14, bottom: 0),
              child: RewardCriteria(
                htmlData: "",
              ),
            ),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Text(
              "Your Scorecard",
              style: TextStyles.sourceSansSB.body1.colour(Colors.white),
            ),
            SizedBox(
              height: SizeConfig.padding10,
            ),
          ],
        ),
      );
    });
  }
}

class RewardCriteria extends StatelessWidget {
  const RewardCriteria({Key? key, required this.htmlData}) : super(key: key);
  final String htmlData;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xff49494C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Reward Criteria",
              style: TextStyles.sourceSansSB.colour(Colors.white).body1,
            ),
            Html(data: '''<ul>
<li>
<span style="color: #ffffff;">Score min&nbsp;<strong>250</strong>&nbsp;Points and get an assured Scratch card</span>
</li>
<li>
<span style="color: #ffffff;">Score min&nbsp;<strong>250</strong>&nbsp;Points and get an assured Scratch card</span>
</li>
<li>
<span style="color: #ffffff;">Score min&nbsp;<strong>250</strong>&nbsp;Points and get an assured Scratch card</span>
</li>
</ul>''')
          ],
        ),
      ),
    );
  }
}
