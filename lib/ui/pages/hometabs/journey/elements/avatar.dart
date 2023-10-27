import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

final avatarKey = GlobalKey();

class Avatar extends StatelessWidget {
  final JourneyPageViewModel? model;
  const Avatar({Key? key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(model!.avatarPosition);
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: const [
        JourneyServiceProperties.AvatarPosition,
        JourneyServiceProperties.Pages
      ],
      builder: (context, model, properties) {
        return Positioned(
          key: avatarKey,
          top: model!.avatarPosition?.dy,
          left: model.avatarPosition?.dx,
          child: CustomPaint(
            size: Size(SizeConfig.padding20, SizeConfig.padding20),
            painter: AvatarPainter(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
              ),
              child: ProfileImageSE(
                radius: SizeConfig.avatarRadius * 0.7,
                reactive: false,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.9);
    path.lineTo(size.width * 0.5, size.height * 1.08);
    path.lineTo(size.width * 0.7, size.height * 0.9);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white);

    canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.47, size.height * 1.18),
          width: SizeConfig.padding12,
          height: SizeConfig.padding6,
        ),
        0,
        2 * 3.14,
        true,
        Paint()..color = UiConstants.kSecondaryBackgroundColor);
  }

  @override
  bool shouldRepaint(AvatarPainter oldDelegate) => true;
}

class AvatarPathPainter extends StatelessWidget {
  final JourneyPageViewModel model;

  const AvatarPathPainter({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: CustomPaint(
        size: Size(model.pageWidth!, model.pageHeight! * 2),
        painter: PathPainter(model.avatarPath, Colors.transparent),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  Path? path;
  final Color color;
  PathPainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    canvas.drawPath(path!, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
