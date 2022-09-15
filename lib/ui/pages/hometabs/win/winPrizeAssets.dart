import 'dart:ui' as ui;

import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

//Asset 0
class WinPrizeClaimAsset0 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6776366),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6714021),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2729986,
        size.width * 0.3100006,
        size.height * 0.2467310,
        size.width * 0.3226079,
        size.height * 0.2426034);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2080717);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1773372,
        size.width * 0.3263305,
        size.height * 0.1454572,
        size.width * 0.3437433,
        size.height * 0.1218614);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.05412041,
        size.width * 0.4950689,
        size.height * 0.02758621,
        size.width * 0.5575037,
        size.height * 0.02758621);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.02758621,
        size.width * 0.7592073,
        size.height * 0.08968069,
        size.width * 0.7860122,
        size.height * 0.1389848);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1593966,
        size.width * 0.7993659,
        size.height * 0.1838607,
        size.width * 0.7993659,
        size.height * 0.2078221);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2426034);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2741241,
        size.width * 0.8385183,
        size.height * 0.3180283,
        size.width * 0.8361951,
        size.height * 0.3360400);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6399910);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.6970276,
        size.width * 0.7394512,
        size.height * 0.8084000,
        size.width * 0.5475506,
        size.height * 0.7975931);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.7867862,
        size.width * 0.2890988,
        size.height * 0.6880228,
        size.width * 0.2798091,
        size.height * 0.6399910);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.5887262),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.7744024, size.height * 0.2241372);
    path_4.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2138345,
        size.width * 0.7798110,
        size.height * 0.2031117,
        size.width * 0.7798110,
        size.height * 0.1921007);
    path_4.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1124841,
        size.width * 0.6821220,
        size.height * 0.04794248,
        size.width * 0.5616250,
        size.height * 0.04794248);
    path_4.cubicTo(
        size.width * 0.4411250,
        size.height * 0.04794248,
        size.width * 0.3434402,
        size.height * 0.1124841,
        size.width * 0.3434402,
        size.height * 0.1921007);
    path_4.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2031110,
        size.width * 0.3453085,
        size.height * 0.2138331,
        size.width * 0.3488470,
        size.height * 0.2241359);
    path_4.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1599379,
        size.width * 0.4577890,
        size.height * 0.1120138,
        size.width * 0.5616244,
        size.height * 0.1120138);
    path_4.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1120138,
        size.width * 0.7523537,
        size.height * 0.1599393,
        size.width * 0.7744024,
        size.height * 0.2241372);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3293390, size.height * 0.2071000);
    path_5.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2182041,
        size.width * 0.3235116,
        size.height * 0.2297593,
        size.width * 0.3235116,
        size.height * 0.2416255);
    path_5.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3274269,
        size.width * 0.4287841,
        size.height * 0.3969828,
        size.width * 0.5586451,
        size.height * 0.3969828);
    path_5.cubicTo(
        size.width * 0.6885061,
        size.height * 0.3969828,
        size.width * 0.7937805,
        size.height * 0.3274269,
        size.width * 0.7937805,
        size.height * 0.2416255);
    path_5.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2297600,
        size.width * 0.7917683,
        size.height * 0.2182055,
        size.width * 0.7879512,
        size.height * 0.2071021);
    path_5.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2762869,
        size.width * 0.6705488,
        size.height * 0.3279338,
        size.width * 0.5586457,
        size.height * 0.3279338);
    path_5.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3279338,
        size.width * 0.3530988,
        size.height * 0.2762855,
        size.width * 0.3293390,
        size.height * 0.2071000);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_6.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_6.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_6.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_6.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_6.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_6.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_7.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_7.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_7.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_7.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_7.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_7.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_8.lineTo(size.width * 0.3232665, size.height * 0.2214455);
    path_8.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_8.lineTo(size.width * 0.3171854, size.height * 0.2219545);
    path_8.close();
    path_8.moveTo(size.width * 0.7993598, size.height * 0.2219545);
    path_8.lineTo(size.width * 0.8054390, size.height * 0.2214317);
    path_8.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_8.lineTo(size.width * 0.7993598, size.height * 0.2219545);
    path_8.close();
    path_8.moveTo(size.width * 0.5582720, size.height * 0.3865172);
    path_8.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_8.lineTo(size.width * 0.5582720, size.height * 0.3865172);
    path_8.close();
    path_8.moveTo(size.width * 0.3230152, size.height * 0.2299497);
    path_8.cubicTo(
        size.width * 0.3230152,
        size.height * 0.2274441,
        size.width * 0.3230994,
        size.height * 0.2249531,
        size.width * 0.3232652,
        size.height * 0.2224766);
    path_8.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_8.cubicTo(
        size.width * 0.3109159,
        size.height * 0.2242552,
        size.width * 0.3108201,
        size.height * 0.2270945,
        size.width * 0.3108201,
        size.height * 0.2299497);
    path_8.lineTo(size.width * 0.3230152, size.height * 0.2299497);
    path_8.close();
    path_8.moveTo(size.width * 0.5582720, size.height * 0.3912448);
    path_8.cubicTo(
        size.width * 0.4925677,
        size.height * 0.3912448,
        size.width * 0.4333756,
        size.height * 0.3726717,
        size.width * 0.3908073,
        size.height * 0.3430076);
    path_8.cubicTo(
        size.width * 0.3481415,
        size.height * 0.3132752,
        size.width * 0.3230152,
        size.height * 0.2731103,
        size.width * 0.3230152,
        size.height * 0.2299497);
    path_8.lineTo(size.width * 0.3108201, size.height * 0.2299497);
    path_8.cubicTo(
        size.width * 0.3108201,
        size.height * 0.2796786,
        size.width * 0.3397226,
        size.height * 0.3236097,
        size.width * 0.3844098,
        size.height * 0.3547503);
    path_8.cubicTo(
        size.width * 0.4291945,
        size.height * 0.3859593,
        size.width * 0.4906799,
        size.height * 0.4050379,
        size.width * 0.5582720,
        size.height * 0.4050379);
    path_8.lineTo(size.width * 0.5582720, size.height * 0.3912448);
    path_8.close();
    path_8.moveTo(size.width * 0.7935305, size.height * 0.2299497);
    path_8.cubicTo(
        size.width * 0.7935305,
        size.height * 0.2731103,
        size.width * 0.7684024,
        size.height * 0.3132752,
        size.width * 0.7257378,
        size.height * 0.3430076);
    path_8.cubicTo(
        size.width * 0.6831707,
        size.height * 0.3726717,
        size.width * 0.6239756,
        size.height * 0.3912448,
        size.width * 0.5582720,
        size.height * 0.3912448);
    path_8.lineTo(size.width * 0.5582720, size.height * 0.4050379);
    path_8.cubicTo(
        size.width * 0.6258659,
        size.height * 0.4050379,
        size.width * 0.6873476,
        size.height * 0.3859593,
        size.width * 0.7321341,
        size.height * 0.3547503);
    path_8.cubicTo(
        size.width * 0.7768232,
        size.height * 0.3236097,
        size.width * 0.8057256,
        size.height * 0.2796786,
        size.width * 0.8057256,
        size.height * 0.2299497);
    path_8.lineTo(size.width * 0.7935305, size.height * 0.2299497);
    path_8.close();
    path_8.moveTo(size.width * 0.7932805, size.height * 0.2224766);
    path_8.cubicTo(
        size.width * 0.7934451,
        size.height * 0.2249531,
        size.width * 0.7935305,
        size.height * 0.2274441,
        size.width * 0.7935305,
        size.height * 0.2299497);
    path_8.lineTo(size.width * 0.8057256, size.height * 0.2299497);
    path_8.cubicTo(
        size.width * 0.8057256,
        size.height * 0.2270952,
        size.width * 0.8056280,
        size.height * 0.2242552,
        size.width * 0.8054390,
        size.height * 0.2214317);
    path_8.lineTo(size.width * 0.7932805, size.height * 0.2224766);
    path_8.close();
    path_8.moveTo(size.width * 0.7932744, size.height * 0.2214455);
    path_8.cubicTo(
        size.width * 0.7904817,
        size.height * 0.2642455,
        size.width * 0.7642988,
        size.height * 0.3036821,
        size.width * 0.7219512,
        size.height * 0.3326897);
    path_8.cubicTo(
        size.width * 0.6796951,
        size.height * 0.3616386,
        size.width * 0.6220427,
        size.height * 0.3796207,
        size.width * 0.5582720,
        size.height * 0.3796207);
    path_8.lineTo(size.width * 0.5582720, size.height * 0.3934138);
    path_8.cubicTo(
        size.width * 0.6239512,
        size.height * 0.3934138,
        size.width * 0.6838476,
        size.height * 0.3749193,
        size.width * 0.7282744,
        size.height * 0.3444876);
    path_8.cubicTo(
        size.width * 0.7726098,
        size.height * 0.3141166,
        size.width * 0.8022500,
        size.height * 0.2712710,
        size.width * 0.8054390,
        size.height * 0.2224628);
    path_8.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_8.close();
    path_8.moveTo(size.width * 0.5582720, size.height * 0.3796207);
    path_8.cubicTo(
        size.width * 0.4944988,
        size.height * 0.3796207,
        size.width * 0.4368488,
        size.height * 0.3616386,
        size.width * 0.3945896,
        size.height * 0.3326897);
    path_8.cubicTo(
        size.width * 0.3522433,
        size.height * 0.3036821,
        size.width * 0.3260646,
        size.height * 0.2642455,
        size.width * 0.3232665,
        size.height * 0.2214455);
    path_8.lineTo(size.width * 0.3111043, size.height * 0.2224628);
    path_8.cubicTo(
        size.width * 0.3142951,
        size.height * 0.2712710,
        size.width * 0.3439348,
        size.height * 0.3141159,
        size.width * 0.3882720,
        size.height * 0.3444876);
    path_8.cubicTo(
        size.width * 0.4326957,
        size.height * 0.3749193,
        size.width * 0.4925951,
        size.height * 0.3934138,
        size.width * 0.5582720,
        size.height * 0.3934138);
    path_8.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.7796707, size.height * 0.1913793);
    path_9.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2300317,
        size.width * 0.7558537,
        size.height * 0.2656938,
        size.width * 0.7160671,
        size.height * 0.2918931);
    path_9.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3180400,
        size.width * 0.6212927,
        size.height * 0.3343283,
        size.width * 0.5602970,
        size.height * 0.3343283);
    path_9.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3343283,
        size.width * 0.4442335,
        size.height * 0.3180400,
        size.width * 0.4045250,
        size.height * 0.2918931);
    path_9.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2656938,
        size.width * 0.3409213,
        size.height * 0.2300317,
        size.width * 0.3409213,
        size.height * 0.1913793);
    path_9.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1527269,
        size.width * 0.3647378,
        size.height * 0.1170648,
        size.width * 0.4045250,
        size.height * 0.09086552);
    path_9.cubicTo(
        size.width * 0.4442335,
        size.height * 0.06471834,
        size.width * 0.4993000,
        size.height * 0.04843062,
        size.width * 0.5602970,
        size.height * 0.04843062);
    path_9.cubicTo(
        size.width * 0.6212927,
        size.height * 0.04843062,
        size.width * 0.6763598,
        size.height * 0.06471834,
        size.width * 0.7160671,
        size.height * 0.09086552);
    path_9.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1170648,
        size.width * 0.7796707,
        size.height * 0.1527269,
        size.width * 0.7796707,
        size.height * 0.1913793);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 1
class WinPrizeClaimAsset1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6983241),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6920897),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3657359);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2936883,
        size.width * 0.3100006,
        size.height * 0.2674207,
        size.width * 0.3226079,
        size.height * 0.2632931);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2287614);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1980269,
        size.width * 0.3263305,
        size.height * 0.1661469,
        size.width * 0.3437433,
        size.height * 0.1425510);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.07481034,
        size.width * 0.4950689,
        size.height * 0.04827586,
        size.width * 0.5575037,
        size.height * 0.04827586);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.04827586,
        size.width * 0.7592073,
        size.height * 0.1103703,
        size.width * 0.7860122,
        size.height * 0.1596745);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1800862,
        size.width * 0.7993659,
        size.height * 0.2045503,
        size.width * 0.7993659,
        size.height * 0.2285117);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2632931);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2948138,
        size.width * 0.8385183,
        size.height * 0.3387179,
        size.width * 0.8361951,
        size.height * 0.3567297);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6606807);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.7177172,
        size.width * 0.7394512,
        size.height * 0.8290897,
        size.width * 0.5475506,
        size.height * 0.8182828);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.8074759,
        size.width * 0.2890988,
        size.height * 0.7087103,
        size.width * 0.2798091,
        size.height * 0.6606807);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3657359);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.6094159),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffBDAE87).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5025982, size.height * 0.6196434),
            width: size.width * 0.2383098,
            height: size.height * 0.1645586),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3687598, size.height * 0.6131524);
    path_5.lineTo(size.width * 0.3689591, size.height * 0.6131524);
    path_5.cubicTo(
        size.width * 0.3704841,
        size.height * 0.6325179,
        size.width * 0.3809341,
        size.height * 0.6512731,
        size.width * 0.3998354,
        size.height * 0.6656855);
    path_5.cubicTo(
        size.width * 0.4203299,
        size.height * 0.6813131,
        size.width * 0.4470683,
        size.height * 0.6890517,
        size.width * 0.4736927,
        size.height * 0.6890517);
    path_5.cubicTo(
        size.width * 0.5003171,
        size.height * 0.6890517,
        size.width * 0.5270555,
        size.height * 0.6813131,
        size.width * 0.5475500,
        size.height * 0.6656855);
    path_5.cubicTo(
        size.width * 0.5664512,
        size.height * 0.6512731,
        size.width * 0.5769012,
        size.height * 0.6325179,
        size.width * 0.5784262,
        size.height * 0.6131524);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.6131524);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.6105662);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5728207);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5702345);
    path_5.lineTo(size.width * 0.5764256, size.height * 0.5702345);
    path_5.lineTo(size.width * 0.5664116, size.height * 0.5702345);
    path_5.cubicTo(
        size.width * 0.5615482,
        size.height * 0.5631710,
        size.width * 0.5552518,
        size.height * 0.5565828,
        size.width * 0.5475500,
        size.height * 0.5507097);
    path_5.cubicTo(
        size.width * 0.5270555,
        size.height * 0.5350821,
        size.width * 0.5003171,
        size.height * 0.5273434,
        size.width * 0.4736927,
        size.height * 0.5273434);
    path_5.cubicTo(
        size.width * 0.4470683,
        size.height * 0.5273434,
        size.width * 0.4203299,
        size.height * 0.5350821,
        size.width * 0.3998354,
        size.height * 0.5507097);
    path_5.cubicTo(
        size.width * 0.3921335,
        size.height * 0.5565828,
        size.width * 0.3858372,
        size.height * 0.5631710,
        size.width * 0.3809738,
        size.height * 0.5702345);
    path_5.lineTo(size.width * 0.3710463, size.height * 0.5702345);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5702345);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5728207);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.6105662);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.6131524);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3998427, size.height * 0.6358703);
    path_6.cubicTo(
        size.width * 0.4203372,
        size.height * 0.6514979,
        size.width * 0.4470756,
        size.height * 0.6592359,
        size.width * 0.4737000,
        size.height * 0.6592359);
    path_6.cubicTo(
        size.width * 0.5003244,
        size.height * 0.6592359,
        size.width * 0.5270628,
        size.height * 0.6514979,
        size.width * 0.5475573,
        size.height * 0.6358703);
    path_6.cubicTo(
        size.width * 0.5680713,
        size.height * 0.6202276,
        size.width * 0.5786287,
        size.height * 0.5994683,
        size.width * 0.5786287,
        size.height * 0.5783821);
    path_6.cubicTo(
        size.width * 0.5786287,
        size.height * 0.5572959,
        size.width * 0.5680713,
        size.height * 0.5365366,
        size.width * 0.5475573,
        size.height * 0.5208945);
    path_6.cubicTo(
        size.width * 0.5270628,
        size.height * 0.5052662,
        size.width * 0.5003244,
        size.height * 0.4975283,
        size.width * 0.4737000,
        size.height * 0.4975283);
    path_6.cubicTo(
        size.width * 0.4470756,
        size.height * 0.4975283,
        size.width * 0.4203372,
        size.height * 0.5052662,
        size.width * 0.3998427,
        size.height * 0.5208945);
    path_6.cubicTo(
        size.width * 0.3793287,
        size.height * 0.5365372,
        size.width * 0.3687713,
        size.height * 0.5572966,
        size.width * 0.3687713,
        size.height * 0.5783821);
    path_6.cubicTo(
        size.width * 0.3687713,
        size.height * 0.5994683,
        size.width * 0.3793287,
        size.height * 0.6202276,
        size.width * 0.3998427,
        size.height * 0.6358703);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_6_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4229915, size.height * 0.6182172);
    path_7.cubicTo(
        size.width * 0.4370927,
        size.height * 0.6289697,
        size.width * 0.4554518,
        size.height * 0.6342703,
        size.width * 0.4736970,
        size.height * 0.6342703);
    path_7.cubicTo(
        size.width * 0.4919415,
        size.height * 0.6342703,
        size.width * 0.5103006,
        size.height * 0.6289697,
        size.width * 0.5244018,
        size.height * 0.6182172);
    path_7.cubicTo(
        size.width * 0.5385226,
        size.height * 0.6074497,
        size.width * 0.5458835,
        size.height * 0.5930800,
        size.width * 0.5458835,
        size.height * 0.5783834);
    path_7.cubicTo(
        size.width * 0.5458835,
        size.height * 0.5636869,
        size.width * 0.5385226,
        size.height * 0.5493172,
        size.width * 0.5244018,
        size.height * 0.5385497);
    path_7.cubicTo(
        size.width * 0.5103006,
        size.height * 0.5277972,
        size.width * 0.4919415,
        size.height * 0.5224966,
        size.width * 0.4736970,
        size.height * 0.5224966);
    path_7.cubicTo(
        size.width * 0.4554518,
        size.height * 0.5224966,
        size.width * 0.4370927,
        size.height * 0.5277972,
        size.width * 0.4229915,
        size.height * 0.5385497);
    path_7.cubicTo(
        size.width * 0.4088707,
        size.height * 0.5493172,
        size.width * 0.4015104,
        size.height * 0.5636869,
        size.width * 0.4015104,
        size.height * 0.5783834);
    path_7.cubicTo(
        size.width * 0.4015104,
        size.height * 0.5930800,
        size.width * 0.4088707,
        size.height * 0.6074497,
        size.width * 0.4229915,
        size.height * 0.6182172);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_7_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.5066159, size.height * 0.5313476);
    path_8.cubicTo(
        size.width * 0.4812817,
        size.height * 0.5233579,
        size.width * 0.4510360,
        size.height * 0.5272152,
        size.width * 0.4304433,
        size.height * 0.5429179);
    path_8.cubicTo(
        size.width * 0.4031457,
        size.height * 0.5637331,
        size.width * 0.4031457,
        size.height * 0.5974814,
        size.width * 0.4304433,
        size.height * 0.6182966);
    path_8.cubicTo(
        size.width * 0.4354457,
        size.height * 0.6221110,
        size.width * 0.4410177,
        size.height * 0.6252269,
        size.width * 0.4469506,
        size.height * 0.6276434);
    path_8.cubicTo(
        size.width * 0.4387024,
        size.height * 0.6250421,
        size.width * 0.4309744,
        size.height * 0.6211855,
        size.width * 0.4242701,
        size.height * 0.6160731);
    path_8.cubicTo(
        size.width * 0.3969726,
        size.height * 0.5952572,
        size.width * 0.3969726,
        size.height * 0.5615090,
        size.width * 0.4242701,
        size.height * 0.5406938);
    path_8.cubicTo(
        size.width * 0.4465652,
        size.height * 0.5236931,
        size.width * 0.4801744,
        size.height * 0.5205779,
        size.width * 0.5066159,
        size.height * 0.5313476);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.7744024, size.height * 0.2448269);
    path_9.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2345241,
        size.width * 0.7798110,
        size.height * 0.2238014,
        size.width * 0.7798110,
        size.height * 0.2127903);
    path_9.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1331738,
        size.width * 0.6821220,
        size.height * 0.06863214,
        size.width * 0.5616250,
        size.height * 0.06863214);
    path_9.cubicTo(
        size.width * 0.4411250,
        size.height * 0.06863214,
        size.width * 0.3434402,
        size.height * 0.1331738,
        size.width * 0.3434402,
        size.height * 0.2127903);
    path_9.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2238007,
        size.width * 0.3453085,
        size.height * 0.2345228,
        size.width * 0.3488470,
        size.height * 0.2448255);
    path_9.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1806276,
        size.width * 0.4577890,
        size.height * 0.1327034,
        size.width * 0.5616244,
        size.height * 0.1327034);
    path_9.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1327034,
        size.width * 0.7523537,
        size.height * 0.1806290,
        size.width * 0.7744024,
        size.height * 0.2448269);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.3293390, size.height * 0.2277897);
    path_10.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2388938,
        size.width * 0.3235116,
        size.height * 0.2504490,
        size.width * 0.3235116,
        size.height * 0.2623152);
    path_10.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3481166,
        size.width * 0.4287841,
        size.height * 0.4176724,
        size.width * 0.5586451,
        size.height * 0.4176724);
    path_10.cubicTo(
        size.width * 0.6885061,
        size.height * 0.4176724,
        size.width * 0.7937805,
        size.height * 0.3481166,
        size.width * 0.7937805,
        size.height * 0.2623152);
    path_10.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2504497,
        size.width * 0.7917683,
        size.height * 0.2388952,
        size.width * 0.7879512,
        size.height * 0.2277917);
    path_10.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2969766,
        size.width * 0.6705488,
        size.height * 0.3486234,
        size.width * 0.5586457,
        size.height * 0.3486234);
    path_10.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3486234,
        size.width * 0.3530988,
        size.height * 0.2969752,
        size.width * 0.3293390,
        size.height * 0.2277897);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.3171854, size.height * 0.2426441);
    path_11.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2452938,
        size.width * 0.3169177,
        size.height * 0.2479593,
        size.width * 0.3169177,
        size.height * 0.2506393);
    path_11.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3435290,
        size.width * 0.4249756,
        size.height * 0.4188310,
        size.width * 0.5582720,
        size.height * 0.4188310);
    path_11.cubicTo(
        size.width * 0.6915671,
        size.height * 0.4188310,
        size.width * 0.7996280,
        size.height * 0.3435290,
        size.width * 0.7996280,
        size.height * 0.2506393);
    path_11.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2479593,
        size.width * 0.7995366,
        size.height * 0.2452938,
        size.width * 0.7993598,
        size.height * 0.2426441);
    path_11.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3342517,
        size.width * 0.6877195,
        size.height * 0.4072069,
        size.width * 0.5582720,
        size.height * 0.4072069);
    path_11.cubicTo(
        size.width * 0.4288220,
        size.height * 0.4072069,
        size.width * 0.3231744,
        size.height * 0.3342517,
        size.width * 0.3171854,
        size.height * 0.2426441);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.3171854, size.height * 0.2426441);
    path_12.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2452938,
        size.width * 0.3169177,
        size.height * 0.2479593,
        size.width * 0.3169177,
        size.height * 0.2506393);
    path_12.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3435290,
        size.width * 0.4249756,
        size.height * 0.4188310,
        size.width * 0.5582720,
        size.height * 0.4188310);
    path_12.cubicTo(
        size.width * 0.6915671,
        size.height * 0.4188310,
        size.width * 0.7996280,
        size.height * 0.3435290,
        size.width * 0.7996280,
        size.height * 0.2506393);
    path_12.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2479593,
        size.width * 0.7995366,
        size.height * 0.2452938,
        size.width * 0.7993598,
        size.height * 0.2426441);
    path_12.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3342517,
        size.width * 0.6877195,
        size.height * 0.4072069,
        size.width * 0.5582720,
        size.height * 0.4072069);
    path_12.cubicTo(
        size.width * 0.4288220,
        size.height * 0.4072069,
        size.width * 0.3231744,
        size.height * 0.3342517,
        size.width * 0.3171854,
        size.height * 0.2426441);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.3171854, size.height * 0.2426441);
    path_13.lineTo(size.width * 0.3232665, size.height * 0.2421352);
    path_13.lineTo(size.width * 0.3111055, size.height * 0.2421214);
    path_13.lineTo(size.width * 0.3171854, size.height * 0.2426441);
    path_13.close();
    path_13.moveTo(size.width * 0.7993598, size.height * 0.2426441);
    path_13.lineTo(size.width * 0.8054390, size.height * 0.2421214);
    path_13.lineTo(size.width * 0.7932744, size.height * 0.2421352);
    path_13.lineTo(size.width * 0.7993598, size.height * 0.2426441);
    path_13.close();
    path_13.moveTo(size.width * 0.5582720, size.height * 0.4072069);
    path_13.lineTo(size.width * 0.5582720, size.height * 0.4003103);
    path_13.lineTo(size.width * 0.5582720, size.height * 0.4072069);
    path_13.close();
    path_13.moveTo(size.width * 0.3230152, size.height * 0.2506393);
    path_13.cubicTo(
        size.width * 0.3230152,
        size.height * 0.2481338,
        size.width * 0.3230994,
        size.height * 0.2456428,
        size.width * 0.3232652,
        size.height * 0.2431662);
    path_13.lineTo(size.width * 0.3111055, size.height * 0.2421214);
    path_13.cubicTo(
        size.width * 0.3109159,
        size.height * 0.2449448,
        size.width * 0.3108201,
        size.height * 0.2477841,
        size.width * 0.3108201,
        size.height * 0.2506393);
    path_13.lineTo(size.width * 0.3230152, size.height * 0.2506393);
    path_13.close();
    path_13.moveTo(size.width * 0.5582720, size.height * 0.4119345);
    path_13.cubicTo(
        size.width * 0.4925677,
        size.height * 0.4119345,
        size.width * 0.4333756,
        size.height * 0.3933614,
        size.width * 0.3908073,
        size.height * 0.3636972);
    path_13.cubicTo(
        size.width * 0.3481415,
        size.height * 0.3339648,
        size.width * 0.3230152,
        size.height * 0.2938000,
        size.width * 0.3230152,
        size.height * 0.2506393);
    path_13.lineTo(size.width * 0.3108201, size.height * 0.2506393);
    path_13.cubicTo(
        size.width * 0.3108201,
        size.height * 0.3003683,
        size.width * 0.3397226,
        size.height * 0.3442993,
        size.width * 0.3844098,
        size.height * 0.3754400);
    path_13.cubicTo(
        size.width * 0.4291945,
        size.height * 0.4066490,
        size.width * 0.4906799,
        size.height * 0.4257276,
        size.width * 0.5582720,
        size.height * 0.4257276);
    path_13.lineTo(size.width * 0.5582720, size.height * 0.4119345);
    path_13.close();
    path_13.moveTo(size.width * 0.7935305, size.height * 0.2506393);
    path_13.cubicTo(
        size.width * 0.7935305,
        size.height * 0.2938000,
        size.width * 0.7684024,
        size.height * 0.3339648,
        size.width * 0.7257378,
        size.height * 0.3636972);
    path_13.cubicTo(
        size.width * 0.6831707,
        size.height * 0.3933614,
        size.width * 0.6239756,
        size.height * 0.4119345,
        size.width * 0.5582720,
        size.height * 0.4119345);
    path_13.lineTo(size.width * 0.5582720, size.height * 0.4257276);
    path_13.cubicTo(
        size.width * 0.6258659,
        size.height * 0.4257276,
        size.width * 0.6873476,
        size.height * 0.4066490,
        size.width * 0.7321341,
        size.height * 0.3754400);
    path_13.cubicTo(
        size.width * 0.7768232,
        size.height * 0.3442993,
        size.width * 0.8057256,
        size.height * 0.3003683,
        size.width * 0.8057256,
        size.height * 0.2506393);
    path_13.lineTo(size.width * 0.7935305, size.height * 0.2506393);
    path_13.close();
    path_13.moveTo(size.width * 0.7932805, size.height * 0.2431662);
    path_13.cubicTo(
        size.width * 0.7934451,
        size.height * 0.2456428,
        size.width * 0.7935305,
        size.height * 0.2481338,
        size.width * 0.7935305,
        size.height * 0.2506393);
    path_13.lineTo(size.width * 0.8057256, size.height * 0.2506393);
    path_13.cubicTo(
        size.width * 0.8057256,
        size.height * 0.2477848,
        size.width * 0.8056280,
        size.height * 0.2449448,
        size.width * 0.8054390,
        size.height * 0.2421214);
    path_13.lineTo(size.width * 0.7932805, size.height * 0.2431662);
    path_13.close();
    path_13.moveTo(size.width * 0.7932744, size.height * 0.2421352);
    path_13.cubicTo(
        size.width * 0.7904817,
        size.height * 0.2849352,
        size.width * 0.7642988,
        size.height * 0.3243717,
        size.width * 0.7219512,
        size.height * 0.3533793);
    path_13.cubicTo(
        size.width * 0.6796951,
        size.height * 0.3823283,
        size.width * 0.6220427,
        size.height * 0.4003103,
        size.width * 0.5582720,
        size.height * 0.4003103);
    path_13.lineTo(size.width * 0.5582720, size.height * 0.4141034);
    path_13.cubicTo(
        size.width * 0.6239512,
        size.height * 0.4141034,
        size.width * 0.6838476,
        size.height * 0.3956090,
        size.width * 0.7282744,
        size.height * 0.3651772);
    path_13.cubicTo(
        size.width * 0.7726098,
        size.height * 0.3348062,
        size.width * 0.8022500,
        size.height * 0.2919607,
        size.width * 0.8054390,
        size.height * 0.2431524);
    path_13.lineTo(size.width * 0.7932744, size.height * 0.2421352);
    path_13.close();
    path_13.moveTo(size.width * 0.5582720, size.height * 0.4003103);
    path_13.cubicTo(
        size.width * 0.4944988,
        size.height * 0.4003103,
        size.width * 0.4368488,
        size.height * 0.3823283,
        size.width * 0.3945896,
        size.height * 0.3533793);
    path_13.cubicTo(
        size.width * 0.3522433,
        size.height * 0.3243717,
        size.width * 0.3260646,
        size.height * 0.2849352,
        size.width * 0.3232665,
        size.height * 0.2421352);
    path_13.lineTo(size.width * 0.3111043, size.height * 0.2431524);
    path_13.cubicTo(
        size.width * 0.3142951,
        size.height * 0.2919607,
        size.width * 0.3439348,
        size.height * 0.3348055,
        size.width * 0.3882720,
        size.height * 0.3651772);
    path_13.cubicTo(
        size.width * 0.4326957,
        size.height * 0.3956090,
        size.width * 0.4925951,
        size.height * 0.4141034,
        size.width * 0.5582720,
        size.height * 0.4141034);
    path_13.lineTo(size.width * 0.5582720, size.height * 0.4003103);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.7796707, size.height * 0.2120690);
    path_14.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2507214,
        size.width * 0.7558537,
        size.height * 0.2863834,
        size.width * 0.7160671,
        size.height * 0.3125828);
    path_14.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3387297,
        size.width * 0.6212927,
        size.height * 0.3550179,
        size.width * 0.5602970,
        size.height * 0.3550179);
    path_14.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3550179,
        size.width * 0.4442335,
        size.height * 0.3387297,
        size.width * 0.4045250,
        size.height * 0.3125828);
    path_14.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2863834,
        size.width * 0.3409213,
        size.height * 0.2507214,
        size.width * 0.3409213,
        size.height * 0.2120690);
    path_14.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1734166,
        size.width * 0.3647378,
        size.height * 0.1377545,
        size.width * 0.4045250,
        size.height * 0.1115552);
    path_14.cubicTo(
        size.width * 0.4442335,
        size.height * 0.08540828,
        size.width * 0.4993000,
        size.height * 0.06912000,
        size.width * 0.5602970,
        size.height * 0.06912000);
    path_14.cubicTo(
        size.width * 0.6212927,
        size.height * 0.06912000,
        size.width * 0.6763598,
        size.height * 0.08540828,
        size.width * 0.7160671,
        size.height * 0.1115552);
    path_14.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1377545,
        size.width * 0.7796707,
        size.height * 0.1734166,
        size.width * 0.7796707,
        size.height * 0.2120690);
    path_14.close();

    Paint paint_14_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_14_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_stroke);

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 2
class WinPrizeClaimAsset2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6776366),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6714021),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2729986,
        size.width * 0.3100006,
        size.height * 0.2467310,
        size.width * 0.3226079,
        size.height * 0.2426034);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2080717);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1773372,
        size.width * 0.3263305,
        size.height * 0.1454572,
        size.width * 0.3437433,
        size.height * 0.1218614);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.05412041,
        size.width * 0.4950689,
        size.height * 0.02758621,
        size.width * 0.5575037,
        size.height * 0.02758621);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.02758621,
        size.width * 0.7592073,
        size.height * 0.08968069,
        size.width * 0.7860122,
        size.height * 0.1389848);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1593966,
        size.width * 0.7993659,
        size.height * 0.1838607,
        size.width * 0.7993659,
        size.height * 0.2078221);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2426034);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2741241,
        size.width * 0.8385183,
        size.height * 0.3180283,
        size.width * 0.8361951,
        size.height * 0.3360400);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6399910);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.6970276,
        size.width * 0.7394512,
        size.height * 0.8084000,
        size.width * 0.5475506,
        size.height * 0.7975931);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.7867862,
        size.width * 0.2890988,
        size.height * 0.6880228,
        size.width * 0.2798091,
        size.height * 0.6399910);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.5887262),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffBDAE87).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5768939, size.height * 0.5780490),
            width: size.width * 0.3446463,
            height: size.height * 0.2379876),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3687598, size.height * 0.5924600);
    path_5.lineTo(size.width * 0.3689591, size.height * 0.5924600);
    path_5.cubicTo(
        size.width * 0.3704841,
        size.height * 0.6118248,
        size.width * 0.3809341,
        size.height * 0.6305800,
        size.width * 0.3998354,
        size.height * 0.6449924);
    path_5.cubicTo(
        size.width * 0.4203299,
        size.height * 0.6606200,
        size.width * 0.4470683,
        size.height * 0.6683586,
        size.width * 0.4736927,
        size.height * 0.6683586);
    path_5.cubicTo(
        size.width * 0.5003171,
        size.height * 0.6683586,
        size.width * 0.5270555,
        size.height * 0.6606200,
        size.width * 0.5475500,
        size.height * 0.6449924);
    path_5.cubicTo(
        size.width * 0.5664512,
        size.height * 0.6305800,
        size.width * 0.5769012,
        size.height * 0.6118248,
        size.width * 0.5784262,
        size.height * 0.5924600);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5924600);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5898738);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5521276);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5495414);
    path_5.lineTo(size.width * 0.5764256, size.height * 0.5495414);
    path_5.lineTo(size.width * 0.5664116, size.height * 0.5495414);
    path_5.cubicTo(
        size.width * 0.5615482,
        size.height * 0.5424779,
        size.width * 0.5552518,
        size.height * 0.5358897,
        size.width * 0.5475500,
        size.height * 0.5300166);
    path_5.cubicTo(
        size.width * 0.5270555,
        size.height * 0.5143890,
        size.width * 0.5003171,
        size.height * 0.5066510,
        size.width * 0.4736927,
        size.height * 0.5066510);
    path_5.cubicTo(
        size.width * 0.4470683,
        size.height * 0.5066510,
        size.width * 0.4203299,
        size.height * 0.5143890,
        size.width * 0.3998354,
        size.height * 0.5300166);
    path_5.cubicTo(
        size.width * 0.3921335,
        size.height * 0.5358897,
        size.width * 0.3858372,
        size.height * 0.5424779,
        size.width * 0.3809738,
        size.height * 0.5495414);
    path_5.lineTo(size.width * 0.3710463, size.height * 0.5495414);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5495414);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5521276);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5898738);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5924600);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3998427, size.height * 0.6151772);
    path_6.cubicTo(
        size.width * 0.4203372,
        size.height * 0.6308048,
        size.width * 0.4470756,
        size.height * 0.6385428,
        size.width * 0.4737000,
        size.height * 0.6385428);
    path_6.cubicTo(
        size.width * 0.5003244,
        size.height * 0.6385428,
        size.width * 0.5270628,
        size.height * 0.6308048,
        size.width * 0.5475573,
        size.height * 0.6151772);
    path_6.cubicTo(
        size.width * 0.5680713,
        size.height * 0.5995345,
        size.width * 0.5786287,
        size.height * 0.5787752,
        size.width * 0.5786287,
        size.height * 0.5576890);
    path_6.cubicTo(
        size.width * 0.5786287,
        size.height * 0.5366034,
        size.width * 0.5680713,
        size.height * 0.5158441,
        size.width * 0.5475573,
        size.height * 0.5002014);
    path_6.cubicTo(
        size.width * 0.5270628,
        size.height * 0.4845738,
        size.width * 0.5003244,
        size.height * 0.4768352,
        size.width * 0.4737000,
        size.height * 0.4768352);
    path_6.cubicTo(
        size.width * 0.4470756,
        size.height * 0.4768352,
        size.width * 0.4203372,
        size.height * 0.4845738,
        size.width * 0.3998427,
        size.height * 0.5002014);
    path_6.cubicTo(
        size.width * 0.3793287,
        size.height * 0.5158441,
        size.width * 0.3687713,
        size.height * 0.5366034,
        size.width * 0.3687713,
        size.height * 0.5576890);
    path_6.cubicTo(
        size.width * 0.3687713,
        size.height * 0.5787752,
        size.width * 0.3793287,
        size.height * 0.5995345,
        size.width * 0.3998427,
        size.height * 0.6151772);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_6_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4229915, size.height * 0.5975241);
    path_7.cubicTo(
        size.width * 0.4370927,
        size.height * 0.6082766,
        size.width * 0.4554518,
        size.height * 0.6135772,
        size.width * 0.4736970,
        size.height * 0.6135772);
    path_7.cubicTo(
        size.width * 0.4919415,
        size.height * 0.6135772,
        size.width * 0.5103006,
        size.height * 0.6082766,
        size.width * 0.5244018,
        size.height * 0.5975241);
    path_7.cubicTo(
        size.width * 0.5385226,
        size.height * 0.5867566,
        size.width * 0.5458835,
        size.height * 0.5723869,
        size.width * 0.5458835,
        size.height * 0.5576903);
    path_7.cubicTo(
        size.width * 0.5458835,
        size.height * 0.5429938,
        size.width * 0.5385226,
        size.height * 0.5286241,
        size.width * 0.5244018,
        size.height * 0.5178566);
    path_7.cubicTo(
        size.width * 0.5103006,
        size.height * 0.5071041,
        size.width * 0.4919415,
        size.height * 0.5018034,
        size.width * 0.4736970,
        size.height * 0.5018034);
    path_7.cubicTo(
        size.width * 0.4554518,
        size.height * 0.5018034,
        size.width * 0.4370927,
        size.height * 0.5071041,
        size.width * 0.4229915,
        size.height * 0.5178566);
    path_7.cubicTo(
        size.width * 0.4088707,
        size.height * 0.5286241,
        size.width * 0.4015104,
        size.height * 0.5429938,
        size.width * 0.4015104,
        size.height * 0.5576903);
    path_7.cubicTo(
        size.width * 0.4015104,
        size.height * 0.5723869,
        size.width * 0.4088707,
        size.height * 0.5867566,
        size.width * 0.4229915,
        size.height * 0.5975241);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_7_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.5066159, size.height * 0.5106545);
    path_8.cubicTo(
        size.width * 0.4812817,
        size.height * 0.5026655,
        size.width * 0.4510360,
        size.height * 0.5065221,
        size.width * 0.4304433,
        size.height * 0.5222248);
    path_8.cubicTo(
        size.width * 0.4031457,
        size.height * 0.5430400,
        size.width * 0.4031457,
        size.height * 0.5767883,
        size.width * 0.4304433,
        size.height * 0.5976034);
    path_8.cubicTo(
        size.width * 0.4354457,
        size.height * 0.6014179,
        size.width * 0.4410177,
        size.height * 0.6045338,
        size.width * 0.4469506,
        size.height * 0.6069503);
    path_8.cubicTo(
        size.width * 0.4387024,
        size.height * 0.6043490,
        size.width * 0.4309744,
        size.height * 0.6004924,
        size.width * 0.4242701,
        size.height * 0.5953800);
    path_8.cubicTo(
        size.width * 0.3969726,
        size.height * 0.5745648,
        size.width * 0.3969726,
        size.height * 0.5408166,
        size.width * 0.4242701,
        size.height * 0.5200007);
    path_8.cubicTo(
        size.width * 0.4465652,
        size.height * 0.5030000,
        size.width * 0.4801744,
        size.height * 0.4998848,
        size.width * 0.5066159,
        size.height * 0.5106545);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.5526598, size.height * 0.5388007);
    path_9.cubicTo(
        size.width * 0.5541854,
        size.height * 0.5581662,
        size.width * 0.5646354,
        size.height * 0.5769214,
        size.width * 0.5835366,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.6040311,
        size.height * 0.6069614,
        size.width * 0.6307683,
        size.height * 0.6147000,
        size.width * 0.6573963,
        size.height * 0.6147000);
    path_9.cubicTo(
        size.width * 0.6840183,
        size.height * 0.6147000,
        size.width * 0.7107561,
        size.height * 0.6069614,
        size.width * 0.7312500,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.7501524,
        size.height * 0.5769214,
        size.width * 0.7606037,
        size.height * 0.5581662,
        size.width * 0.7621280,
        size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7601280, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7501098, size.height * 0.4958828);
    path_9.cubicTo(
        size.width * 0.7452500,
        size.height * 0.4888193,
        size.width * 0.7389512,
        size.height * 0.4822310,
        size.width * 0.7312500,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.7107561,
        size.height * 0.4607303,
        size.width * 0.6840183,
        size.height * 0.4529917,
        size.width * 0.6573963,
        size.height * 0.4529917);
    path_9.cubicTo(
        size.width * 0.6307683,
        size.height * 0.4529917,
        size.width * 0.6040311,
        size.height * 0.4607303,
        size.width * 0.5835366,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.5758348,
        size.height * 0.4822310,
        size.width * 0.5695384,
        size.height * 0.4888193,
        size.width * 0.5646744,
        size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5547470, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5835439, size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.6040384,
        size.height * 0.5771476,
        size.width * 0.6307744,
        size.height * 0.5848862,
        size.width * 0.6574024,
        size.height * 0.5848862);
    path_10.cubicTo(
        size.width * 0.6840244,
        size.height * 0.5848862,
        size.width * 0.7107622,
        size.height * 0.5771476,
        size.width * 0.7312561,
        size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.7517744,
        size.height * 0.5458772,
        size.width * 0.7623293,
        size.height * 0.5251179,
        size.width * 0.7623293,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.7623293,
        size.height * 0.4829462,
        size.width * 0.7517744,
        size.height * 0.4621869,
        size.width * 0.7312561,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.7107622,
        size.height * 0.4309166,
        size.width * 0.6840244,
        size.height * 0.4231779,
        size.width * 0.6574024,
        size.height * 0.4231779);
    path_10.cubicTo(
        size.width * 0.6307744,
        size.height * 0.4231779,
        size.width * 0.6040384,
        size.height * 0.4309166,
        size.width * 0.5835439,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.5630299,
        size.height * 0.4621869,
        size.width * 0.5524726,
        size.height * 0.4829462,
        size.width * 0.5524726,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.5524726,
        size.height * 0.5251179,
        size.width * 0.5630299,
        size.height * 0.5458772,
        size.width * 0.5835439,
        size.height * 0.5615200);
    path_10.close();

    Paint paint_10_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_10_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_stroke);

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.6066927, size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.6207927,
        size.height * 0.5546179,
        size.width * 0.6391524,
        size.height * 0.5599186,
        size.width * 0.6573963,
        size.height * 0.5599186);
    path_11.cubicTo(
        size.width * 0.6756402,
        size.height * 0.5599186,
        size.width * 0.6940000,
        size.height * 0.5546179,
        size.width * 0.7081037,
        size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.7222256,
        size.height * 0.5330979,
        size.width * 0.7295854,
        size.height * 0.5187283,
        size.width * 0.7295854,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.7295854,
        size.height * 0.4893352,
        size.width * 0.7222256,
        size.height * 0.4749655,
        size.width * 0.7081037,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.6940000,
        size.height * 0.4534455,
        size.width * 0.6756402,
        size.height * 0.4481448,
        size.width * 0.6573963,
        size.height * 0.4481448);
    path_11.cubicTo(
        size.width * 0.6391524,
        size.height * 0.4481448,
        size.width * 0.6207927,
        size.height * 0.4534455,
        size.width * 0.6066927,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.5925720,
        size.height * 0.4749655,
        size.width * 0.5852110,
        size.height * 0.4893352,
        size.width * 0.5852110,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.5852110,
        size.height * 0.5187283,
        size.width * 0.5925720,
        size.height * 0.5330979,
        size.width * 0.6066927,
        size.height * 0.5438655);
    path_11.close();

    Paint paint_11_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_11_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_stroke);

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.6903171, size.height * 0.4569959);
    path_12.cubicTo(
        size.width * 0.6649817,
        size.height * 0.4490062,
        size.width * 0.6347378,
        size.height * 0.4528634,
        size.width * 0.6141463,
        size.height * 0.4685662);
    path_12.cubicTo(
        size.width * 0.5868463,
        size.height * 0.4893814,
        size.width * 0.5868463,
        size.height * 0.5231297,
        size.width * 0.6141463,
        size.height * 0.5439448);
    path_12.cubicTo(
        size.width * 0.6191463,
        size.height * 0.5477593,
        size.width * 0.6247195,
        size.height * 0.5508752,
        size.width * 0.6306524,
        size.height * 0.5532917);
    path_12.cubicTo(
        size.width * 0.6224024,
        size.height * 0.5506903,
        size.width * 0.6146768,
        size.height * 0.5468338,
        size.width * 0.6079707,
        size.height * 0.5417214);
    path_12.cubicTo(
        size.width * 0.5806732,
        size.height * 0.5209055,
        size.width * 0.5806732,
        size.height * 0.4871572,
        size.width * 0.6079707,
        size.height * 0.4663421);
    path_12.cubicTo(
        size.width * 0.6302683,
        size.height * 0.4493414,
        size.width * 0.6638780,
        size.height * 0.4462262,
        size.width * 0.6903171,
        size.height * 0.4569959);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.7744024, size.height * 0.2241372);
    path_13.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2138345,
        size.width * 0.7798110,
        size.height * 0.2031117,
        size.width * 0.7798110,
        size.height * 0.1921007);
    path_13.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1124841,
        size.width * 0.6821220,
        size.height * 0.04794248,
        size.width * 0.5616250,
        size.height * 0.04794248);
    path_13.cubicTo(
        size.width * 0.4411250,
        size.height * 0.04794248,
        size.width * 0.3434402,
        size.height * 0.1124841,
        size.width * 0.3434402,
        size.height * 0.1921007);
    path_13.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2031110,
        size.width * 0.3453085,
        size.height * 0.2138331,
        size.width * 0.3488470,
        size.height * 0.2241359);
    path_13.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1599379,
        size.width * 0.4577890,
        size.height * 0.1120138,
        size.width * 0.5616244,
        size.height * 0.1120138);
    path_13.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1120138,
        size.width * 0.7523537,
        size.height * 0.1599393,
        size.width * 0.7744024,
        size.height * 0.2241372);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.3293390, size.height * 0.2071000);
    path_14.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2182041,
        size.width * 0.3235116,
        size.height * 0.2297593,
        size.width * 0.3235116,
        size.height * 0.2416255);
    path_14.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3274269,
        size.width * 0.4287841,
        size.height * 0.3969828,
        size.width * 0.5586451,
        size.height * 0.3969828);
    path_14.cubicTo(
        size.width * 0.6885061,
        size.height * 0.3969828,
        size.width * 0.7937805,
        size.height * 0.3274269,
        size.width * 0.7937805,
        size.height * 0.2416255);
    path_14.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2297600,
        size.width * 0.7917683,
        size.height * 0.2182055,
        size.width * 0.7879512,
        size.height * 0.2071021);
    path_14.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2762869,
        size.width * 0.6705488,
        size.height * 0.3279338,
        size.width * 0.5586457,
        size.height * 0.3279338);
    path_14.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3279338,
        size.width * 0.3530988,
        size.height * 0.2762855,
        size.width * 0.3293390,
        size.height * 0.2071000);
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_15.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_15.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_15.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_15.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_15.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_15.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_16.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_16.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_16.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_16.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_16.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_16.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_17.lineTo(size.width * 0.3232665, size.height * 0.2214455);
    path_17.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_17.lineTo(size.width * 0.3171854, size.height * 0.2219545);
    path_17.close();
    path_17.moveTo(size.width * 0.7993598, size.height * 0.2219545);
    path_17.lineTo(size.width * 0.8054390, size.height * 0.2214317);
    path_17.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_17.lineTo(size.width * 0.7993598, size.height * 0.2219545);
    path_17.close();
    path_17.moveTo(size.width * 0.5582720, size.height * 0.3865172);
    path_17.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_17.lineTo(size.width * 0.5582720, size.height * 0.3865172);
    path_17.close();
    path_17.moveTo(size.width * 0.3230152, size.height * 0.2299497);
    path_17.cubicTo(
        size.width * 0.3230152,
        size.height * 0.2274441,
        size.width * 0.3230994,
        size.height * 0.2249531,
        size.width * 0.3232652,
        size.height * 0.2224766);
    path_17.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_17.cubicTo(
        size.width * 0.3109159,
        size.height * 0.2242552,
        size.width * 0.3108201,
        size.height * 0.2270945,
        size.width * 0.3108201,
        size.height * 0.2299497);
    path_17.lineTo(size.width * 0.3230152, size.height * 0.2299497);
    path_17.close();
    path_17.moveTo(size.width * 0.5582720, size.height * 0.3912448);
    path_17.cubicTo(
        size.width * 0.4925677,
        size.height * 0.3912448,
        size.width * 0.4333756,
        size.height * 0.3726717,
        size.width * 0.3908073,
        size.height * 0.3430076);
    path_17.cubicTo(
        size.width * 0.3481415,
        size.height * 0.3132752,
        size.width * 0.3230152,
        size.height * 0.2731103,
        size.width * 0.3230152,
        size.height * 0.2299497);
    path_17.lineTo(size.width * 0.3108201, size.height * 0.2299497);
    path_17.cubicTo(
        size.width * 0.3108201,
        size.height * 0.2796786,
        size.width * 0.3397226,
        size.height * 0.3236097,
        size.width * 0.3844098,
        size.height * 0.3547503);
    path_17.cubicTo(
        size.width * 0.4291945,
        size.height * 0.3859593,
        size.width * 0.4906799,
        size.height * 0.4050379,
        size.width * 0.5582720,
        size.height * 0.4050379);
    path_17.lineTo(size.width * 0.5582720, size.height * 0.3912448);
    path_17.close();
    path_17.moveTo(size.width * 0.7935305, size.height * 0.2299497);
    path_17.cubicTo(
        size.width * 0.7935305,
        size.height * 0.2731103,
        size.width * 0.7684024,
        size.height * 0.3132752,
        size.width * 0.7257378,
        size.height * 0.3430076);
    path_17.cubicTo(
        size.width * 0.6831707,
        size.height * 0.3726717,
        size.width * 0.6239756,
        size.height * 0.3912448,
        size.width * 0.5582720,
        size.height * 0.3912448);
    path_17.lineTo(size.width * 0.5582720, size.height * 0.4050379);
    path_17.cubicTo(
        size.width * 0.6258659,
        size.height * 0.4050379,
        size.width * 0.6873476,
        size.height * 0.3859593,
        size.width * 0.7321341,
        size.height * 0.3547503);
    path_17.cubicTo(
        size.width * 0.7768232,
        size.height * 0.3236097,
        size.width * 0.8057256,
        size.height * 0.2796786,
        size.width * 0.8057256,
        size.height * 0.2299497);
    path_17.lineTo(size.width * 0.7935305, size.height * 0.2299497);
    path_17.close();
    path_17.moveTo(size.width * 0.7932805, size.height * 0.2224766);
    path_17.cubicTo(
        size.width * 0.7934451,
        size.height * 0.2249531,
        size.width * 0.7935305,
        size.height * 0.2274441,
        size.width * 0.7935305,
        size.height * 0.2299497);
    path_17.lineTo(size.width * 0.8057256, size.height * 0.2299497);
    path_17.cubicTo(
        size.width * 0.8057256,
        size.height * 0.2270952,
        size.width * 0.8056280,
        size.height * 0.2242552,
        size.width * 0.8054390,
        size.height * 0.2214317);
    path_17.lineTo(size.width * 0.7932805, size.height * 0.2224766);
    path_17.close();
    path_17.moveTo(size.width * 0.7932744, size.height * 0.2214455);
    path_17.cubicTo(
        size.width * 0.7904817,
        size.height * 0.2642455,
        size.width * 0.7642988,
        size.height * 0.3036821,
        size.width * 0.7219512,
        size.height * 0.3326897);
    path_17.cubicTo(
        size.width * 0.6796951,
        size.height * 0.3616386,
        size.width * 0.6220427,
        size.height * 0.3796207,
        size.width * 0.5582720,
        size.height * 0.3796207);
    path_17.lineTo(size.width * 0.5582720, size.height * 0.3934138);
    path_17.cubicTo(
        size.width * 0.6239512,
        size.height * 0.3934138,
        size.width * 0.6838476,
        size.height * 0.3749193,
        size.width * 0.7282744,
        size.height * 0.3444876);
    path_17.cubicTo(
        size.width * 0.7726098,
        size.height * 0.3141166,
        size.width * 0.8022500,
        size.height * 0.2712710,
        size.width * 0.8054390,
        size.height * 0.2224628);
    path_17.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_17.close();
    path_17.moveTo(size.width * 0.5582720, size.height * 0.3796207);
    path_17.cubicTo(
        size.width * 0.4944988,
        size.height * 0.3796207,
        size.width * 0.4368488,
        size.height * 0.3616386,
        size.width * 0.3945896,
        size.height * 0.3326897);
    path_17.cubicTo(
        size.width * 0.3522433,
        size.height * 0.3036821,
        size.width * 0.3260646,
        size.height * 0.2642455,
        size.width * 0.3232665,
        size.height * 0.2214455);
    path_17.lineTo(size.width * 0.3111043, size.height * 0.2224628);
    path_17.cubicTo(
        size.width * 0.3142951,
        size.height * 0.2712710,
        size.width * 0.3439348,
        size.height * 0.3141159,
        size.width * 0.3882720,
        size.height * 0.3444876);
    path_17.cubicTo(
        size.width * 0.4326957,
        size.height * 0.3749193,
        size.width * 0.4925951,
        size.height * 0.3934138,
        size.width * 0.5582720,
        size.height * 0.3934138);
    path_17.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.7796707, size.height * 0.1913793);
    path_18.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2300317,
        size.width * 0.7558537,
        size.height * 0.2656938,
        size.width * 0.7160671,
        size.height * 0.2918931);
    path_18.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3180400,
        size.width * 0.6212927,
        size.height * 0.3343283,
        size.width * 0.5602970,
        size.height * 0.3343283);
    path_18.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3343283,
        size.width * 0.4442335,
        size.height * 0.3180400,
        size.width * 0.4045250,
        size.height * 0.2918931);
    path_18.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2656938,
        size.width * 0.3409213,
        size.height * 0.2300317,
        size.width * 0.3409213,
        size.height * 0.1913793);
    path_18.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1527269,
        size.width * 0.3647378,
        size.height * 0.1170648,
        size.width * 0.4045250,
        size.height * 0.09086552);
    path_18.cubicTo(
        size.width * 0.4442335,
        size.height * 0.06471834,
        size.width * 0.4993000,
        size.height * 0.04843062,
        size.width * 0.5602970,
        size.height * 0.04843062);
    path_18.cubicTo(
        size.width * 0.6212927,
        size.height * 0.04843062,
        size.width * 0.6763598,
        size.height * 0.06471834,
        size.width * 0.7160671,
        size.height * 0.09086552);
    path_18.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1170648,
        size.width * 0.7796707,
        size.height * 0.1527269,
        size.width * 0.7796707,
        size.height * 0.1913793);
    path_18.close();

    Paint paint_18_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_18_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_stroke);

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 3

//Copy this CustomPainter code to the Bottom of the File
class WinPrizeClaimAsset3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6776366),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6714021),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2729986,
        size.width * 0.3100006,
        size.height * 0.2467310,
        size.width * 0.3226079,
        size.height * 0.2426034);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2080717);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1773372,
        size.width * 0.3263305,
        size.height * 0.1454572,
        size.width * 0.3437433,
        size.height * 0.1218614);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.05412041,
        size.width * 0.4950689,
        size.height * 0.02758621,
        size.width * 0.5575037,
        size.height * 0.02758621);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.02758621,
        size.width * 0.7592073,
        size.height * 0.08968069,
        size.width * 0.7860122,
        size.height * 0.1389848);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1593966,
        size.width * 0.7993659,
        size.height * 0.1838607,
        size.width * 0.7993659,
        size.height * 0.2078221);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2426034);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2741241,
        size.width * 0.8385183,
        size.height * 0.3180283,
        size.width * 0.8361951,
        size.height * 0.3360400);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6399910);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.6970276,
        size.width * 0.7394512,
        size.height * 0.8084000,
        size.width * 0.5475506,
        size.height * 0.7975931);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.7867862,
        size.width * 0.2890988,
        size.height * 0.6880228,
        size.width * 0.2798091,
        size.height * 0.6399910);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.5887262),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffBDAE87).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5768939, size.height * 0.5780490),
            width: size.width * 0.3446463,
            height: size.height * 0.2379876),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3687598, size.height * 0.5924648);
    path_5.lineTo(size.width * 0.3689591, size.height * 0.5924648);
    path_5.cubicTo(
        size.width * 0.3704841,
        size.height * 0.6118303,
        size.width * 0.3809341,
        size.height * 0.6305848,
        size.width * 0.3998354,
        size.height * 0.6449979);
    path_5.cubicTo(
        size.width * 0.4203299,
        size.height * 0.6606255,
        size.width * 0.4470683,
        size.height * 0.6683634,
        size.width * 0.4736927,
        size.height * 0.6683634);
    path_5.cubicTo(
        size.width * 0.5003171,
        size.height * 0.6683634,
        size.width * 0.5270555,
        size.height * 0.6606255,
        size.width * 0.5475500,
        size.height * 0.6449979);
    path_5.cubicTo(
        size.width * 0.5664512,
        size.height * 0.6305848,
        size.width * 0.5769012,
        size.height * 0.6118303,
        size.width * 0.5784262,
        size.height * 0.5924648);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5924648);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5898786);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5521324);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5495462);
    path_5.lineTo(size.width * 0.5764256, size.height * 0.5495462);
    path_5.lineTo(size.width * 0.5664116, size.height * 0.5495462);
    path_5.cubicTo(
        size.width * 0.5615482,
        size.height * 0.5424828,
        size.width * 0.5552518,
        size.height * 0.5358945,
        size.width * 0.5475500,
        size.height * 0.5300214);
    path_5.cubicTo(
        size.width * 0.5270555,
        size.height * 0.5143938,
        size.width * 0.5003171,
        size.height * 0.5066559,
        size.width * 0.4736927,
        size.height * 0.5066559);
    path_5.cubicTo(
        size.width * 0.4470683,
        size.height * 0.5066559,
        size.width * 0.4203299,
        size.height * 0.5143938,
        size.width * 0.3998354,
        size.height * 0.5300214);
    path_5.cubicTo(
        size.width * 0.3921335,
        size.height * 0.5358945,
        size.width * 0.3858372,
        size.height * 0.5424828,
        size.width * 0.3809738,
        size.height * 0.5495462);
    path_5.lineTo(size.width * 0.3710463, size.height * 0.5495462);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5495462);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5521324);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5898786);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5924648);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3998427, size.height * 0.6151821);
    path_6.cubicTo(
        size.width * 0.4203372,
        size.height * 0.6308097,
        size.width * 0.4470756,
        size.height * 0.6385483,
        size.width * 0.4737000,
        size.height * 0.6385483);
    path_6.cubicTo(
        size.width * 0.5003244,
        size.height * 0.6385483,
        size.width * 0.5270628,
        size.height * 0.6308097,
        size.width * 0.5475573,
        size.height * 0.6151821);
    path_6.cubicTo(
        size.width * 0.5680713,
        size.height * 0.5995393,
        size.width * 0.5786287,
        size.height * 0.5787800,
        size.width * 0.5786287,
        size.height * 0.5576945);
    path_6.cubicTo(
        size.width * 0.5786287,
        size.height * 0.5366083,
        size.width * 0.5680713,
        size.height * 0.5158490,
        size.width * 0.5475573,
        size.height * 0.5002062);
    path_6.cubicTo(
        size.width * 0.5270628,
        size.height * 0.4845786,
        size.width * 0.5003244,
        size.height * 0.4768400,
        size.width * 0.4737000,
        size.height * 0.4768400);
    path_6.cubicTo(
        size.width * 0.4470756,
        size.height * 0.4768400,
        size.width * 0.4203372,
        size.height * 0.4845786,
        size.width * 0.3998427,
        size.height * 0.5002062);
    path_6.cubicTo(
        size.width * 0.3793287,
        size.height * 0.5158490,
        size.width * 0.3687713,
        size.height * 0.5366083,
        size.width * 0.3687713,
        size.height * 0.5576945);
    path_6.cubicTo(
        size.width * 0.3687713,
        size.height * 0.5787800,
        size.width * 0.3793287,
        size.height * 0.5995393,
        size.width * 0.3998427,
        size.height * 0.6151821);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_6_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4229915, size.height * 0.5975290);
    path_7.cubicTo(
        size.width * 0.4370927,
        size.height * 0.6082821,
        size.width * 0.4554518,
        size.height * 0.6135828,
        size.width * 0.4736970,
        size.height * 0.6135828);
    path_7.cubicTo(
        size.width * 0.4919415,
        size.height * 0.6135828,
        size.width * 0.5103006,
        size.height * 0.6082821,
        size.width * 0.5244018,
        size.height * 0.5975290);
    path_7.cubicTo(
        size.width * 0.5385226,
        size.height * 0.5867614,
        size.width * 0.5458835,
        size.height * 0.5723917,
        size.width * 0.5458835,
        size.height * 0.5576952);
    path_7.cubicTo(
        size.width * 0.5458835,
        size.height * 0.5429993,
        size.width * 0.5385226,
        size.height * 0.5286290,
        size.width * 0.5244018,
        size.height * 0.5178614);
    path_7.cubicTo(
        size.width * 0.5103006,
        size.height * 0.5071090,
        size.width * 0.4919415,
        size.height * 0.5018083,
        size.width * 0.4736970,
        size.height * 0.5018083);
    path_7.cubicTo(
        size.width * 0.4554518,
        size.height * 0.5018083,
        size.width * 0.4370927,
        size.height * 0.5071090,
        size.width * 0.4229915,
        size.height * 0.5178614);
    path_7.cubicTo(
        size.width * 0.4088707,
        size.height * 0.5286290,
        size.width * 0.4015104,
        size.height * 0.5429993,
        size.width * 0.4015104,
        size.height * 0.5576952);
    path_7.cubicTo(
        size.width * 0.4015104,
        size.height * 0.5723917,
        size.width * 0.4088707,
        size.height * 0.5867614,
        size.width * 0.4229915,
        size.height * 0.5975290);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_7_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.5066159, size.height * 0.5106593);
    path_8.cubicTo(
        size.width * 0.4812817,
        size.height * 0.5026703,
        size.width * 0.4510360,
        size.height * 0.5065269,
        size.width * 0.4304433,
        size.height * 0.5222297);
    path_8.cubicTo(
        size.width * 0.4031457,
        size.height * 0.5430448,
        size.width * 0.4031457,
        size.height * 0.5767931,
        size.width * 0.4304433,
        size.height * 0.5976090);
    path_8.cubicTo(
        size.width * 0.4354457,
        size.height * 0.6014234,
        size.width * 0.4410177,
        size.height * 0.6045386,
        size.width * 0.4469506,
        size.height * 0.6069552);
    path_8.cubicTo(
        size.width * 0.4387024,
        size.height * 0.6043538,
        size.width * 0.4309744,
        size.height * 0.6004972,
        size.width * 0.4242701,
        size.height * 0.5953848);
    path_8.cubicTo(
        size.width * 0.3969726,
        size.height * 0.5745697,
        size.width * 0.3969726,
        size.height * 0.5408214,
        size.width * 0.4242701,
        size.height * 0.5200062);
    path_8.cubicTo(
        size.width * 0.4465652,
        size.height * 0.5030055,
        size.width * 0.4801744,
        size.height * 0.4998897,
        size.width * 0.5066159,
        size.height * 0.5106593);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.5526598, size.height * 0.5388007);
    path_9.cubicTo(
        size.width * 0.5541854,
        size.height * 0.5581662,
        size.width * 0.5646354,
        size.height * 0.5769214,
        size.width * 0.5835366,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.6040311,
        size.height * 0.6069614,
        size.width * 0.6307683,
        size.height * 0.6147000,
        size.width * 0.6573963,
        size.height * 0.6147000);
    path_9.cubicTo(
        size.width * 0.6840183,
        size.height * 0.6147000,
        size.width * 0.7107561,
        size.height * 0.6069614,
        size.width * 0.7312500,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.7501524,
        size.height * 0.5769214,
        size.width * 0.7606037,
        size.height * 0.5581662,
        size.width * 0.7621280,
        size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7601280, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7501098, size.height * 0.4958828);
    path_9.cubicTo(
        size.width * 0.7452500,
        size.height * 0.4888193,
        size.width * 0.7389512,
        size.height * 0.4822310,
        size.width * 0.7312500,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.7107561,
        size.height * 0.4607303,
        size.width * 0.6840183,
        size.height * 0.4529917,
        size.width * 0.6573963,
        size.height * 0.4529917);
    path_9.cubicTo(
        size.width * 0.6307683,
        size.height * 0.4529917,
        size.width * 0.6040311,
        size.height * 0.4607303,
        size.width * 0.5835366,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.5758348,
        size.height * 0.4822310,
        size.width * 0.5695384,
        size.height * 0.4888193,
        size.width * 0.5646744,
        size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5547470, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5835439, size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.6040384,
        size.height * 0.5771476,
        size.width * 0.6307744,
        size.height * 0.5848862,
        size.width * 0.6574024,
        size.height * 0.5848862);
    path_10.cubicTo(
        size.width * 0.6840244,
        size.height * 0.5848862,
        size.width * 0.7107622,
        size.height * 0.5771476,
        size.width * 0.7312561,
        size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.7517744,
        size.height * 0.5458772,
        size.width * 0.7623293,
        size.height * 0.5251179,
        size.width * 0.7623293,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.7623293,
        size.height * 0.4829462,
        size.width * 0.7517744,
        size.height * 0.4621869,
        size.width * 0.7312561,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.7107622,
        size.height * 0.4309166,
        size.width * 0.6840244,
        size.height * 0.4231779,
        size.width * 0.6574024,
        size.height * 0.4231779);
    path_10.cubicTo(
        size.width * 0.6307744,
        size.height * 0.4231779,
        size.width * 0.6040384,
        size.height * 0.4309166,
        size.width * 0.5835439,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.5630299,
        size.height * 0.4621869,
        size.width * 0.5524726,
        size.height * 0.4829462,
        size.width * 0.5524726,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.5524726,
        size.height * 0.5251179,
        size.width * 0.5630299,
        size.height * 0.5458772,
        size.width * 0.5835439,
        size.height * 0.5615200);
    path_10.close();

    Paint paint_10_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_10_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_stroke);

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.6066927, size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.6207927,
        size.height * 0.5546179,
        size.width * 0.6391524,
        size.height * 0.5599186,
        size.width * 0.6573963,
        size.height * 0.5599186);
    path_11.cubicTo(
        size.width * 0.6756402,
        size.height * 0.5599186,
        size.width * 0.6940000,
        size.height * 0.5546179,
        size.width * 0.7081037,
        size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.7222256,
        size.height * 0.5330979,
        size.width * 0.7295854,
        size.height * 0.5187283,
        size.width * 0.7295854,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.7295854,
        size.height * 0.4893352,
        size.width * 0.7222256,
        size.height * 0.4749655,
        size.width * 0.7081037,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.6940000,
        size.height * 0.4534455,
        size.width * 0.6756402,
        size.height * 0.4481448,
        size.width * 0.6573963,
        size.height * 0.4481448);
    path_11.cubicTo(
        size.width * 0.6391524,
        size.height * 0.4481448,
        size.width * 0.6207927,
        size.height * 0.4534455,
        size.width * 0.6066927,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.5925720,
        size.height * 0.4749655,
        size.width * 0.5852110,
        size.height * 0.4893352,
        size.width * 0.5852110,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.5852110,
        size.height * 0.5187283,
        size.width * 0.5925720,
        size.height * 0.5330979,
        size.width * 0.6066927,
        size.height * 0.5438655);
    path_11.close();

    Paint paint_11_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_11_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_stroke);

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.6903171, size.height * 0.4569959);
    path_12.cubicTo(
        size.width * 0.6649817,
        size.height * 0.4490062,
        size.width * 0.6347378,
        size.height * 0.4528634,
        size.width * 0.6141463,
        size.height * 0.4685662);
    path_12.cubicTo(
        size.width * 0.5868463,
        size.height * 0.4893814,
        size.width * 0.5868463,
        size.height * 0.5231297,
        size.width * 0.6141463,
        size.height * 0.5439448);
    path_12.cubicTo(
        size.width * 0.6191463,
        size.height * 0.5477593,
        size.width * 0.6247195,
        size.height * 0.5508752,
        size.width * 0.6306524,
        size.height * 0.5532917);
    path_12.cubicTo(
        size.width * 0.6224024,
        size.height * 0.5506903,
        size.width * 0.6146768,
        size.height * 0.5468338,
        size.width * 0.6079707,
        size.height * 0.5417214);
    path_12.cubicTo(
        size.width * 0.5806732,
        size.height * 0.5209055,
        size.width * 0.5806732,
        size.height * 0.4871572,
        size.width * 0.6079707,
        size.height * 0.4663421);
    path_12.cubicTo(
        size.width * 0.6302683,
        size.height * 0.4493414,
        size.width * 0.6638780,
        size.height * 0.4462262,
        size.width * 0.6903171,
        size.height * 0.4569959);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.3841341, size.height * 0.5519172);
    path_13.lineTo(size.width * 0.3843293, size.height * 0.5519172);
    path_13.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5712572,
        size.width * 0.3960012,
        size.height * 0.5900103,
        size.width * 0.4144537,
        size.height * 0.6044331);
    path_13.cubicTo(
        size.width * 0.4344610,
        size.height * 0.6200717,
        size.width * 0.4605652,
        size.height * 0.6278159,
        size.width * 0.4865591,
        size.height * 0.6278159);
    path_13.cubicTo(
        size.width * 0.5125524,
        size.height * 0.6278159,
        size.width * 0.5386567,
        size.height * 0.6200717,
        size.width * 0.5586640,
        size.height * 0.6044331);
    path_13.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5900103,
        size.width * 0.5873012,
        size.height * 0.5712572,
        size.width * 0.5887884,
        size.height * 0.5519172);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5519172);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5493310);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5115848);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.5867817, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.5770561, size.height * 0.5089986);
    path_13.cubicTo(
        size.width * 0.5723134,
        size.height * 0.5019441,
        size.width * 0.5661738,
        size.height * 0.4953607,
        size.width * 0.5586640,
        size.height * 0.4894910);
    path_13.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4738524,
        size.width * 0.5125524,
        size.height * 0.4661083,
        size.width * 0.4865591,
        size.height * 0.4661083);
    path_13.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4661083,
        size.width * 0.4344610,
        size.height * 0.4738524,
        size.width * 0.4144537,
        size.height * 0.4894910);
    path_13.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4953607,
        size.width * 0.4008049,
        size.height * 0.5019441,
        size.width * 0.3960616,
        size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3864207, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5115848);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5493310);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5519172);
    path_13.close();

    Paint paint_13_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_13_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_stroke);

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.4144494, size.height * 0.5746214);
    path_14.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5902593,
        size.width * 0.4605610,
        size.height * 0.5980041,
        size.width * 0.4865543,
        size.height * 0.5980041);
    path_14.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5980041,
        size.width * 0.5386524,
        size.height * 0.5902593,
        size.width * 0.5586598,
        size.height * 0.5746214);
    path_14.cubicTo(
        size.width * 0.5786890,
        size.height * 0.5589655,
        size.width * 0.5889744,
        size.height * 0.5382069,
        size.width * 0.5889744,
        size.height * 0.5171503);
    path_14.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4960931,
        size.width * 0.5786890,
        size.height * 0.4753345,
        size.width * 0.5586598,
        size.height * 0.4596786);
    path_14.cubicTo(
        size.width * 0.5386524,
        size.height * 0.4440407,
        size.width * 0.5125482,
        size.height * 0.4362959,
        size.width * 0.4865543,
        size.height * 0.4362959);
    path_14.cubicTo(
        size.width * 0.4605610,
        size.height * 0.4362959,
        size.width * 0.4344567,
        size.height * 0.4440407,
        size.width * 0.4144494,
        size.height * 0.4596786);
    path_14.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4753345,
        size.width * 0.3841341,
        size.height * 0.4960931,
        size.width * 0.3841341,
        size.height * 0.5171503);
    path_14.cubicTo(
        size.width * 0.3841341,
        size.height * 0.5382069,
        size.width * 0.3944201,
        size.height * 0.5589655,
        size.width * 0.4144494,
        size.height * 0.5746214);
    path_14.close();

    Paint paint_14_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_14_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_stroke);

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.4370348, size.height * 0.5569669);
    path_15.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5677297,
        size.width * 0.4687348,
        size.height * 0.5730366,
        size.width * 0.4865537,
        size.height * 0.5730366);
    path_15.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5730366,
        size.width * 0.5223018,
        size.height * 0.5677297,
        size.width * 0.5360720,
        size.height * 0.5569662);
    path_15.cubicTo(
        size.width * 0.5498646,
        size.height * 0.5461862,
        size.width * 0.5570317,
        size.height * 0.5318166,
        size.width * 0.5570317,
        size.height * 0.5171497);
    path_15.cubicTo(
        size.width * 0.5570317,
        size.height * 0.5024821,
        size.width * 0.5498646,
        size.height * 0.4881131,
        size.width * 0.5360720,
        size.height * 0.4773324);
    path_15.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4665690,
        size.width * 0.5043726,
        size.height * 0.4612628,
        size.width * 0.4865537,
        size.height * 0.4612628);
    path_15.cubicTo(
        size.width * 0.4687348,
        size.height * 0.4612628,
        size.width * 0.4508049,
        size.height * 0.4665690,
        size.width * 0.4370348,
        size.height * 0.4773324);
    path_15.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4881131,
        size.width * 0.4160750,
        size.height * 0.5024821,
        size.width * 0.4160750,
        size.height * 0.5171497);
    path_15.cubicTo(
        size.width * 0.4160750,
        size.height * 0.5318166,
        size.width * 0.4232427,
        size.height * 0.5461862,
        size.width * 0.4370348,
        size.height * 0.5569669);
    path_15.close();

    Paint paint_15_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_15_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_stroke);

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.5186683, size.height * 0.4701138);
    path_16.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4621241,
        size.width * 0.4644470,
        size.height * 0.4659814,
        size.width * 0.4443573,
        size.height * 0.4816841);
    path_16.cubicTo(
        size.width * 0.4177262,
        size.height * 0.5024993,
        size.width * 0.4177262,
        size.height * 0.5362476,
        size.width * 0.4443573,
        size.height * 0.5570628);
    path_16.cubicTo(
        size.width * 0.4492372,
        size.height * 0.5608772,
        size.width * 0.4546732,
        size.height * 0.5639931,
        size.width * 0.4604610,
        size.height * 0.5664097);
    path_16.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5638083,
        size.width * 0.4448756,
        size.height * 0.5599517,
        size.width * 0.4383348,
        size.height * 0.5548393);
    path_16.cubicTo(
        size.width * 0.4117043,
        size.height * 0.5340234,
        size.width * 0.4117043,
        size.height * 0.5002752,
        size.width * 0.4383348,
        size.height * 0.4794600);
    path_16.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4624593,
        size.width * 0.4928726,
        size.height * 0.4593441,
        size.width * 0.5186683,
        size.height * 0.4701138);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.7744024, size.height * 0.2241372);
    path_17.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2138345,
        size.width * 0.7798110,
        size.height * 0.2031117,
        size.width * 0.7798110,
        size.height * 0.1921007);
    path_17.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1124841,
        size.width * 0.6821220,
        size.height * 0.04794248,
        size.width * 0.5616250,
        size.height * 0.04794248);
    path_17.cubicTo(
        size.width * 0.4411250,
        size.height * 0.04794248,
        size.width * 0.3434402,
        size.height * 0.1124841,
        size.width * 0.3434402,
        size.height * 0.1921007);
    path_17.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2031110,
        size.width * 0.3453085,
        size.height * 0.2138331,
        size.width * 0.3488470,
        size.height * 0.2241359);
    path_17.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1599379,
        size.width * 0.4577890,
        size.height * 0.1120138,
        size.width * 0.5616244,
        size.height * 0.1120138);
    path_17.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1120138,
        size.width * 0.7523537,
        size.height * 0.1599393,
        size.width * 0.7744024,
        size.height * 0.2241372);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.3293390, size.height * 0.2071000);
    path_18.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2182041,
        size.width * 0.3235116,
        size.height * 0.2297593,
        size.width * 0.3235116,
        size.height * 0.2416255);
    path_18.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3274269,
        size.width * 0.4287841,
        size.height * 0.3969828,
        size.width * 0.5586451,
        size.height * 0.3969828);
    path_18.cubicTo(
        size.width * 0.6885061,
        size.height * 0.3969828,
        size.width * 0.7937805,
        size.height * 0.3274269,
        size.width * 0.7937805,
        size.height * 0.2416255);
    path_18.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2297600,
        size.width * 0.7917683,
        size.height * 0.2182055,
        size.width * 0.7879512,
        size.height * 0.2071021);
    path_18.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2762869,
        size.width * 0.6705488,
        size.height * 0.3279338,
        size.width * 0.5586457,
        size.height * 0.3279338);
    path_18.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3279338,
        size.width * 0.3530988,
        size.height * 0.2762855,
        size.width * 0.3293390,
        size.height * 0.2071000);
    path_18.close();

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_19.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_19.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_19.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_19.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_19.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_19.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_19.close();

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_20.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_20.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_20.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_20.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_20.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_20.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_21.lineTo(size.width * 0.3232665, size.height * 0.2214455);
    path_21.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_21.lineTo(size.width * 0.3171854, size.height * 0.2219545);
    path_21.close();
    path_21.moveTo(size.width * 0.7993598, size.height * 0.2219545);
    path_21.lineTo(size.width * 0.8054390, size.height * 0.2214317);
    path_21.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_21.lineTo(size.width * 0.7993598, size.height * 0.2219545);
    path_21.close();
    path_21.moveTo(size.width * 0.5582720, size.height * 0.3865172);
    path_21.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_21.lineTo(size.width * 0.5582720, size.height * 0.3865172);
    path_21.close();
    path_21.moveTo(size.width * 0.3230152, size.height * 0.2299497);
    path_21.cubicTo(
        size.width * 0.3230152,
        size.height * 0.2274441,
        size.width * 0.3230994,
        size.height * 0.2249531,
        size.width * 0.3232652,
        size.height * 0.2224766);
    path_21.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_21.cubicTo(
        size.width * 0.3109159,
        size.height * 0.2242552,
        size.width * 0.3108201,
        size.height * 0.2270945,
        size.width * 0.3108201,
        size.height * 0.2299497);
    path_21.lineTo(size.width * 0.3230152, size.height * 0.2299497);
    path_21.close();
    path_21.moveTo(size.width * 0.5582720, size.height * 0.3912448);
    path_21.cubicTo(
        size.width * 0.4925677,
        size.height * 0.3912448,
        size.width * 0.4333756,
        size.height * 0.3726717,
        size.width * 0.3908073,
        size.height * 0.3430076);
    path_21.cubicTo(
        size.width * 0.3481415,
        size.height * 0.3132752,
        size.width * 0.3230152,
        size.height * 0.2731103,
        size.width * 0.3230152,
        size.height * 0.2299497);
    path_21.lineTo(size.width * 0.3108201, size.height * 0.2299497);
    path_21.cubicTo(
        size.width * 0.3108201,
        size.height * 0.2796786,
        size.width * 0.3397226,
        size.height * 0.3236097,
        size.width * 0.3844098,
        size.height * 0.3547503);
    path_21.cubicTo(
        size.width * 0.4291945,
        size.height * 0.3859593,
        size.width * 0.4906799,
        size.height * 0.4050379,
        size.width * 0.5582720,
        size.height * 0.4050379);
    path_21.lineTo(size.width * 0.5582720, size.height * 0.3912448);
    path_21.close();
    path_21.moveTo(size.width * 0.7935305, size.height * 0.2299497);
    path_21.cubicTo(
        size.width * 0.7935305,
        size.height * 0.2731103,
        size.width * 0.7684024,
        size.height * 0.3132752,
        size.width * 0.7257378,
        size.height * 0.3430076);
    path_21.cubicTo(
        size.width * 0.6831707,
        size.height * 0.3726717,
        size.width * 0.6239756,
        size.height * 0.3912448,
        size.width * 0.5582720,
        size.height * 0.3912448);
    path_21.lineTo(size.width * 0.5582720, size.height * 0.4050379);
    path_21.cubicTo(
        size.width * 0.6258659,
        size.height * 0.4050379,
        size.width * 0.6873476,
        size.height * 0.3859593,
        size.width * 0.7321341,
        size.height * 0.3547503);
    path_21.cubicTo(
        size.width * 0.7768232,
        size.height * 0.3236097,
        size.width * 0.8057256,
        size.height * 0.2796786,
        size.width * 0.8057256,
        size.height * 0.2299497);
    path_21.lineTo(size.width * 0.7935305, size.height * 0.2299497);
    path_21.close();
    path_21.moveTo(size.width * 0.7932805, size.height * 0.2224766);
    path_21.cubicTo(
        size.width * 0.7934451,
        size.height * 0.2249531,
        size.width * 0.7935305,
        size.height * 0.2274441,
        size.width * 0.7935305,
        size.height * 0.2299497);
    path_21.lineTo(size.width * 0.8057256, size.height * 0.2299497);
    path_21.cubicTo(
        size.width * 0.8057256,
        size.height * 0.2270952,
        size.width * 0.8056280,
        size.height * 0.2242552,
        size.width * 0.8054390,
        size.height * 0.2214317);
    path_21.lineTo(size.width * 0.7932805, size.height * 0.2224766);
    path_21.close();
    path_21.moveTo(size.width * 0.7932744, size.height * 0.2214455);
    path_21.cubicTo(
        size.width * 0.7904817,
        size.height * 0.2642455,
        size.width * 0.7642988,
        size.height * 0.3036821,
        size.width * 0.7219512,
        size.height * 0.3326897);
    path_21.cubicTo(
        size.width * 0.6796951,
        size.height * 0.3616386,
        size.width * 0.6220427,
        size.height * 0.3796207,
        size.width * 0.5582720,
        size.height * 0.3796207);
    path_21.lineTo(size.width * 0.5582720, size.height * 0.3934138);
    path_21.cubicTo(
        size.width * 0.6239512,
        size.height * 0.3934138,
        size.width * 0.6838476,
        size.height * 0.3749193,
        size.width * 0.7282744,
        size.height * 0.3444876);
    path_21.cubicTo(
        size.width * 0.7726098,
        size.height * 0.3141166,
        size.width * 0.8022500,
        size.height * 0.2712710,
        size.width * 0.8054390,
        size.height * 0.2224628);
    path_21.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_21.close();
    path_21.moveTo(size.width * 0.5582720, size.height * 0.3796207);
    path_21.cubicTo(
        size.width * 0.4944988,
        size.height * 0.3796207,
        size.width * 0.4368488,
        size.height * 0.3616386,
        size.width * 0.3945896,
        size.height * 0.3326897);
    path_21.cubicTo(
        size.width * 0.3522433,
        size.height * 0.3036821,
        size.width * 0.3260646,
        size.height * 0.2642455,
        size.width * 0.3232665,
        size.height * 0.2214455);
    path_21.lineTo(size.width * 0.3111043, size.height * 0.2224628);
    path_21.cubicTo(
        size.width * 0.3142951,
        size.height * 0.2712710,
        size.width * 0.3439348,
        size.height * 0.3141159,
        size.width * 0.3882720,
        size.height * 0.3444876);
    path_21.cubicTo(
        size.width * 0.4326957,
        size.height * 0.3749193,
        size.width * 0.4925951,
        size.height * 0.3934138,
        size.width * 0.5582720,
        size.height * 0.3934138);
    path_21.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_21.close();

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.7796707, size.height * 0.1913793);
    path_22.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2300317,
        size.width * 0.7558537,
        size.height * 0.2656938,
        size.width * 0.7160671,
        size.height * 0.2918931);
    path_22.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3180400,
        size.width * 0.6212927,
        size.height * 0.3343283,
        size.width * 0.5602970,
        size.height * 0.3343283);
    path_22.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3343283,
        size.width * 0.4442335,
        size.height * 0.3180400,
        size.width * 0.4045250,
        size.height * 0.2918931);
    path_22.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2656938,
        size.width * 0.3409213,
        size.height * 0.2300317,
        size.width * 0.3409213,
        size.height * 0.1913793);
    path_22.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1527269,
        size.width * 0.3647378,
        size.height * 0.1170648,
        size.width * 0.4045250,
        size.height * 0.09086552);
    path_22.cubicTo(
        size.width * 0.4442335,
        size.height * 0.06471834,
        size.width * 0.4993000,
        size.height * 0.04843062,
        size.width * 0.5602970,
        size.height * 0.04843062);
    path_22.cubicTo(
        size.width * 0.6212927,
        size.height * 0.04843062,
        size.width * 0.6763598,
        size.height * 0.06471834,
        size.width * 0.7160671,
        size.height * 0.09086552);
    path_22.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1170648,
        size.width * 0.7796707,
        size.height * 0.1527269,
        size.width * 0.7796707,
        size.height * 0.1913793);
    path_22.close();

    Paint paint_22_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_22_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_stroke);

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 4
class WinPrizeClaimAsset4 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6776366),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6714021),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2729986,
        size.width * 0.3100006,
        size.height * 0.2467310,
        size.width * 0.3226079,
        size.height * 0.2426034);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2080717);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1773372,
        size.width * 0.3263305,
        size.height * 0.1454572,
        size.width * 0.3437433,
        size.height * 0.1218614);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.05412041,
        size.width * 0.4950689,
        size.height * 0.02758621,
        size.width * 0.5575037,
        size.height * 0.02758621);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.02758621,
        size.width * 0.7592073,
        size.height * 0.08968069,
        size.width * 0.7860122,
        size.height * 0.1389848);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1593966,
        size.width * 0.7993659,
        size.height * 0.1838607,
        size.width * 0.7993659,
        size.height * 0.2078221);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2426034);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2741241,
        size.width * 0.8385183,
        size.height * 0.3180283,
        size.width * 0.8361951,
        size.height * 0.3360400);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6399910);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.6970276,
        size.width * 0.7394512,
        size.height * 0.8084000,
        size.width * 0.5475506,
        size.height * 0.7975931);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.7867862,
        size.width * 0.2890988,
        size.height * 0.6880228,
        size.width * 0.2798091,
        size.height * 0.6399910);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.5887262),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5768939, size.height * 0.5780490),
            width: size.width * 0.3446463,
            height: size.height * 0.2379876),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3687598, size.height * 0.5924614);
    path_5.lineTo(size.width * 0.3689591, size.height * 0.5924614);
    path_5.cubicTo(
        size.width * 0.3704841,
        size.height * 0.6118269,
        size.width * 0.3809341,
        size.height * 0.6305814,
        size.width * 0.3998354,
        size.height * 0.6449945);
    path_5.cubicTo(
        size.width * 0.4203299,
        size.height * 0.6606221,
        size.width * 0.4470683,
        size.height * 0.6683600,
        size.width * 0.4736927,
        size.height * 0.6683600);
    path_5.cubicTo(
        size.width * 0.5003171,
        size.height * 0.6683600,
        size.width * 0.5270555,
        size.height * 0.6606221,
        size.width * 0.5475500,
        size.height * 0.6449945);
    path_5.cubicTo(
        size.width * 0.5664512,
        size.height * 0.6305814,
        size.width * 0.5769012,
        size.height * 0.6118269,
        size.width * 0.5784262,
        size.height * 0.5924614);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5924614);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5898752);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5521290);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.5764256, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.5664116, size.height * 0.5495428);
    path_5.cubicTo(
        size.width * 0.5615482,
        size.height * 0.5424800,
        size.width * 0.5552518,
        size.height * 0.5358910,
        size.width * 0.5475500,
        size.height * 0.5300186);
    path_5.cubicTo(
        size.width * 0.5270555,
        size.height * 0.5143903,
        size.width * 0.5003171,
        size.height * 0.5066524,
        size.width * 0.4736927,
        size.height * 0.5066524);
    path_5.cubicTo(
        size.width * 0.4470683,
        size.height * 0.5066524,
        size.width * 0.4203299,
        size.height * 0.5143903,
        size.width * 0.3998354,
        size.height * 0.5300186);
    path_5.cubicTo(
        size.width * 0.3921335,
        size.height * 0.5358910,
        size.width * 0.3858372,
        size.height * 0.5424800,
        size.width * 0.3809738,
        size.height * 0.5495428);
    path_5.lineTo(size.width * 0.3710463, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5521290);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5898752);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5924614);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3998427, size.height * 0.6151786);
    path_6.cubicTo(
        size.width * 0.4203372,
        size.height * 0.6308062,
        size.width * 0.4470756,
        size.height * 0.6385448,
        size.width * 0.4737000,
        size.height * 0.6385448);
    path_6.cubicTo(
        size.width * 0.5003244,
        size.height * 0.6385448,
        size.width * 0.5270628,
        size.height * 0.6308062,
        size.width * 0.5475573,
        size.height * 0.6151786);
    path_6.cubicTo(
        size.width * 0.5680713,
        size.height * 0.5995359,
        size.width * 0.5786287,
        size.height * 0.5787766,
        size.width * 0.5786287,
        size.height * 0.5576910);
    path_6.cubicTo(
        size.width * 0.5786287,
        size.height * 0.5366048,
        size.width * 0.5680713,
        size.height * 0.5158455,
        size.width * 0.5475573,
        size.height * 0.5002028);
    path_6.cubicTo(
        size.width * 0.5270628,
        size.height * 0.4845752,
        size.width * 0.5003244,
        size.height * 0.4768372,
        size.width * 0.4737000,
        size.height * 0.4768372);
    path_6.cubicTo(
        size.width * 0.4470756,
        size.height * 0.4768372,
        size.width * 0.4203372,
        size.height * 0.4845752,
        size.width * 0.3998427,
        size.height * 0.5002028);
    path_6.cubicTo(
        size.width * 0.3793287,
        size.height * 0.5158455,
        size.width * 0.3687713,
        size.height * 0.5366048,
        size.width * 0.3687713,
        size.height * 0.5576910);
    path_6.cubicTo(
        size.width * 0.3687713,
        size.height * 0.5787766,
        size.width * 0.3793287,
        size.height * 0.5995359,
        size.width * 0.3998427,
        size.height * 0.6151786);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_6_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4229915, size.height * 0.5975255);
    path_7.cubicTo(
        size.width * 0.4370927,
        size.height * 0.6082786,
        size.width * 0.4554518,
        size.height * 0.6135793,
        size.width * 0.4736970,
        size.height * 0.6135793);
    path_7.cubicTo(
        size.width * 0.4919415,
        size.height * 0.6135793,
        size.width * 0.5103006,
        size.height * 0.6082786,
        size.width * 0.5244018,
        size.height * 0.5975255);
    path_7.cubicTo(
        size.width * 0.5385226,
        size.height * 0.5867579,
        size.width * 0.5458835,
        size.height * 0.5723883,
        size.width * 0.5458835,
        size.height * 0.5576917);
    path_7.cubicTo(
        size.width * 0.5458835,
        size.height * 0.5429959,
        size.width * 0.5385226,
        size.height * 0.5286262,
        size.width * 0.5244018,
        size.height * 0.5178579);
    path_7.cubicTo(
        size.width * 0.5103006,
        size.height * 0.5071055,
        size.width * 0.4919415,
        size.height * 0.5018048,
        size.width * 0.4736970,
        size.height * 0.5018048);
    path_7.cubicTo(
        size.width * 0.4554518,
        size.height * 0.5018048,
        size.width * 0.4370927,
        size.height * 0.5071055,
        size.width * 0.4229915,
        size.height * 0.5178579);
    path_7.cubicTo(
        size.width * 0.4088707,
        size.height * 0.5286262,
        size.width * 0.4015104,
        size.height * 0.5429959,
        size.width * 0.4015104,
        size.height * 0.5576917);
    path_7.cubicTo(
        size.width * 0.4015104,
        size.height * 0.5723883,
        size.width * 0.4088707,
        size.height * 0.5867579,
        size.width * 0.4229915,
        size.height * 0.5975255);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_7_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.5066159, size.height * 0.5106559);
    path_8.cubicTo(
        size.width * 0.4812817,
        size.height * 0.5026669,
        size.width * 0.4510360,
        size.height * 0.5065234,
        size.width * 0.4304433,
        size.height * 0.5222262);
    path_8.cubicTo(
        size.width * 0.4031457,
        size.height * 0.5430421,
        size.width * 0.4031457,
        size.height * 0.5767903,
        size.width * 0.4304433,
        size.height * 0.5976055);
    path_8.cubicTo(
        size.width * 0.4354457,
        size.height * 0.6014200,
        size.width * 0.4410177,
        size.height * 0.6045352,
        size.width * 0.4469506,
        size.height * 0.6069517);
    path_8.cubicTo(
        size.width * 0.4387024,
        size.height * 0.6043510,
        size.width * 0.4309744,
        size.height * 0.6004938,
        size.width * 0.4242701,
        size.height * 0.5953814);
    path_8.cubicTo(
        size.width * 0.3969726,
        size.height * 0.5745662,
        size.width * 0.3969726,
        size.height * 0.5408179,
        size.width * 0.4242701,
        size.height * 0.5200028);
    path_8.cubicTo(
        size.width * 0.4465652,
        size.height * 0.5030021,
        size.width * 0.4801744,
        size.height * 0.4998862,
        size.width * 0.5066159,
        size.height * 0.5106559);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.5526598, size.height * 0.5388007);
    path_9.cubicTo(
        size.width * 0.5541854,
        size.height * 0.5581662,
        size.width * 0.5646354,
        size.height * 0.5769214,
        size.width * 0.5835366,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.6040311,
        size.height * 0.6069614,
        size.width * 0.6307683,
        size.height * 0.6147000,
        size.width * 0.6573963,
        size.height * 0.6147000);
    path_9.cubicTo(
        size.width * 0.6840183,
        size.height * 0.6147000,
        size.width * 0.7107561,
        size.height * 0.6069614,
        size.width * 0.7312500,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.7501524,
        size.height * 0.5769214,
        size.width * 0.7606037,
        size.height * 0.5581662,
        size.width * 0.7621280,
        size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7601280, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7501098, size.height * 0.4958828);
    path_9.cubicTo(
        size.width * 0.7452500,
        size.height * 0.4888193,
        size.width * 0.7389512,
        size.height * 0.4822310,
        size.width * 0.7312500,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.7107561,
        size.height * 0.4607303,
        size.width * 0.6840183,
        size.height * 0.4529917,
        size.width * 0.6573963,
        size.height * 0.4529917);
    path_9.cubicTo(
        size.width * 0.6307683,
        size.height * 0.4529917,
        size.width * 0.6040311,
        size.height * 0.4607303,
        size.width * 0.5835366,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.5758348,
        size.height * 0.4822310,
        size.width * 0.5695384,
        size.height * 0.4888193,
        size.width * 0.5646744,
        size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5547470, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5835439, size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.6040384,
        size.height * 0.5771476,
        size.width * 0.6307744,
        size.height * 0.5848862,
        size.width * 0.6574024,
        size.height * 0.5848862);
    path_10.cubicTo(
        size.width * 0.6840244,
        size.height * 0.5848862,
        size.width * 0.7107622,
        size.height * 0.5771476,
        size.width * 0.7312561,
        size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.7517744,
        size.height * 0.5458772,
        size.width * 0.7623293,
        size.height * 0.5251179,
        size.width * 0.7623293,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.7623293,
        size.height * 0.4829462,
        size.width * 0.7517744,
        size.height * 0.4621869,
        size.width * 0.7312561,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.7107622,
        size.height * 0.4309166,
        size.width * 0.6840244,
        size.height * 0.4231779,
        size.width * 0.6574024,
        size.height * 0.4231779);
    path_10.cubicTo(
        size.width * 0.6307744,
        size.height * 0.4231779,
        size.width * 0.6040384,
        size.height * 0.4309166,
        size.width * 0.5835439,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.5630299,
        size.height * 0.4621869,
        size.width * 0.5524726,
        size.height * 0.4829462,
        size.width * 0.5524726,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.5524726,
        size.height * 0.5251179,
        size.width * 0.5630299,
        size.height * 0.5458772,
        size.width * 0.5835439,
        size.height * 0.5615200);
    path_10.close();

    Paint paint_10_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_10_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_stroke);

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.6066927, size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.6207927,
        size.height * 0.5546179,
        size.width * 0.6391524,
        size.height * 0.5599186,
        size.width * 0.6573963,
        size.height * 0.5599186);
    path_11.cubicTo(
        size.width * 0.6756402,
        size.height * 0.5599186,
        size.width * 0.6940000,
        size.height * 0.5546179,
        size.width * 0.7081037,
        size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.7222256,
        size.height * 0.5330979,
        size.width * 0.7295854,
        size.height * 0.5187283,
        size.width * 0.7295854,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.7295854,
        size.height * 0.4893352,
        size.width * 0.7222256,
        size.height * 0.4749655,
        size.width * 0.7081037,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.6940000,
        size.height * 0.4534455,
        size.width * 0.6756402,
        size.height * 0.4481448,
        size.width * 0.6573963,
        size.height * 0.4481448);
    path_11.cubicTo(
        size.width * 0.6391524,
        size.height * 0.4481448,
        size.width * 0.6207927,
        size.height * 0.4534455,
        size.width * 0.6066927,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.5925720,
        size.height * 0.4749655,
        size.width * 0.5852110,
        size.height * 0.4893352,
        size.width * 0.5852110,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.5852110,
        size.height * 0.5187283,
        size.width * 0.5925720,
        size.height * 0.5330979,
        size.width * 0.6066927,
        size.height * 0.5438655);
    path_11.close();

    Paint paint_11_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_11_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_stroke);

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.6903171, size.height * 0.4569959);
    path_12.cubicTo(
        size.width * 0.6649817,
        size.height * 0.4490062,
        size.width * 0.6347378,
        size.height * 0.4528634,
        size.width * 0.6141463,
        size.height * 0.4685662);
    path_12.cubicTo(
        size.width * 0.5868463,
        size.height * 0.4893814,
        size.width * 0.5868463,
        size.height * 0.5231297,
        size.width * 0.6141463,
        size.height * 0.5439448);
    path_12.cubicTo(
        size.width * 0.6191463,
        size.height * 0.5477593,
        size.width * 0.6247195,
        size.height * 0.5508752,
        size.width * 0.6306524,
        size.height * 0.5532917);
    path_12.cubicTo(
        size.width * 0.6224024,
        size.height * 0.5506903,
        size.width * 0.6146768,
        size.height * 0.5468338,
        size.width * 0.6079707,
        size.height * 0.5417214);
    path_12.cubicTo(
        size.width * 0.5806732,
        size.height * 0.5209055,
        size.width * 0.5806732,
        size.height * 0.4871572,
        size.width * 0.6079707,
        size.height * 0.4663421);
    path_12.cubicTo(
        size.width * 0.6302683,
        size.height * 0.4493414,
        size.width * 0.6638780,
        size.height * 0.4462262,
        size.width * 0.6903171,
        size.height * 0.4569959);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.3841341, size.height * 0.5519172);
    path_13.lineTo(size.width * 0.3843293, size.height * 0.5519172);
    path_13.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5712572,
        size.width * 0.3960012,
        size.height * 0.5900103,
        size.width * 0.4144537,
        size.height * 0.6044331);
    path_13.cubicTo(
        size.width * 0.4344610,
        size.height * 0.6200717,
        size.width * 0.4605652,
        size.height * 0.6278159,
        size.width * 0.4865591,
        size.height * 0.6278159);
    path_13.cubicTo(
        size.width * 0.5125524,
        size.height * 0.6278159,
        size.width * 0.5386567,
        size.height * 0.6200717,
        size.width * 0.5586640,
        size.height * 0.6044331);
    path_13.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5900103,
        size.width * 0.5873012,
        size.height * 0.5712572,
        size.width * 0.5887884,
        size.height * 0.5519172);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5519172);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5493310);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5115848);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.5867817, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.5770561, size.height * 0.5089986);
    path_13.cubicTo(
        size.width * 0.5723134,
        size.height * 0.5019441,
        size.width * 0.5661738,
        size.height * 0.4953607,
        size.width * 0.5586640,
        size.height * 0.4894910);
    path_13.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4738524,
        size.width * 0.5125524,
        size.height * 0.4661083,
        size.width * 0.4865591,
        size.height * 0.4661083);
    path_13.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4661083,
        size.width * 0.4344610,
        size.height * 0.4738524,
        size.width * 0.4144537,
        size.height * 0.4894910);
    path_13.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4953607,
        size.width * 0.4008049,
        size.height * 0.5019441,
        size.width * 0.3960616,
        size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3864207, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5115848);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5493310);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5519172);
    path_13.close();

    Paint paint_13_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_13_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_stroke);

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.4144494, size.height * 0.5746214);
    path_14.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5902593,
        size.width * 0.4605610,
        size.height * 0.5980041,
        size.width * 0.4865543,
        size.height * 0.5980041);
    path_14.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5980041,
        size.width * 0.5386524,
        size.height * 0.5902593,
        size.width * 0.5586598,
        size.height * 0.5746214);
    path_14.cubicTo(
        size.width * 0.5786890,
        size.height * 0.5589655,
        size.width * 0.5889744,
        size.height * 0.5382069,
        size.width * 0.5889744,
        size.height * 0.5171503);
    path_14.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4960931,
        size.width * 0.5786890,
        size.height * 0.4753345,
        size.width * 0.5586598,
        size.height * 0.4596786);
    path_14.cubicTo(
        size.width * 0.5386524,
        size.height * 0.4440407,
        size.width * 0.5125482,
        size.height * 0.4362959,
        size.width * 0.4865543,
        size.height * 0.4362959);
    path_14.cubicTo(
        size.width * 0.4605610,
        size.height * 0.4362959,
        size.width * 0.4344567,
        size.height * 0.4440407,
        size.width * 0.4144494,
        size.height * 0.4596786);
    path_14.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4753345,
        size.width * 0.3841341,
        size.height * 0.4960931,
        size.width * 0.3841341,
        size.height * 0.5171503);
    path_14.cubicTo(
        size.width * 0.3841341,
        size.height * 0.5382069,
        size.width * 0.3944201,
        size.height * 0.5589655,
        size.width * 0.4144494,
        size.height * 0.5746214);
    path_14.close();

    Paint paint_14_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_14_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_stroke);

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.4370348, size.height * 0.5569669);
    path_15.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5677297,
        size.width * 0.4687348,
        size.height * 0.5730366,
        size.width * 0.4865537,
        size.height * 0.5730366);
    path_15.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5730366,
        size.width * 0.5223018,
        size.height * 0.5677297,
        size.width * 0.5360720,
        size.height * 0.5569662);
    path_15.cubicTo(
        size.width * 0.5498646,
        size.height * 0.5461862,
        size.width * 0.5570317,
        size.height * 0.5318166,
        size.width * 0.5570317,
        size.height * 0.5171497);
    path_15.cubicTo(
        size.width * 0.5570317,
        size.height * 0.5024821,
        size.width * 0.5498646,
        size.height * 0.4881131,
        size.width * 0.5360720,
        size.height * 0.4773324);
    path_15.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4665690,
        size.width * 0.5043726,
        size.height * 0.4612628,
        size.width * 0.4865537,
        size.height * 0.4612628);
    path_15.cubicTo(
        size.width * 0.4687348,
        size.height * 0.4612628,
        size.width * 0.4508049,
        size.height * 0.4665690,
        size.width * 0.4370348,
        size.height * 0.4773324);
    path_15.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4881131,
        size.width * 0.4160750,
        size.height * 0.5024821,
        size.width * 0.4160750,
        size.height * 0.5171497);
    path_15.cubicTo(
        size.width * 0.4160750,
        size.height * 0.5318166,
        size.width * 0.4232427,
        size.height * 0.5461862,
        size.width * 0.4370348,
        size.height * 0.5569669);
    path_15.close();

    Paint paint_15_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_15_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_stroke);

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.5186683, size.height * 0.4701138);
    path_16.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4621241,
        size.width * 0.4644470,
        size.height * 0.4659814,
        size.width * 0.4443573,
        size.height * 0.4816841);
    path_16.cubicTo(
        size.width * 0.4177262,
        size.height * 0.5024993,
        size.width * 0.4177262,
        size.height * 0.5362476,
        size.width * 0.4443573,
        size.height * 0.5570628);
    path_16.cubicTo(
        size.width * 0.4492372,
        size.height * 0.5608772,
        size.width * 0.4546732,
        size.height * 0.5639931,
        size.width * 0.4604610,
        size.height * 0.5664097);
    path_16.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5638083,
        size.width * 0.4448756,
        size.height * 0.5599517,
        size.width * 0.4383348,
        size.height * 0.5548393);
    path_16.cubicTo(
        size.width * 0.4117043,
        size.height * 0.5340234,
        size.width * 0.4117043,
        size.height * 0.5002752,
        size.width * 0.4383348,
        size.height * 0.4794600);
    path_16.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4624593,
        size.width * 0.4928726,
        size.height * 0.4593441,
        size.width * 0.5186683,
        size.height * 0.4701138);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.3841341, size.height * 0.4901428);
    path_17.lineTo(size.width * 0.3843293, size.height * 0.4901428);
    path_17.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5094828,
        size.width * 0.3960012,
        size.height * 0.5282359,
        size.width * 0.4144537,
        size.height * 0.5426593);
    path_17.cubicTo(
        size.width * 0.4344610,
        size.height * 0.5582972,
        size.width * 0.4605652,
        size.height * 0.5660414,
        size.width * 0.4865591,
        size.height * 0.5660414);
    path_17.cubicTo(
        size.width * 0.5125524,
        size.height * 0.5660414,
        size.width * 0.5386567,
        size.height * 0.5582972,
        size.width * 0.5586640,
        size.height * 0.5426593);
    path_17.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5282359,
        size.width * 0.5873012,
        size.height * 0.5094828,
        size.width * 0.5887884,
        size.height * 0.4901428);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4901428);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4875566);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4498110);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.5867817, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.5770561, size.height * 0.4472248);
    path_17.cubicTo(
        size.width * 0.5723134,
        size.height * 0.4401697,
        size.width * 0.5661738,
        size.height * 0.4335862,
        size.width * 0.5586640,
        size.height * 0.4277166);
    path_17.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4120779,
        size.width * 0.5125524,
        size.height * 0.4043338,
        size.width * 0.4865591,
        size.height * 0.4043338);
    path_17.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4043338,
        size.width * 0.4344610,
        size.height * 0.4120779,
        size.width * 0.4144537,
        size.height * 0.4277166);
    path_17.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4335862,
        size.width * 0.4008049,
        size.height * 0.4401697,
        size.width * 0.3960616,
        size.height * 0.4472248);
    path_17.lineTo(size.width * 0.3864207, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4498110);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4875566);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4901428);
    path_17.close();

    Paint paint_17_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_17_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_stroke);

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.4144494, size.height * 0.5128469);
    path_18.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5284855,
        size.width * 0.4605610,
        size.height * 0.5362297,
        size.width * 0.4865543,
        size.height * 0.5362297);
    path_18.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5362297,
        size.width * 0.5386524,
        size.height * 0.5284855,
        size.width * 0.5586598,
        size.height * 0.5128469);
    path_18.cubicTo(
        size.width * 0.5786890,
        size.height * 0.4971917,
        size.width * 0.5889744,
        size.height * 0.4764324,
        size.width * 0.5889744,
        size.height * 0.4553759);
    path_18.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4343186,
        size.width * 0.5786890,
        size.height * 0.4135600,
        size.width * 0.5586598,
        size.height * 0.3979048);
    path_18.cubicTo(
        size.width * 0.5386524,
        size.height * 0.3822662,
        size.width * 0.5125482,
        size.height * 0.3745221,
        size.width * 0.4865543,
        size.height * 0.3745221);
    path_18.cubicTo(
        size.width * 0.4605610,
        size.height * 0.3745221,
        size.width * 0.4344567,
        size.height * 0.3822662,
        size.width * 0.4144494,
        size.height * 0.3979048);
    path_18.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4135600,
        size.width * 0.3841341,
        size.height * 0.4343193,
        size.width * 0.3841341,
        size.height * 0.4553759);
    path_18.cubicTo(
        size.width * 0.3841341,
        size.height * 0.4764324,
        size.width * 0.3944201,
        size.height * 0.4971917,
        size.width * 0.4144494,
        size.height * 0.5128469);
    path_18.close();

    Paint paint_18_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_18_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_stroke);

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(size.width * 0.4370348, size.height * 0.4951924);
    path_19.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5059559,
        size.width * 0.4687348,
        size.height * 0.5112621,
        size.width * 0.4865537,
        size.height * 0.5112621);
    path_19.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5112621,
        size.width * 0.5223018,
        size.height * 0.5059559,
        size.width * 0.5360720,
        size.height * 0.4951924);
    path_19.cubicTo(
        size.width * 0.5498646,
        size.height * 0.4844117,
        size.width * 0.5570317,
        size.height * 0.4700428,
        size.width * 0.5570317,
        size.height * 0.4553752);
    path_19.cubicTo(
        size.width * 0.5570317,
        size.height * 0.4407083,
        size.width * 0.5498646,
        size.height * 0.4263386,
        size.width * 0.5360720,
        size.height * 0.4155579);
    path_19.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4047952,
        size.width * 0.5043726,
        size.height * 0.3994883,
        size.width * 0.4865537,
        size.height * 0.3994883);
    path_19.cubicTo(
        size.width * 0.4687348,
        size.height * 0.3994883,
        size.width * 0.4508049,
        size.height * 0.4047952,
        size.width * 0.4370348,
        size.height * 0.4155579);
    path_19.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4263386,
        size.width * 0.4160750,
        size.height * 0.4407083,
        size.width * 0.4160750,
        size.height * 0.4553752);
    path_19.cubicTo(
        size.width * 0.4160750,
        size.height * 0.4700428,
        size.width * 0.4232427,
        size.height * 0.4844117,
        size.width * 0.4370348,
        size.height * 0.4951924);
    path_19.close();

    Paint paint_19_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_19_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_stroke);

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.5186683, size.height * 0.4083393);
    path_20.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4003503,
        size.width * 0.4644470,
        size.height * 0.4042069,
        size.width * 0.4443573,
        size.height * 0.4199097);
    path_20.cubicTo(
        size.width * 0.4177262,
        size.height * 0.4407248,
        size.width * 0.4177262,
        size.height * 0.4744731,
        size.width * 0.4443573,
        size.height * 0.4952883);
    path_20.cubicTo(
        size.width * 0.4492372,
        size.height * 0.4991028,
        size.width * 0.4546732,
        size.height * 0.5022186,
        size.width * 0.4604610,
        size.height * 0.5046352);
    path_20.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5020338,
        size.width * 0.4448756,
        size.height * 0.4981772,
        size.width * 0.4383348,
        size.height * 0.4930648);
    path_20.cubicTo(
        size.width * 0.4117043,
        size.height * 0.4722497,
        size.width * 0.4117043,
        size.height * 0.4385014,
        size.width * 0.4383348,
        size.height * 0.4176855);
    path_20.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4006848,
        size.width * 0.4928726,
        size.height * 0.3975697,
        size.width * 0.5186683,
        size.height * 0.4083393);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.7744024, size.height * 0.2241372);
    path_21.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2138345,
        size.width * 0.7798110,
        size.height * 0.2031117,
        size.width * 0.7798110,
        size.height * 0.1921007);
    path_21.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1124841,
        size.width * 0.6821220,
        size.height * 0.04794248,
        size.width * 0.5616250,
        size.height * 0.04794248);
    path_21.cubicTo(
        size.width * 0.4411250,
        size.height * 0.04794248,
        size.width * 0.3434402,
        size.height * 0.1124841,
        size.width * 0.3434402,
        size.height * 0.1921007);
    path_21.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2031110,
        size.width * 0.3453085,
        size.height * 0.2138331,
        size.width * 0.3488470,
        size.height * 0.2241359);
    path_21.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1599379,
        size.width * 0.4577890,
        size.height * 0.1120138,
        size.width * 0.5616244,
        size.height * 0.1120138);
    path_21.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1120138,
        size.width * 0.7523537,
        size.height * 0.1599393,
        size.width * 0.7744024,
        size.height * 0.2241372);
    path_21.close();

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.3293390, size.height * 0.2071000);
    path_22.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2182041,
        size.width * 0.3235116,
        size.height * 0.2297593,
        size.width * 0.3235116,
        size.height * 0.2416255);
    path_22.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3274269,
        size.width * 0.4287841,
        size.height * 0.3969828,
        size.width * 0.5586451,
        size.height * 0.3969828);
    path_22.cubicTo(
        size.width * 0.6885061,
        size.height * 0.3969828,
        size.width * 0.7937805,
        size.height * 0.3274269,
        size.width * 0.7937805,
        size.height * 0.2416255);
    path_22.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2297600,
        size.width * 0.7917683,
        size.height * 0.2182055,
        size.width * 0.7879512,
        size.height * 0.2071021);
    path_22.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2762869,
        size.width * 0.6705488,
        size.height * 0.3279338,
        size.width * 0.5586457,
        size.height * 0.3279338);
    path_22.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3279338,
        size.width * 0.3530988,
        size.height * 0.2762855,
        size.width * 0.3293390,
        size.height * 0.2071000);
    path_22.close();

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(size.width * 0.3171738, size.height * 0.2219545);
    path_23.cubicTo(
        size.width * 0.3169957,
        size.height * 0.2246041,
        size.width * 0.3169055,
        size.height * 0.2272697,
        size.width * 0.3169055,
        size.height * 0.2299497);
    path_23.cubicTo(
        size.width * 0.3169055,
        size.height * 0.3228393,
        size.width * 0.4249634,
        size.height * 0.3981414,
        size.width * 0.5582598,
        size.height * 0.3981414);
    path_23.cubicTo(
        size.width * 0.6915549,
        size.height * 0.3981414,
        size.width * 0.7996159,
        size.height * 0.3228393,
        size.width * 0.7996159,
        size.height * 0.2299497);
    path_23.cubicTo(
        size.width * 0.7996159,
        size.height * 0.2272697,
        size.width * 0.7995244,
        size.height * 0.2246041,
        size.width * 0.7993476,
        size.height * 0.2219545);
    path_23.cubicTo(
        size.width * 0.7933598,
        size.height * 0.3135621,
        size.width * 0.6877073,
        size.height * 0.3865172,
        size.width * 0.5582598,
        size.height * 0.3865172);
    path_23.cubicTo(
        size.width * 0.4288098,
        size.height * 0.3865172,
        size.width * 0.3231628,
        size.height * 0.3135621,
        size.width * 0.3171738,
        size.height * 0.2219545);
    path_23.close();

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(size.width * 0.3171738, size.height * 0.2219545);
    path_24.cubicTo(
        size.width * 0.3169957,
        size.height * 0.2246041,
        size.width * 0.3169055,
        size.height * 0.2272697,
        size.width * 0.3169055,
        size.height * 0.2299497);
    path_24.cubicTo(
        size.width * 0.3169055,
        size.height * 0.3228393,
        size.width * 0.4249634,
        size.height * 0.3981414,
        size.width * 0.5582598,
        size.height * 0.3981414);
    path_24.cubicTo(
        size.width * 0.6915549,
        size.height * 0.3981414,
        size.width * 0.7996159,
        size.height * 0.3228393,
        size.width * 0.7996159,
        size.height * 0.2299497);
    path_24.cubicTo(
        size.width * 0.7996159,
        size.height * 0.2272697,
        size.width * 0.7995244,
        size.height * 0.2246041,
        size.width * 0.7993476,
        size.height * 0.2219545);
    path_24.cubicTo(
        size.width * 0.7933598,
        size.height * 0.3135621,
        size.width * 0.6877073,
        size.height * 0.3865172,
        size.width * 0.5582598,
        size.height * 0.3865172);
    path_24.cubicTo(
        size.width * 0.4288098,
        size.height * 0.3865172,
        size.width * 0.3231628,
        size.height * 0.3135621,
        size.width * 0.3171738,
        size.height * 0.2219545);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(size.width * 0.3171738, size.height * 0.2219545);
    path_25.lineTo(size.width * 0.3232543, size.height * 0.2214455);
    path_25.lineTo(size.width * 0.3110933, size.height * 0.2214317);
    path_25.lineTo(size.width * 0.3171738, size.height * 0.2219545);
    path_25.close();
    path_25.moveTo(size.width * 0.7993476, size.height * 0.2219545);
    path_25.lineTo(size.width * 0.8054268, size.height * 0.2214317);
    path_25.lineTo(size.width * 0.7932683, size.height * 0.2214455);
    path_25.lineTo(size.width * 0.7993476, size.height * 0.2219545);
    path_25.close();
    path_25.moveTo(size.width * 0.5582598, size.height * 0.3865172);
    path_25.lineTo(size.width * 0.5582598, size.height * 0.3796207);
    path_25.lineTo(size.width * 0.5582598, size.height * 0.3865172);
    path_25.close();
    path_25.moveTo(size.width * 0.3230030, size.height * 0.2299497);
    path_25.cubicTo(
        size.width * 0.3230030,
        size.height * 0.2274441,
        size.width * 0.3230872,
        size.height * 0.2249531,
        size.width * 0.3232537,
        size.height * 0.2224766);
    path_25.lineTo(size.width * 0.3110933, size.height * 0.2214317);
    path_25.cubicTo(
        size.width * 0.3109037,
        size.height * 0.2242552,
        size.width * 0.3108079,
        size.height * 0.2270945,
        size.width * 0.3108079,
        size.height * 0.2299497);
    path_25.lineTo(size.width * 0.3230030, size.height * 0.2299497);
    path_25.close();
    path_25.moveTo(size.width * 0.5582598, size.height * 0.3912448);
    path_25.cubicTo(
        size.width * 0.4925555,
        size.height * 0.3912448,
        size.width * 0.4333634,
        size.height * 0.3726717,
        size.width * 0.3907951,
        size.height * 0.3430076);
    path_25.cubicTo(
        size.width * 0.3481293,
        size.height * 0.3132752,
        size.width * 0.3230030,
        size.height * 0.2731103,
        size.width * 0.3230030,
        size.height * 0.2299497);
    path_25.lineTo(size.width * 0.3108079, size.height * 0.2299497);
    path_25.cubicTo(
        size.width * 0.3108079,
        size.height * 0.2796786,
        size.width * 0.3397110,
        size.height * 0.3236097,
        size.width * 0.3843982,
        size.height * 0.3547503);
    path_25.cubicTo(
        size.width * 0.4291829,
        size.height * 0.3859593,
        size.width * 0.4906677,
        size.height * 0.4050379,
        size.width * 0.5582598,
        size.height * 0.4050379);
    path_25.lineTo(size.width * 0.5582598, size.height * 0.3912448);
    path_25.close();
    path_25.moveTo(size.width * 0.7935183, size.height * 0.2299497);
    path_25.cubicTo(
        size.width * 0.7935183,
        size.height * 0.2731103,
        size.width * 0.7683902,
        size.height * 0.3132752,
        size.width * 0.7257256,
        size.height * 0.3430076);
    path_25.cubicTo(
        size.width * 0.6831585,
        size.height * 0.3726717,
        size.width * 0.6239634,
        size.height * 0.3912448,
        size.width * 0.5582598,
        size.height * 0.3912448);
    path_25.lineTo(size.width * 0.5582598, size.height * 0.4050379);
    path_25.cubicTo(
        size.width * 0.6258537,
        size.height * 0.4050379,
        size.width * 0.6873354,
        size.height * 0.3859593,
        size.width * 0.7321220,
        size.height * 0.3547503);
    path_25.cubicTo(
        size.width * 0.7768110,
        size.height * 0.3236097,
        size.width * 0.8057134,
        size.height * 0.2796786,
        size.width * 0.8057134,
        size.height * 0.2299497);
    path_25.lineTo(size.width * 0.7935183, size.height * 0.2299497);
    path_25.close();
    path_25.moveTo(size.width * 0.7932683, size.height * 0.2224766);
    path_25.cubicTo(
        size.width * 0.7934329,
        size.height * 0.2249531,
        size.width * 0.7935183,
        size.height * 0.2274441,
        size.width * 0.7935183,
        size.height * 0.2299497);
    path_25.lineTo(size.width * 0.8057134, size.height * 0.2299497);
    path_25.cubicTo(
        size.width * 0.8057134,
        size.height * 0.2270952,
        size.width * 0.8056159,
        size.height * 0.2242552,
        size.width * 0.8054268,
        size.height * 0.2214317);
    path_25.lineTo(size.width * 0.7932683, size.height * 0.2224766);
    path_25.close();
    path_25.moveTo(size.width * 0.7932683, size.height * 0.2214455);
    path_25.cubicTo(
        size.width * 0.7904695,
        size.height * 0.2642455,
        size.width * 0.7642866,
        size.height * 0.3036821,
        size.width * 0.7219451,
        size.height * 0.3326897);
    path_25.cubicTo(
        size.width * 0.6796829,
        size.height * 0.3616386,
        size.width * 0.6220305,
        size.height * 0.3796207,
        size.width * 0.5582598,
        size.height * 0.3796207);
    path_25.lineTo(size.width * 0.5582598, size.height * 0.3934138);
    path_25.cubicTo(
        size.width * 0.6239390,
        size.height * 0.3934138,
        size.width * 0.6838354,
        size.height * 0.3749193,
        size.width * 0.7282622,
        size.height * 0.3444876);
    path_25.cubicTo(
        size.width * 0.7725976,
        size.height * 0.3141166,
        size.width * 0.8022378,
        size.height * 0.2712710,
        size.width * 0.8054268,
        size.height * 0.2224628);
    path_25.lineTo(size.width * 0.7932683, size.height * 0.2214455);
    path_25.close();
    path_25.moveTo(size.width * 0.5582598, size.height * 0.3796207);
    path_25.cubicTo(
        size.width * 0.4944866,
        size.height * 0.3796207,
        size.width * 0.4368372,
        size.height * 0.3616386,
        size.width * 0.3945774,
        size.height * 0.3326897);
    path_25.cubicTo(
        size.width * 0.3522311,
        size.height * 0.3036821,
        size.width * 0.3260524,
        size.height * 0.2642455,
        size.width * 0.3232543,
        size.height * 0.2214455);
    path_25.lineTo(size.width * 0.3110927, size.height * 0.2224628);
    path_25.cubicTo(
        size.width * 0.3142835,
        size.height * 0.2712710,
        size.width * 0.3439232,
        size.height * 0.3141159,
        size.width * 0.3882598,
        size.height * 0.3444876);
    path_25.cubicTo(
        size.width * 0.4326841,
        size.height * 0.3749193,
        size.width * 0.4925829,
        size.height * 0.3934138,
        size.width * 0.5582598,
        size.height * 0.3934138);
    path_25.lineTo(size.width * 0.5582598, size.height * 0.3796207);
    path_25.close();

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(size.width * 0.7796707, size.height * 0.1913793);
    path_26.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2300317,
        size.width * 0.7558537,
        size.height * 0.2656938,
        size.width * 0.7160671,
        size.height * 0.2918931);
    path_26.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3180400,
        size.width * 0.6212927,
        size.height * 0.3343283,
        size.width * 0.5602970,
        size.height * 0.3343283);
    path_26.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3343283,
        size.width * 0.4442335,
        size.height * 0.3180400,
        size.width * 0.4045250,
        size.height * 0.2918931);
    path_26.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2656938,
        size.width * 0.3409213,
        size.height * 0.2300317,
        size.width * 0.3409213,
        size.height * 0.1913793);
    path_26.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1527269,
        size.width * 0.3647378,
        size.height * 0.1170648,
        size.width * 0.4045250,
        size.height * 0.09086552);
    path_26.cubicTo(
        size.width * 0.4442335,
        size.height * 0.06471834,
        size.width * 0.4993000,
        size.height * 0.04843062,
        size.width * 0.5602970,
        size.height * 0.04843062);
    path_26.cubicTo(
        size.width * 0.6212927,
        size.height * 0.04843062,
        size.width * 0.6763598,
        size.height * 0.06471834,
        size.width * 0.7160671,
        size.height * 0.09086552);
    path_26.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1170648,
        size.width * 0.7796707,
        size.height * 0.1527269,
        size.width * 0.7796707,
        size.height * 0.1913793);
    path_26.close();

    Paint paint_26_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_26_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_stroke);

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 5
class WinPrizeClaimAsset5 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6776366),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6714021),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2729986,
        size.width * 0.3100006,
        size.height * 0.2467310,
        size.width * 0.3226079,
        size.height * 0.2426034);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2080717);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1773372,
        size.width * 0.3263305,
        size.height * 0.1454572,
        size.width * 0.3437433,
        size.height * 0.1218614);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.05412041,
        size.width * 0.4950689,
        size.height * 0.02758621,
        size.width * 0.5575037,
        size.height * 0.02758621);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.02758621,
        size.width * 0.7592073,
        size.height * 0.08968069,
        size.width * 0.7860122,
        size.height * 0.1389848);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1593966,
        size.width * 0.7993659,
        size.height * 0.1838607,
        size.width * 0.7993659,
        size.height * 0.2078221);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2426034);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2741241,
        size.width * 0.8385183,
        size.height * 0.3180283,
        size.width * 0.8361951,
        size.height * 0.3360400);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6399910);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.6970276,
        size.width * 0.7394512,
        size.height * 0.8084000,
        size.width * 0.5475506,
        size.height * 0.7975931);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.7867862,
        size.width * 0.2890988,
        size.height * 0.6880228,
        size.width * 0.2798091,
        size.height * 0.6399910);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.5887262),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5768939, size.height * 0.5780490),
            width: size.width * 0.3446463,
            height: size.height * 0.2379876),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3687598, size.height * 0.5924628);
    path_5.lineTo(size.width * 0.3689591, size.height * 0.5924628);
    path_5.cubicTo(
        size.width * 0.3704841,
        size.height * 0.6118283,
        size.width * 0.3809341,
        size.height * 0.6305834,
        size.width * 0.3998354,
        size.height * 0.6449959);
    path_5.cubicTo(
        size.width * 0.4203299,
        size.height * 0.6606234,
        size.width * 0.4470683,
        size.height * 0.6683621,
        size.width * 0.4736927,
        size.height * 0.6683621);
    path_5.cubicTo(
        size.width * 0.5003171,
        size.height * 0.6683621,
        size.width * 0.5270555,
        size.height * 0.6606234,
        size.width * 0.5475500,
        size.height * 0.6449959);
    path_5.cubicTo(
        size.width * 0.5664512,
        size.height * 0.6305834,
        size.width * 0.5769012,
        size.height * 0.6118283,
        size.width * 0.5784262,
        size.height * 0.5924628);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5924628);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5898766);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5521310);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5495448);
    path_5.lineTo(size.width * 0.5764256, size.height * 0.5495448);
    path_5.lineTo(size.width * 0.5664116, size.height * 0.5495448);
    path_5.cubicTo(
        size.width * 0.5615482,
        size.height * 0.5424814,
        size.width * 0.5552518,
        size.height * 0.5358931,
        size.width * 0.5475500,
        size.height * 0.5300200);
    path_5.cubicTo(
        size.width * 0.5270555,
        size.height * 0.5143924,
        size.width * 0.5003171,
        size.height * 0.5066538,
        size.width * 0.4736927,
        size.height * 0.5066538);
    path_5.cubicTo(
        size.width * 0.4470683,
        size.height * 0.5066538,
        size.width * 0.4203299,
        size.height * 0.5143924,
        size.width * 0.3998354,
        size.height * 0.5300200);
    path_5.cubicTo(
        size.width * 0.3921335,
        size.height * 0.5358931,
        size.width * 0.3858372,
        size.height * 0.5424814,
        size.width * 0.3809738,
        size.height * 0.5495448);
    path_5.lineTo(size.width * 0.3710463, size.height * 0.5495448);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5495448);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5521310);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5898766);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5924628);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3998427, size.height * 0.6151807);
    path_6.cubicTo(
        size.width * 0.4203372,
        size.height * 0.6308083,
        size.width * 0.4470756,
        size.height * 0.6385462,
        size.width * 0.4737000,
        size.height * 0.6385462);
    path_6.cubicTo(
        size.width * 0.5003244,
        size.height * 0.6385462,
        size.width * 0.5270628,
        size.height * 0.6308083,
        size.width * 0.5475573,
        size.height * 0.6151807);
    path_6.cubicTo(
        size.width * 0.5680713,
        size.height * 0.5995379,
        size.width * 0.5786287,
        size.height * 0.5787786,
        size.width * 0.5786287,
        size.height * 0.5576924);
    path_6.cubicTo(
        size.width * 0.5786287,
        size.height * 0.5366062,
        size.width * 0.5680713,
        size.height * 0.5158469,
        size.width * 0.5475573,
        size.height * 0.5002048);
    path_6.cubicTo(
        size.width * 0.5270628,
        size.height * 0.4845766,
        size.width * 0.5003244,
        size.height * 0.4768386,
        size.width * 0.4737000,
        size.height * 0.4768386);
    path_6.cubicTo(
        size.width * 0.4470756,
        size.height * 0.4768386,
        size.width * 0.4203372,
        size.height * 0.4845766,
        size.width * 0.3998427,
        size.height * 0.5002048);
    path_6.cubicTo(
        size.width * 0.3793287,
        size.height * 0.5158476,
        size.width * 0.3687713,
        size.height * 0.5366069,
        size.width * 0.3687713,
        size.height * 0.5576924);
    path_6.cubicTo(
        size.width * 0.3687713,
        size.height * 0.5787786,
        size.width * 0.3793287,
        size.height * 0.5995379,
        size.width * 0.3998427,
        size.height * 0.6151807);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_6_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4229915, size.height * 0.5975276);
    path_7.cubicTo(
        size.width * 0.4370927,
        size.height * 0.6082800,
        size.width * 0.4554518,
        size.height * 0.6135807,
        size.width * 0.4736970,
        size.height * 0.6135807);
    path_7.cubicTo(
        size.width * 0.4919415,
        size.height * 0.6135807,
        size.width * 0.5103006,
        size.height * 0.6082800,
        size.width * 0.5244018,
        size.height * 0.5975276);
    path_7.cubicTo(
        size.width * 0.5385226,
        size.height * 0.5867600,
        size.width * 0.5458835,
        size.height * 0.5723903,
        size.width * 0.5458835,
        size.height * 0.5576938);
    path_7.cubicTo(
        size.width * 0.5458835,
        size.height * 0.5429972,
        size.width * 0.5385226,
        size.height * 0.5286276,
        size.width * 0.5244018,
        size.height * 0.5178600);
    path_7.cubicTo(
        size.width * 0.5103006,
        size.height * 0.5071076,
        size.width * 0.4919415,
        size.height * 0.5018069,
        size.width * 0.4736970,
        size.height * 0.5018069);
    path_7.cubicTo(
        size.width * 0.4554518,
        size.height * 0.5018069,
        size.width * 0.4370927,
        size.height * 0.5071076,
        size.width * 0.4229915,
        size.height * 0.5178600);
    path_7.cubicTo(
        size.width * 0.4088707,
        size.height * 0.5286276,
        size.width * 0.4015104,
        size.height * 0.5429972,
        size.width * 0.4015104,
        size.height * 0.5576938);
    path_7.cubicTo(
        size.width * 0.4015104,
        size.height * 0.5723903,
        size.width * 0.4088707,
        size.height * 0.5867600,
        size.width * 0.4229915,
        size.height * 0.5975276);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_7_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.5066159, size.height * 0.5106579);
    path_8.cubicTo(
        size.width * 0.4812817,
        size.height * 0.5026683,
        size.width * 0.4510360,
        size.height * 0.5065255,
        size.width * 0.4304433,
        size.height * 0.5222283);
    path_8.cubicTo(
        size.width * 0.4031457,
        size.height * 0.5430434,
        size.width * 0.4031457,
        size.height * 0.5767917,
        size.width * 0.4304433,
        size.height * 0.5976069);
    path_8.cubicTo(
        size.width * 0.4354457,
        size.height * 0.6014214,
        size.width * 0.4410177,
        size.height * 0.6045372,
        size.width * 0.4469506,
        size.height * 0.6069538);
    path_8.cubicTo(
        size.width * 0.4387024,
        size.height * 0.6043524,
        size.width * 0.4309744,
        size.height * 0.6004959,
        size.width * 0.4242701,
        size.height * 0.5953834);
    path_8.cubicTo(
        size.width * 0.3969726,
        size.height * 0.5745676,
        size.width * 0.3969726,
        size.height * 0.5408193,
        size.width * 0.4242701,
        size.height * 0.5200041);
    path_8.cubicTo(
        size.width * 0.4465652,
        size.height * 0.5030034,
        size.width * 0.4801744,
        size.height * 0.4998883,
        size.width * 0.5066159,
        size.height * 0.5106579);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.5526598, size.height * 0.5388007);
    path_9.cubicTo(
        size.width * 0.5541854,
        size.height * 0.5581662,
        size.width * 0.5646354,
        size.height * 0.5769214,
        size.width * 0.5835366,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.6040311,
        size.height * 0.6069614,
        size.width * 0.6307683,
        size.height * 0.6147000,
        size.width * 0.6573963,
        size.height * 0.6147000);
    path_9.cubicTo(
        size.width * 0.6840183,
        size.height * 0.6147000,
        size.width * 0.7107561,
        size.height * 0.6069614,
        size.width * 0.7312500,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.7501524,
        size.height * 0.5769214,
        size.width * 0.7606037,
        size.height * 0.5581662,
        size.width * 0.7621280,
        size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7601280, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7501098, size.height * 0.4958828);
    path_9.cubicTo(
        size.width * 0.7452500,
        size.height * 0.4888193,
        size.width * 0.7389512,
        size.height * 0.4822310,
        size.width * 0.7312500,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.7107561,
        size.height * 0.4607303,
        size.width * 0.6840183,
        size.height * 0.4529917,
        size.width * 0.6573963,
        size.height * 0.4529917);
    path_9.cubicTo(
        size.width * 0.6307683,
        size.height * 0.4529917,
        size.width * 0.6040311,
        size.height * 0.4607303,
        size.width * 0.5835366,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.5758348,
        size.height * 0.4822310,
        size.width * 0.5695384,
        size.height * 0.4888193,
        size.width * 0.5646744,
        size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5547470, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5835439, size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.6040384,
        size.height * 0.5771476,
        size.width * 0.6307744,
        size.height * 0.5848862,
        size.width * 0.6574024,
        size.height * 0.5848862);
    path_10.cubicTo(
        size.width * 0.6840244,
        size.height * 0.5848862,
        size.width * 0.7107622,
        size.height * 0.5771476,
        size.width * 0.7312561,
        size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.7517744,
        size.height * 0.5458772,
        size.width * 0.7623293,
        size.height * 0.5251179,
        size.width * 0.7623293,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.7623293,
        size.height * 0.4829462,
        size.width * 0.7517744,
        size.height * 0.4621869,
        size.width * 0.7312561,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.7107622,
        size.height * 0.4309166,
        size.width * 0.6840244,
        size.height * 0.4231779,
        size.width * 0.6574024,
        size.height * 0.4231779);
    path_10.cubicTo(
        size.width * 0.6307744,
        size.height * 0.4231779,
        size.width * 0.6040384,
        size.height * 0.4309166,
        size.width * 0.5835439,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.5630299,
        size.height * 0.4621869,
        size.width * 0.5524726,
        size.height * 0.4829462,
        size.width * 0.5524726,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.5524726,
        size.height * 0.5251179,
        size.width * 0.5630299,
        size.height * 0.5458772,
        size.width * 0.5835439,
        size.height * 0.5615200);
    path_10.close();

    Paint paint_10_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_10_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_stroke);

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.6066927, size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.6207927,
        size.height * 0.5546179,
        size.width * 0.6391524,
        size.height * 0.5599186,
        size.width * 0.6573963,
        size.height * 0.5599186);
    path_11.cubicTo(
        size.width * 0.6756402,
        size.height * 0.5599186,
        size.width * 0.6940000,
        size.height * 0.5546179,
        size.width * 0.7081037,
        size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.7222256,
        size.height * 0.5330979,
        size.width * 0.7295854,
        size.height * 0.5187283,
        size.width * 0.7295854,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.7295854,
        size.height * 0.4893352,
        size.width * 0.7222256,
        size.height * 0.4749655,
        size.width * 0.7081037,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.6940000,
        size.height * 0.4534455,
        size.width * 0.6756402,
        size.height * 0.4481448,
        size.width * 0.6573963,
        size.height * 0.4481448);
    path_11.cubicTo(
        size.width * 0.6391524,
        size.height * 0.4481448,
        size.width * 0.6207927,
        size.height * 0.4534455,
        size.width * 0.6066927,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.5925720,
        size.height * 0.4749655,
        size.width * 0.5852110,
        size.height * 0.4893352,
        size.width * 0.5852110,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.5852110,
        size.height * 0.5187283,
        size.width * 0.5925720,
        size.height * 0.5330979,
        size.width * 0.6066927,
        size.height * 0.5438655);
    path_11.close();

    Paint paint_11_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_11_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_stroke);

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.6903171, size.height * 0.4569959);
    path_12.cubicTo(
        size.width * 0.6649817,
        size.height * 0.4490062,
        size.width * 0.6347378,
        size.height * 0.4528634,
        size.width * 0.6141463,
        size.height * 0.4685662);
    path_12.cubicTo(
        size.width * 0.5868463,
        size.height * 0.4893814,
        size.width * 0.5868463,
        size.height * 0.5231297,
        size.width * 0.6141463,
        size.height * 0.5439448);
    path_12.cubicTo(
        size.width * 0.6191463,
        size.height * 0.5477593,
        size.width * 0.6247195,
        size.height * 0.5508752,
        size.width * 0.6306524,
        size.height * 0.5532917);
    path_12.cubicTo(
        size.width * 0.6224024,
        size.height * 0.5506903,
        size.width * 0.6146768,
        size.height * 0.5468338,
        size.width * 0.6079707,
        size.height * 0.5417214);
    path_12.cubicTo(
        size.width * 0.5806732,
        size.height * 0.5209055,
        size.width * 0.5806732,
        size.height * 0.4871572,
        size.width * 0.6079707,
        size.height * 0.4663421);
    path_12.cubicTo(
        size.width * 0.6302683,
        size.height * 0.4493414,
        size.width * 0.6638780,
        size.height * 0.4462262,
        size.width * 0.6903171,
        size.height * 0.4569959);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.3841341, size.height * 0.5519172);
    path_13.lineTo(size.width * 0.3843293, size.height * 0.5519172);
    path_13.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5712572,
        size.width * 0.3960012,
        size.height * 0.5900103,
        size.width * 0.4144537,
        size.height * 0.6044331);
    path_13.cubicTo(
        size.width * 0.4344610,
        size.height * 0.6200717,
        size.width * 0.4605652,
        size.height * 0.6278159,
        size.width * 0.4865591,
        size.height * 0.6278159);
    path_13.cubicTo(
        size.width * 0.5125524,
        size.height * 0.6278159,
        size.width * 0.5386567,
        size.height * 0.6200717,
        size.width * 0.5586640,
        size.height * 0.6044331);
    path_13.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5900103,
        size.width * 0.5873012,
        size.height * 0.5712572,
        size.width * 0.5887884,
        size.height * 0.5519172);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5519172);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5493310);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5115848);
    path_13.lineTo(size.width * 0.5890683, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.5867817, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.5770561, size.height * 0.5089986);
    path_13.cubicTo(
        size.width * 0.5723134,
        size.height * 0.5019441,
        size.width * 0.5661738,
        size.height * 0.4953607,
        size.width * 0.5586640,
        size.height * 0.4894910);
    path_13.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4738524,
        size.width * 0.5125524,
        size.height * 0.4661083,
        size.width * 0.4865591,
        size.height * 0.4661083);
    path_13.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4661083,
        size.width * 0.4344610,
        size.height * 0.4738524,
        size.width * 0.4144537,
        size.height * 0.4894910);
    path_13.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4953607,
        size.width * 0.4008049,
        size.height * 0.5019441,
        size.width * 0.3960616,
        size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3864207, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5089986);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5115848);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5493310);
    path_13.lineTo(size.width * 0.3841341, size.height * 0.5519172);
    path_13.close();

    Paint paint_13_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_13_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_stroke);

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.4144494, size.height * 0.5746214);
    path_14.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5902593,
        size.width * 0.4605610,
        size.height * 0.5980041,
        size.width * 0.4865543,
        size.height * 0.5980041);
    path_14.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5980041,
        size.width * 0.5386524,
        size.height * 0.5902593,
        size.width * 0.5586598,
        size.height * 0.5746214);
    path_14.cubicTo(
        size.width * 0.5786890,
        size.height * 0.5589655,
        size.width * 0.5889744,
        size.height * 0.5382069,
        size.width * 0.5889744,
        size.height * 0.5171503);
    path_14.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4960931,
        size.width * 0.5786890,
        size.height * 0.4753345,
        size.width * 0.5586598,
        size.height * 0.4596786);
    path_14.cubicTo(
        size.width * 0.5386524,
        size.height * 0.4440407,
        size.width * 0.5125482,
        size.height * 0.4362959,
        size.width * 0.4865543,
        size.height * 0.4362959);
    path_14.cubicTo(
        size.width * 0.4605610,
        size.height * 0.4362959,
        size.width * 0.4344567,
        size.height * 0.4440407,
        size.width * 0.4144494,
        size.height * 0.4596786);
    path_14.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4753345,
        size.width * 0.3841341,
        size.height * 0.4960931,
        size.width * 0.3841341,
        size.height * 0.5171503);
    path_14.cubicTo(
        size.width * 0.3841341,
        size.height * 0.5382069,
        size.width * 0.3944201,
        size.height * 0.5589655,
        size.width * 0.4144494,
        size.height * 0.5746214);
    path_14.close();

    Paint paint_14_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_14_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_stroke);

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.4370348, size.height * 0.5569669);
    path_15.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5677297,
        size.width * 0.4687348,
        size.height * 0.5730366,
        size.width * 0.4865537,
        size.height * 0.5730366);
    path_15.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5730366,
        size.width * 0.5223018,
        size.height * 0.5677297,
        size.width * 0.5360720,
        size.height * 0.5569662);
    path_15.cubicTo(
        size.width * 0.5498646,
        size.height * 0.5461862,
        size.width * 0.5570317,
        size.height * 0.5318166,
        size.width * 0.5570317,
        size.height * 0.5171497);
    path_15.cubicTo(
        size.width * 0.5570317,
        size.height * 0.5024821,
        size.width * 0.5498646,
        size.height * 0.4881131,
        size.width * 0.5360720,
        size.height * 0.4773324);
    path_15.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4665690,
        size.width * 0.5043726,
        size.height * 0.4612628,
        size.width * 0.4865537,
        size.height * 0.4612628);
    path_15.cubicTo(
        size.width * 0.4687348,
        size.height * 0.4612628,
        size.width * 0.4508049,
        size.height * 0.4665690,
        size.width * 0.4370348,
        size.height * 0.4773324);
    path_15.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4881131,
        size.width * 0.4160750,
        size.height * 0.5024821,
        size.width * 0.4160750,
        size.height * 0.5171497);
    path_15.cubicTo(
        size.width * 0.4160750,
        size.height * 0.5318166,
        size.width * 0.4232427,
        size.height * 0.5461862,
        size.width * 0.4370348,
        size.height * 0.5569669);
    path_15.close();

    Paint paint_15_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_15_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_stroke);

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.5186683, size.height * 0.4701138);
    path_16.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4621241,
        size.width * 0.4644470,
        size.height * 0.4659814,
        size.width * 0.4443573,
        size.height * 0.4816841);
    path_16.cubicTo(
        size.width * 0.4177262,
        size.height * 0.5024993,
        size.width * 0.4177262,
        size.height * 0.5362476,
        size.width * 0.4443573,
        size.height * 0.5570628);
    path_16.cubicTo(
        size.width * 0.4492372,
        size.height * 0.5608772,
        size.width * 0.4546732,
        size.height * 0.5639931,
        size.width * 0.4604610,
        size.height * 0.5664097);
    path_16.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5638083,
        size.width * 0.4448756,
        size.height * 0.5599517,
        size.width * 0.4383348,
        size.height * 0.5548393);
    path_16.cubicTo(
        size.width * 0.4117043,
        size.height * 0.5340234,
        size.width * 0.4117043,
        size.height * 0.5002752,
        size.width * 0.4383348,
        size.height * 0.4794600);
    path_16.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4624593,
        size.width * 0.4928726,
        size.height * 0.4593441,
        size.width * 0.5186683,
        size.height * 0.4701138);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.3841341, size.height * 0.4901428);
    path_17.lineTo(size.width * 0.3843293, size.height * 0.4901428);
    path_17.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5094828,
        size.width * 0.3960012,
        size.height * 0.5282359,
        size.width * 0.4144537,
        size.height * 0.5426593);
    path_17.cubicTo(
        size.width * 0.4344610,
        size.height * 0.5582972,
        size.width * 0.4605652,
        size.height * 0.5660414,
        size.width * 0.4865591,
        size.height * 0.5660414);
    path_17.cubicTo(
        size.width * 0.5125524,
        size.height * 0.5660414,
        size.width * 0.5386567,
        size.height * 0.5582972,
        size.width * 0.5586640,
        size.height * 0.5426593);
    path_17.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5282359,
        size.width * 0.5873012,
        size.height * 0.5094828,
        size.width * 0.5887884,
        size.height * 0.4901428);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4901428);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4875566);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4498110);
    path_17.lineTo(size.width * 0.5890683, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.5867817, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.5770561, size.height * 0.4472248);
    path_17.cubicTo(
        size.width * 0.5723134,
        size.height * 0.4401697,
        size.width * 0.5661738,
        size.height * 0.4335862,
        size.width * 0.5586640,
        size.height * 0.4277166);
    path_17.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4120779,
        size.width * 0.5125524,
        size.height * 0.4043338,
        size.width * 0.4865591,
        size.height * 0.4043338);
    path_17.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4043338,
        size.width * 0.4344610,
        size.height * 0.4120779,
        size.width * 0.4144537,
        size.height * 0.4277166);
    path_17.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4335862,
        size.width * 0.4008049,
        size.height * 0.4401697,
        size.width * 0.3960616,
        size.height * 0.4472248);
    path_17.lineTo(size.width * 0.3864207, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4472248);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4498110);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4875566);
    path_17.lineTo(size.width * 0.3841341, size.height * 0.4901428);
    path_17.close();

    Paint paint_17_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_17_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_stroke);

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.4144494, size.height * 0.5128469);
    path_18.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5284855,
        size.width * 0.4605610,
        size.height * 0.5362297,
        size.width * 0.4865543,
        size.height * 0.5362297);
    path_18.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5362297,
        size.width * 0.5386524,
        size.height * 0.5284855,
        size.width * 0.5586598,
        size.height * 0.5128469);
    path_18.cubicTo(
        size.width * 0.5786890,
        size.height * 0.4971917,
        size.width * 0.5889744,
        size.height * 0.4764324,
        size.width * 0.5889744,
        size.height * 0.4553759);
    path_18.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4343186,
        size.width * 0.5786890,
        size.height * 0.4135600,
        size.width * 0.5586598,
        size.height * 0.3979048);
    path_18.cubicTo(
        size.width * 0.5386524,
        size.height * 0.3822662,
        size.width * 0.5125482,
        size.height * 0.3745221,
        size.width * 0.4865543,
        size.height * 0.3745221);
    path_18.cubicTo(
        size.width * 0.4605610,
        size.height * 0.3745221,
        size.width * 0.4344567,
        size.height * 0.3822662,
        size.width * 0.4144494,
        size.height * 0.3979048);
    path_18.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4135600,
        size.width * 0.3841341,
        size.height * 0.4343193,
        size.width * 0.3841341,
        size.height * 0.4553759);
    path_18.cubicTo(
        size.width * 0.3841341,
        size.height * 0.4764324,
        size.width * 0.3944201,
        size.height * 0.4971917,
        size.width * 0.4144494,
        size.height * 0.5128469);
    path_18.close();

    Paint paint_18_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_18_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_stroke);

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(size.width * 0.4370348, size.height * 0.4951924);
    path_19.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5059559,
        size.width * 0.4687348,
        size.height * 0.5112621,
        size.width * 0.4865537,
        size.height * 0.5112621);
    path_19.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5112621,
        size.width * 0.5223018,
        size.height * 0.5059559,
        size.width * 0.5360720,
        size.height * 0.4951924);
    path_19.cubicTo(
        size.width * 0.5498646,
        size.height * 0.4844117,
        size.width * 0.5570317,
        size.height * 0.4700428,
        size.width * 0.5570317,
        size.height * 0.4553752);
    path_19.cubicTo(
        size.width * 0.5570317,
        size.height * 0.4407083,
        size.width * 0.5498646,
        size.height * 0.4263386,
        size.width * 0.5360720,
        size.height * 0.4155579);
    path_19.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4047952,
        size.width * 0.5043726,
        size.height * 0.3994883,
        size.width * 0.4865537,
        size.height * 0.3994883);
    path_19.cubicTo(
        size.width * 0.4687348,
        size.height * 0.3994883,
        size.width * 0.4508049,
        size.height * 0.4047952,
        size.width * 0.4370348,
        size.height * 0.4155579);
    path_19.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4263386,
        size.width * 0.4160750,
        size.height * 0.4407083,
        size.width * 0.4160750,
        size.height * 0.4553752);
    path_19.cubicTo(
        size.width * 0.4160750,
        size.height * 0.4700428,
        size.width * 0.4232427,
        size.height * 0.4844117,
        size.width * 0.4370348,
        size.height * 0.4951924);
    path_19.close();

    Paint paint_19_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_19_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_stroke);

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.5186683, size.height * 0.4083393);
    path_20.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4003503,
        size.width * 0.4644470,
        size.height * 0.4042069,
        size.width * 0.4443573,
        size.height * 0.4199097);
    path_20.cubicTo(
        size.width * 0.4177262,
        size.height * 0.4407248,
        size.width * 0.4177262,
        size.height * 0.4744731,
        size.width * 0.4443573,
        size.height * 0.4952883);
    path_20.cubicTo(
        size.width * 0.4492372,
        size.height * 0.4991028,
        size.width * 0.4546732,
        size.height * 0.5022186,
        size.width * 0.4604610,
        size.height * 0.5046352);
    path_20.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5020338,
        size.width * 0.4448756,
        size.height * 0.4981772,
        size.width * 0.4383348,
        size.height * 0.4930648);
    path_20.cubicTo(
        size.width * 0.4117043,
        size.height * 0.4722497,
        size.width * 0.4117043,
        size.height * 0.4385014,
        size.width * 0.4383348,
        size.height * 0.4176855);
    path_20.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4006848,
        size.width * 0.4928726,
        size.height * 0.3975697,
        size.width * 0.5186683,
        size.height * 0.4083393);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.3589817, size.height * 0.4509676);
    path_21.lineTo(size.width * 0.3591768, size.height * 0.4509676);
    path_21.cubicTo(
        size.width * 0.3606646,
        size.height * 0.4703076,
        size.width * 0.3708488,
        size.height * 0.4890607,
        size.width * 0.3893012,
        size.height * 0.5034834);
    path_21.cubicTo(
        size.width * 0.4093085,
        size.height * 0.5191221,
        size.width * 0.4354128,
        size.height * 0.5268662,
        size.width * 0.4614067,
        size.height * 0.5268662);
    path_21.cubicTo(
        size.width * 0.4874000,
        size.height * 0.5268662,
        size.width * 0.5135043,
        size.height * 0.5191221,
        size.width * 0.5335116,
        size.height * 0.5034834);
    path_21.cubicTo(
        size.width * 0.5519640,
        size.height * 0.4890607,
        size.width * 0.5621488,
        size.height * 0.4703076,
        size.width * 0.5636360,
        size.height * 0.4509676);
    path_21.lineTo(size.width * 0.5639159, size.height * 0.4509676);
    path_21.lineTo(size.width * 0.5639159, size.height * 0.4483814);
    path_21.lineTo(size.width * 0.5639159, size.height * 0.4106352);
    path_21.lineTo(size.width * 0.5639159, size.height * 0.4080490);
    path_21.lineTo(size.width * 0.5616293, size.height * 0.4080490);
    path_21.lineTo(size.width * 0.5519037, size.height * 0.4080490);
    path_21.cubicTo(
        size.width * 0.5471610,
        size.height * 0.4009945,
        size.width * 0.5410213,
        size.height * 0.3944110,
        size.width * 0.5335116,
        size.height * 0.3885414);
    path_21.cubicTo(
        size.width * 0.5135043,
        size.height * 0.3729028,
        size.width * 0.4874000,
        size.height * 0.3651586,
        size.width * 0.4614067,
        size.height * 0.3651586);
    path_21.cubicTo(
        size.width * 0.4354128,
        size.height * 0.3651586,
        size.width * 0.4093085,
        size.height * 0.3729028,
        size.width * 0.3893012,
        size.height * 0.3885414);
    path_21.cubicTo(
        size.width * 0.3817915,
        size.height * 0.3944110,
        size.width * 0.3756524,
        size.height * 0.4009945,
        size.width * 0.3709091,
        size.height * 0.4080490);
    path_21.lineTo(size.width * 0.3612683, size.height * 0.4080490);
    path_21.lineTo(size.width * 0.3589817, size.height * 0.4080490);
    path_21.lineTo(size.width * 0.3589817, size.height * 0.4106352);
    path_21.lineTo(size.width * 0.3589817, size.height * 0.4483814);
    path_21.lineTo(size.width * 0.3589817, size.height * 0.4509676);
    path_21.close();

    Paint paint_21_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_21_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_stroke);

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.3892970, size.height * 0.4736717);
    path_22.cubicTo(
        size.width * 0.4093043,
        size.height * 0.4893097,
        size.width * 0.4354085,
        size.height * 0.4970545,
        size.width * 0.4614018,
        size.height * 0.4970545);
    path_22.cubicTo(
        size.width * 0.4873957,
        size.height * 0.4970545,
        size.width * 0.5135000,
        size.height * 0.4893097,
        size.width * 0.5335073,
        size.height * 0.4736717);
    path_22.cubicTo(
        size.width * 0.5535366,
        size.height * 0.4580159,
        size.width * 0.5638220,
        size.height * 0.4372572,
        size.width * 0.5638220,
        size.height * 0.4162007);
    path_22.cubicTo(
        size.width * 0.5638220,
        size.height * 0.3951434,
        size.width * 0.5535366,
        size.height * 0.3743848,
        size.width * 0.5335073,
        size.height * 0.3587290);
    path_22.cubicTo(
        size.width * 0.5135000,
        size.height * 0.3430910,
        size.width * 0.4873957,
        size.height * 0.3353462,
        size.width * 0.4614018,
        size.height * 0.3353462);
    path_22.cubicTo(
        size.width * 0.4354085,
        size.height * 0.3353462,
        size.width * 0.4093043,
        size.height * 0.3430910,
        size.width * 0.3892970,
        size.height * 0.3587290);
    path_22.cubicTo(
        size.width * 0.3692677,
        size.height * 0.3743848,
        size.width * 0.3589817,
        size.height * 0.3951434,
        size.width * 0.3589817,
        size.height * 0.4162007);
    path_22.cubicTo(
        size.width * 0.3589817,
        size.height * 0.4372572,
        size.width * 0.3692677,
        size.height * 0.4580159,
        size.width * 0.3892970,
        size.height * 0.4736717);
    path_22.close();

    Paint paint_22_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_22_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_stroke);

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(size.width * 0.4118823, size.height * 0.4560172);
    path_23.cubicTo(
        size.width * 0.4256524,
        size.height * 0.4667800,
        size.width * 0.4435823,
        size.height * 0.4720869,
        size.width * 0.4614012,
        size.height * 0.4720869);
    path_23.cubicTo(
        size.width * 0.4792201,
        size.height * 0.4720869,
        size.width * 0.4971494,
        size.height * 0.4667800,
        size.width * 0.5109195,
        size.height * 0.4560172);
    path_23.cubicTo(
        size.width * 0.5247122,
        size.height * 0.4452366,
        size.width * 0.5318793,
        size.height * 0.4308669,
        size.width * 0.5318793,
        size.height * 0.4162000);
    path_23.cubicTo(
        size.width * 0.5318793,
        size.height * 0.4015324,
        size.width * 0.5247122,
        size.height * 0.3871634,
        size.width * 0.5109195,
        size.height * 0.3763828);
    path_23.cubicTo(
        size.width * 0.4971494,
        size.height * 0.3656193,
        size.width * 0.4792201,
        size.height * 0.3603131,
        size.width * 0.4614012,
        size.height * 0.3603131);
    path_23.cubicTo(
        size.width * 0.4435823,
        size.height * 0.3603131,
        size.width * 0.4256524,
        size.height * 0.3656193,
        size.width * 0.4118823,
        size.height * 0.3763828);
    path_23.cubicTo(
        size.width * 0.3980902,
        size.height * 0.3871634,
        size.width * 0.3909226,
        size.height * 0.4015324,
        size.width * 0.3909226,
        size.height * 0.4162000);
    path_23.cubicTo(
        size.width * 0.3909226,
        size.height * 0.4308669,
        size.width * 0.3980902,
        size.height * 0.4452366,
        size.width * 0.4118823,
        size.height * 0.4560172);
    path_23.close();

    Paint paint_23_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_23_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_stroke);

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(size.width * 0.4935159, size.height * 0.3691641);
    path_24.cubicTo(
        size.width * 0.4688006,
        size.height * 0.3611745,
        size.width * 0.4392945,
        size.height * 0.3650317,
        size.width * 0.4192049,
        size.height * 0.3807345);
    path_24.cubicTo(
        size.width * 0.3925738,
        size.height * 0.4015497,
        size.width * 0.3925738,
        size.height * 0.4352979,
        size.width * 0.4192049,
        size.height * 0.4561131);
    path_24.cubicTo(
        size.width * 0.4240848,
        size.height * 0.4599276,
        size.width * 0.4295207,
        size.height * 0.4630434,
        size.width * 0.4353085,
        size.height * 0.4654600);
    path_24.cubicTo(
        size.width * 0.4272622,
        size.height * 0.4628586,
        size.width * 0.4197232,
        size.height * 0.4590021,
        size.width * 0.4131823,
        size.height * 0.4538897);
    path_24.cubicTo(
        size.width * 0.3865518,
        size.height * 0.4330738,
        size.width * 0.3865518,
        size.height * 0.3993255,
        size.width * 0.4131823,
        size.height * 0.3785103);
    path_24.cubicTo(
        size.width * 0.4349323,
        size.height * 0.3615097,
        size.width * 0.4677201,
        size.height * 0.3583945,
        size.width * 0.4935159,
        size.height * 0.3691641);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(size.width * 0.7744024, size.height * 0.2241372);
    path_25.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2138345,
        size.width * 0.7798110,
        size.height * 0.2031117,
        size.width * 0.7798110,
        size.height * 0.1921007);
    path_25.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1124841,
        size.width * 0.6821220,
        size.height * 0.04794248,
        size.width * 0.5616250,
        size.height * 0.04794248);
    path_25.cubicTo(
        size.width * 0.4411250,
        size.height * 0.04794248,
        size.width * 0.3434402,
        size.height * 0.1124841,
        size.width * 0.3434402,
        size.height * 0.1921007);
    path_25.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2031110,
        size.width * 0.3453085,
        size.height * 0.2138331,
        size.width * 0.3488470,
        size.height * 0.2241359);
    path_25.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1599379,
        size.width * 0.4577890,
        size.height * 0.1120138,
        size.width * 0.5616244,
        size.height * 0.1120138);
    path_25.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1120138,
        size.width * 0.7523537,
        size.height * 0.1599393,
        size.width * 0.7744024,
        size.height * 0.2241372);
    path_25.close();

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(size.width * 0.3293390, size.height * 0.2071000);
    path_26.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2182041,
        size.width * 0.3235116,
        size.height * 0.2297593,
        size.width * 0.3235116,
        size.height * 0.2416255);
    path_26.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3274269,
        size.width * 0.4287841,
        size.height * 0.3969828,
        size.width * 0.5586451,
        size.height * 0.3969828);
    path_26.cubicTo(
        size.width * 0.6885061,
        size.height * 0.3969828,
        size.width * 0.7937805,
        size.height * 0.3274269,
        size.width * 0.7937805,
        size.height * 0.2416255);
    path_26.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2297600,
        size.width * 0.7917683,
        size.height * 0.2182055,
        size.width * 0.7879512,
        size.height * 0.2071021);
    path_26.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2762869,
        size.width * 0.6705488,
        size.height * 0.3279338,
        size.width * 0.5586457,
        size.height * 0.3279338);
    path_26.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3279338,
        size.width * 0.3530988,
        size.height * 0.2762855,
        size.width * 0.3293390,
        size.height * 0.2071000);
    path_26.close();

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(size.width * 0.3171738, size.height * 0.2219545);
    path_27.cubicTo(
        size.width * 0.3169957,
        size.height * 0.2246041,
        size.width * 0.3169055,
        size.height * 0.2272697,
        size.width * 0.3169055,
        size.height * 0.2299497);
    path_27.cubicTo(
        size.width * 0.3169055,
        size.height * 0.3228393,
        size.width * 0.4249634,
        size.height * 0.3981414,
        size.width * 0.5582598,
        size.height * 0.3981414);
    path_27.cubicTo(
        size.width * 0.6915549,
        size.height * 0.3981414,
        size.width * 0.7996159,
        size.height * 0.3228393,
        size.width * 0.7996159,
        size.height * 0.2299497);
    path_27.cubicTo(
        size.width * 0.7996159,
        size.height * 0.2272697,
        size.width * 0.7995244,
        size.height * 0.2246041,
        size.width * 0.7993476,
        size.height * 0.2219545);
    path_27.cubicTo(
        size.width * 0.7933598,
        size.height * 0.3135621,
        size.width * 0.6877073,
        size.height * 0.3865172,
        size.width * 0.5582598,
        size.height * 0.3865172);
    path_27.cubicTo(
        size.width * 0.4288098,
        size.height * 0.3865172,
        size.width * 0.3231628,
        size.height * 0.3135621,
        size.width * 0.3171738,
        size.height * 0.2219545);
    path_27.close();

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(size.width * 0.3171738, size.height * 0.2219545);
    path_28.cubicTo(
        size.width * 0.3169957,
        size.height * 0.2246041,
        size.width * 0.3169055,
        size.height * 0.2272697,
        size.width * 0.3169055,
        size.height * 0.2299497);
    path_28.cubicTo(
        size.width * 0.3169055,
        size.height * 0.3228393,
        size.width * 0.4249634,
        size.height * 0.3981414,
        size.width * 0.5582598,
        size.height * 0.3981414);
    path_28.cubicTo(
        size.width * 0.6915549,
        size.height * 0.3981414,
        size.width * 0.7996159,
        size.height * 0.3228393,
        size.width * 0.7996159,
        size.height * 0.2299497);
    path_28.cubicTo(
        size.width * 0.7996159,
        size.height * 0.2272697,
        size.width * 0.7995244,
        size.height * 0.2246041,
        size.width * 0.7993476,
        size.height * 0.2219545);
    path_28.cubicTo(
        size.width * 0.7933598,
        size.height * 0.3135621,
        size.width * 0.6877073,
        size.height * 0.3865172,
        size.width * 0.5582598,
        size.height * 0.3865172);
    path_28.cubicTo(
        size.width * 0.4288098,
        size.height * 0.3865172,
        size.width * 0.3231628,
        size.height * 0.3135621,
        size.width * 0.3171738,
        size.height * 0.2219545);
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);

    Path path_29 = Path();
    path_29.moveTo(size.width * 0.3171738, size.height * 0.2219545);
    path_29.lineTo(size.width * 0.3232543, size.height * 0.2214455);
    path_29.lineTo(size.width * 0.3110933, size.height * 0.2214317);
    path_29.lineTo(size.width * 0.3171738, size.height * 0.2219545);
    path_29.close();
    path_29.moveTo(size.width * 0.7993476, size.height * 0.2219545);
    path_29.lineTo(size.width * 0.8054268, size.height * 0.2214317);
    path_29.lineTo(size.width * 0.7932683, size.height * 0.2214455);
    path_29.lineTo(size.width * 0.7993476, size.height * 0.2219545);
    path_29.close();
    path_29.moveTo(size.width * 0.5582598, size.height * 0.3865172);
    path_29.lineTo(size.width * 0.5582598, size.height * 0.3796207);
    path_29.lineTo(size.width * 0.5582598, size.height * 0.3865172);
    path_29.close();
    path_29.moveTo(size.width * 0.3230030, size.height * 0.2299497);
    path_29.cubicTo(
        size.width * 0.3230030,
        size.height * 0.2274441,
        size.width * 0.3230872,
        size.height * 0.2249531,
        size.width * 0.3232537,
        size.height * 0.2224766);
    path_29.lineTo(size.width * 0.3110933, size.height * 0.2214317);
    path_29.cubicTo(
        size.width * 0.3109037,
        size.height * 0.2242552,
        size.width * 0.3108079,
        size.height * 0.2270945,
        size.width * 0.3108079,
        size.height * 0.2299497);
    path_29.lineTo(size.width * 0.3230030, size.height * 0.2299497);
    path_29.close();
    path_29.moveTo(size.width * 0.5582598, size.height * 0.3912448);
    path_29.cubicTo(
        size.width * 0.4925555,
        size.height * 0.3912448,
        size.width * 0.4333634,
        size.height * 0.3726717,
        size.width * 0.3907951,
        size.height * 0.3430076);
    path_29.cubicTo(
        size.width * 0.3481293,
        size.height * 0.3132752,
        size.width * 0.3230030,
        size.height * 0.2731103,
        size.width * 0.3230030,
        size.height * 0.2299497);
    path_29.lineTo(size.width * 0.3108079, size.height * 0.2299497);
    path_29.cubicTo(
        size.width * 0.3108079,
        size.height * 0.2796786,
        size.width * 0.3397110,
        size.height * 0.3236097,
        size.width * 0.3843982,
        size.height * 0.3547503);
    path_29.cubicTo(
        size.width * 0.4291829,
        size.height * 0.3859593,
        size.width * 0.4906677,
        size.height * 0.4050379,
        size.width * 0.5582598,
        size.height * 0.4050379);
    path_29.lineTo(size.width * 0.5582598, size.height * 0.3912448);
    path_29.close();
    path_29.moveTo(size.width * 0.7935183, size.height * 0.2299497);
    path_29.cubicTo(
        size.width * 0.7935183,
        size.height * 0.2731103,
        size.width * 0.7683902,
        size.height * 0.3132752,
        size.width * 0.7257256,
        size.height * 0.3430076);
    path_29.cubicTo(
        size.width * 0.6831585,
        size.height * 0.3726717,
        size.width * 0.6239634,
        size.height * 0.3912448,
        size.width * 0.5582598,
        size.height * 0.3912448);
    path_29.lineTo(size.width * 0.5582598, size.height * 0.4050379);
    path_29.cubicTo(
        size.width * 0.6258537,
        size.height * 0.4050379,
        size.width * 0.6873354,
        size.height * 0.3859593,
        size.width * 0.7321220,
        size.height * 0.3547503);
    path_29.cubicTo(
        size.width * 0.7768110,
        size.height * 0.3236097,
        size.width * 0.8057134,
        size.height * 0.2796786,
        size.width * 0.8057134,
        size.height * 0.2299497);
    path_29.lineTo(size.width * 0.7935183, size.height * 0.2299497);
    path_29.close();
    path_29.moveTo(size.width * 0.7932683, size.height * 0.2224766);
    path_29.cubicTo(
        size.width * 0.7934329,
        size.height * 0.2249531,
        size.width * 0.7935183,
        size.height * 0.2274441,
        size.width * 0.7935183,
        size.height * 0.2299497);
    path_29.lineTo(size.width * 0.8057134, size.height * 0.2299497);
    path_29.cubicTo(
        size.width * 0.8057134,
        size.height * 0.2270952,
        size.width * 0.8056159,
        size.height * 0.2242552,
        size.width * 0.8054268,
        size.height * 0.2214317);
    path_29.lineTo(size.width * 0.7932683, size.height * 0.2224766);
    path_29.close();
    path_29.moveTo(size.width * 0.7932683, size.height * 0.2214455);
    path_29.cubicTo(
        size.width * 0.7904695,
        size.height * 0.2642455,
        size.width * 0.7642866,
        size.height * 0.3036821,
        size.width * 0.7219451,
        size.height * 0.3326897);
    path_29.cubicTo(
        size.width * 0.6796829,
        size.height * 0.3616386,
        size.width * 0.6220305,
        size.height * 0.3796207,
        size.width * 0.5582598,
        size.height * 0.3796207);
    path_29.lineTo(size.width * 0.5582598, size.height * 0.3934138);
    path_29.cubicTo(
        size.width * 0.6239390,
        size.height * 0.3934138,
        size.width * 0.6838354,
        size.height * 0.3749193,
        size.width * 0.7282622,
        size.height * 0.3444876);
    path_29.cubicTo(
        size.width * 0.7725976,
        size.height * 0.3141166,
        size.width * 0.8022378,
        size.height * 0.2712710,
        size.width * 0.8054268,
        size.height * 0.2224628);
    path_29.lineTo(size.width * 0.7932683, size.height * 0.2214455);
    path_29.close();
    path_29.moveTo(size.width * 0.5582598, size.height * 0.3796207);
    path_29.cubicTo(
        size.width * 0.4944866,
        size.height * 0.3796207,
        size.width * 0.4368372,
        size.height * 0.3616386,
        size.width * 0.3945774,
        size.height * 0.3326897);
    path_29.cubicTo(
        size.width * 0.3522311,
        size.height * 0.3036821,
        size.width * 0.3260524,
        size.height * 0.2642455,
        size.width * 0.3232543,
        size.height * 0.2214455);
    path_29.lineTo(size.width * 0.3110927, size.height * 0.2224628);
    path_29.cubicTo(
        size.width * 0.3142835,
        size.height * 0.2712710,
        size.width * 0.3439232,
        size.height * 0.3141159,
        size.width * 0.3882598,
        size.height * 0.3444876);
    path_29.cubicTo(
        size.width * 0.4326841,
        size.height * 0.3749193,
        size.width * 0.4925829,
        size.height * 0.3934138,
        size.width * 0.5582598,
        size.height * 0.3934138);
    path_29.lineTo(size.width * 0.5582598, size.height * 0.3796207);
    path_29.close();

    Paint paint_29_fill = Paint()..style = PaintingStyle.fill;
    paint_29_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_fill);

    Path path_30 = Path();
    path_30.moveTo(size.width * 0.7796707, size.height * 0.1913793);
    path_30.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2300317,
        size.width * 0.7558537,
        size.height * 0.2656938,
        size.width * 0.7160671,
        size.height * 0.2918931);
    path_30.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3180400,
        size.width * 0.6212927,
        size.height * 0.3343283,
        size.width * 0.5602970,
        size.height * 0.3343283);
    path_30.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3343283,
        size.width * 0.4442335,
        size.height * 0.3180400,
        size.width * 0.4045250,
        size.height * 0.2918931);
    path_30.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2656938,
        size.width * 0.3409213,
        size.height * 0.2300317,
        size.width * 0.3409213,
        size.height * 0.1913793);
    path_30.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1527269,
        size.width * 0.3647378,
        size.height * 0.1170648,
        size.width * 0.4045250,
        size.height * 0.09086552);
    path_30.cubicTo(
        size.width * 0.4442335,
        size.height * 0.06471834,
        size.width * 0.4993000,
        size.height * 0.04843062,
        size.width * 0.5602970,
        size.height * 0.04843062);
    path_30.cubicTo(
        size.width * 0.6212927,
        size.height * 0.04843062,
        size.width * 0.6763598,
        size.height * 0.06471834,
        size.width * 0.7160671,
        size.height * 0.09086552);
    path_30.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1170648,
        size.width * 0.7796707,
        size.height * 0.1527269,
        size.width * 0.7796707,
        size.height * 0.1913793);
    path_30.close();

    Paint paint_30_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_30_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_stroke);

    Paint paint_30_fill = Paint()..style = PaintingStyle.fill;
    paint_30_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 6
class WinPrizeClaimAsset6 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6776366),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6714021),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2729986,
        size.width * 0.3100006,
        size.height * 0.2467310,
        size.width * 0.3226079,
        size.height * 0.2426034);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2080717);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1773372,
        size.width * 0.3263305,
        size.height * 0.1454572,
        size.width * 0.3437433,
        size.height * 0.1218614);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.05412041,
        size.width * 0.4950689,
        size.height * 0.02758621,
        size.width * 0.5575037,
        size.height * 0.02758621);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.02758621,
        size.width * 0.7592073,
        size.height * 0.08968069,
        size.width * 0.7860122,
        size.height * 0.1389848);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1593966,
        size.width * 0.7993659,
        size.height * 0.1838607,
        size.width * 0.7993659,
        size.height * 0.2078221);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2426034);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2741241,
        size.width * 0.8385183,
        size.height * 0.3180283,
        size.width * 0.8361951,
        size.height * 0.3360400);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6399910);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.6970276,
        size.width * 0.7394512,
        size.height * 0.8084000,
        size.width * 0.5475506,
        size.height * 0.7975931);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.7867862,
        size.width * 0.2890988,
        size.height * 0.6880228,
        size.width * 0.2798091,
        size.height * 0.6399910);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.5887262),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5768939, size.height * 0.5780490),
            width: size.width * 0.3446463,
            height: size.height * 0.2379876),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3687598, size.height * 0.5924579);
    path_5.lineTo(size.width * 0.3689591, size.height * 0.5924579);
    path_5.cubicTo(
        size.width * 0.3704841,
        size.height * 0.6118234,
        size.width * 0.3809341,
        size.height * 0.6305779,
        size.width * 0.3998354,
        size.height * 0.6449910);
    path_5.cubicTo(
        size.width * 0.4203299,
        size.height * 0.6606186,
        size.width * 0.4470683,
        size.height * 0.6683566,
        size.width * 0.4736927,
        size.height * 0.6683566);
    path_5.cubicTo(
        size.width * 0.5003171,
        size.height * 0.6683566,
        size.width * 0.5270555,
        size.height * 0.6606186,
        size.width * 0.5475500,
        size.height * 0.6449910);
    path_5.cubicTo(
        size.width * 0.5664512,
        size.height * 0.6305779,
        size.width * 0.5769012,
        size.height * 0.6118234,
        size.width * 0.5784262,
        size.height * 0.5924579);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5924579);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5898717);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5521255);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5495393);
    path_5.lineTo(size.width * 0.5764256, size.height * 0.5495393);
    path_5.lineTo(size.width * 0.5664116, size.height * 0.5495393);
    path_5.cubicTo(
        size.width * 0.5615482,
        size.height * 0.5424766,
        size.width * 0.5552518,
        size.height * 0.5358876,
        size.width * 0.5475500,
        size.height * 0.5300152);
    path_5.cubicTo(
        size.width * 0.5270555,
        size.height * 0.5143876,
        size.width * 0.5003171,
        size.height * 0.5066490,
        size.width * 0.4736927,
        size.height * 0.5066490);
    path_5.cubicTo(
        size.width * 0.4470683,
        size.height * 0.5066490,
        size.width * 0.4203299,
        size.height * 0.5143876,
        size.width * 0.3998354,
        size.height * 0.5300152);
    path_5.cubicTo(
        size.width * 0.3921335,
        size.height * 0.5358876,
        size.width * 0.3858372,
        size.height * 0.5424766,
        size.width * 0.3809738,
        size.height * 0.5495393);
    path_5.lineTo(size.width * 0.3710463, size.height * 0.5495393);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5495393);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5521255);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5898717);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5924579);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3998427, size.height * 0.6151752);
    path_6.cubicTo(
        size.width * 0.4203372,
        size.height * 0.6308034,
        size.width * 0.4470756,
        size.height * 0.6385414,
        size.width * 0.4737000,
        size.height * 0.6385414);
    path_6.cubicTo(
        size.width * 0.5003244,
        size.height * 0.6385414,
        size.width * 0.5270628,
        size.height * 0.6308034,
        size.width * 0.5475573,
        size.height * 0.6151752);
    path_6.cubicTo(
        size.width * 0.5680713,
        size.height * 0.5995331,
        size.width * 0.5786287,
        size.height * 0.5787738,
        size.width * 0.5786287,
        size.height * 0.5576876);
    path_6.cubicTo(
        size.width * 0.5786287,
        size.height * 0.5366014,
        size.width * 0.5680713,
        size.height * 0.5158421,
        size.width * 0.5475573,
        size.height * 0.5001993);
    path_6.cubicTo(
        size.width * 0.5270628,
        size.height * 0.4845717,
        size.width * 0.5003244,
        size.height * 0.4768338,
        size.width * 0.4737000,
        size.height * 0.4768338);
    path_6.cubicTo(
        size.width * 0.4470756,
        size.height * 0.4768338,
        size.width * 0.4203372,
        size.height * 0.4845717,
        size.width * 0.3998427,
        size.height * 0.5001993);
    path_6.cubicTo(
        size.width * 0.3793287,
        size.height * 0.5158421,
        size.width * 0.3687713,
        size.height * 0.5366014,
        size.width * 0.3687713,
        size.height * 0.5576876);
    path_6.cubicTo(
        size.width * 0.3687713,
        size.height * 0.5787738,
        size.width * 0.3793287,
        size.height * 0.5995331,
        size.width * 0.3998427,
        size.height * 0.6151752);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_6_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4229915, size.height * 0.5975228);
    path_7.cubicTo(
        size.width * 0.4370927,
        size.height * 0.6082752,
        size.width * 0.4554518,
        size.height * 0.6135759,
        size.width * 0.4736970,
        size.height * 0.6135759);
    path_7.cubicTo(
        size.width * 0.4919415,
        size.height * 0.6135759,
        size.width * 0.5103006,
        size.height * 0.6082752,
        size.width * 0.5244018,
        size.height * 0.5975228);
    path_7.cubicTo(
        size.width * 0.5385226,
        size.height * 0.5867552,
        size.width * 0.5458835,
        size.height * 0.5723848,
        size.width * 0.5458835,
        size.height * 0.5576890);
    path_7.cubicTo(
        size.width * 0.5458835,
        size.height * 0.5429924,
        size.width * 0.5385226,
        size.height * 0.5286228,
        size.width * 0.5244018,
        size.height * 0.5178552);
    path_7.cubicTo(
        size.width * 0.5103006,
        size.height * 0.5071021,
        size.width * 0.4919415,
        size.height * 0.5018014,
        size.width * 0.4736970,
        size.height * 0.5018014);
    path_7.cubicTo(
        size.width * 0.4554518,
        size.height * 0.5018014,
        size.width * 0.4370927,
        size.height * 0.5071021,
        size.width * 0.4229915,
        size.height * 0.5178552);
    path_7.cubicTo(
        size.width * 0.4088707,
        size.height * 0.5286228,
        size.width * 0.4015104,
        size.height * 0.5429924,
        size.width * 0.4015104,
        size.height * 0.5576890);
    path_7.cubicTo(
        size.width * 0.4015104,
        size.height * 0.5723848,
        size.width * 0.4088707,
        size.height * 0.5867552,
        size.width * 0.4229915,
        size.height * 0.5975228);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_7_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.5066159, size.height * 0.5106524);
    path_8.cubicTo(
        size.width * 0.4812817,
        size.height * 0.5026634,
        size.width * 0.4510360,
        size.height * 0.5065200,
        size.width * 0.4304433,
        size.height * 0.5222234);
    path_8.cubicTo(
        size.width * 0.4031457,
        size.height * 0.5430386,
        size.width * 0.4031457,
        size.height * 0.5767869,
        size.width * 0.4304433,
        size.height * 0.5976021);
    path_8.cubicTo(
        size.width * 0.4354457,
        size.height * 0.6014166,
        size.width * 0.4410177,
        size.height * 0.6045317,
        size.width * 0.4469506,
        size.height * 0.6069483);
    path_8.cubicTo(
        size.width * 0.4387024,
        size.height * 0.6043476,
        size.width * 0.4309744,
        size.height * 0.6004903,
        size.width * 0.4242701,
        size.height * 0.5953779);
    path_8.cubicTo(
        size.width * 0.3969726,
        size.height * 0.5745628,
        size.width * 0.3969726,
        size.height * 0.5408145,
        size.width * 0.4242701,
        size.height * 0.5199993);
    path_8.cubicTo(
        size.width * 0.4465652,
        size.height * 0.5029986,
        size.width * 0.4801744,
        size.height * 0.4998828,
        size.width * 0.5066159,
        size.height * 0.5106524);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.5526598, size.height * 0.5388007);
    path_9.cubicTo(
        size.width * 0.5541854,
        size.height * 0.5581662,
        size.width * 0.5646354,
        size.height * 0.5769214,
        size.width * 0.5835366,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.6040311,
        size.height * 0.6069614,
        size.width * 0.6307683,
        size.height * 0.6147000,
        size.width * 0.6573963,
        size.height * 0.6147000);
    path_9.cubicTo(
        size.width * 0.6840183,
        size.height * 0.6147000,
        size.width * 0.7107561,
        size.height * 0.6069614,
        size.width * 0.7312500,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.7501524,
        size.height * 0.5769214,
        size.width * 0.7606037,
        size.height * 0.5581662,
        size.width * 0.7621280,
        size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7601280, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7501098, size.height * 0.4958828);
    path_9.cubicTo(
        size.width * 0.7452500,
        size.height * 0.4888193,
        size.width * 0.7389512,
        size.height * 0.4822310,
        size.width * 0.7312500,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.7107561,
        size.height * 0.4607303,
        size.width * 0.6840183,
        size.height * 0.4529917,
        size.width * 0.6573963,
        size.height * 0.4529917);
    path_9.cubicTo(
        size.width * 0.6307683,
        size.height * 0.4529917,
        size.width * 0.6040311,
        size.height * 0.4607303,
        size.width * 0.5835366,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.5758348,
        size.height * 0.4822310,
        size.width * 0.5695384,
        size.height * 0.4888193,
        size.width * 0.5646744,
        size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5547470, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffB17518).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5835439, size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.6040384,
        size.height * 0.5771476,
        size.width * 0.6307744,
        size.height * 0.5848862,
        size.width * 0.6574024,
        size.height * 0.5848862);
    path_10.cubicTo(
        size.width * 0.6840244,
        size.height * 0.5848862,
        size.width * 0.7107622,
        size.height * 0.5771476,
        size.width * 0.7312561,
        size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.7517744,
        size.height * 0.5458772,
        size.width * 0.7623293,
        size.height * 0.5251179,
        size.width * 0.7623293,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.7623293,
        size.height * 0.4829462,
        size.width * 0.7517744,
        size.height * 0.4621869,
        size.width * 0.7312561,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.7107622,
        size.height * 0.4309166,
        size.width * 0.6840244,
        size.height * 0.4231779,
        size.width * 0.6574024,
        size.height * 0.4231779);
    path_10.cubicTo(
        size.width * 0.6307744,
        size.height * 0.4231779,
        size.width * 0.6040384,
        size.height * 0.4309166,
        size.width * 0.5835439,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.5630299,
        size.height * 0.4621869,
        size.width * 0.5524726,
        size.height * 0.4829462,
        size.width * 0.5524726,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.5524726,
        size.height * 0.5251179,
        size.width * 0.5630299,
        size.height * 0.5458772,
        size.width * 0.5835439,
        size.height * 0.5615200);
    path_10.close();

    Paint paint_10_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_10_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_stroke);

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.6066927, size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.6207927,
        size.height * 0.5546179,
        size.width * 0.6391524,
        size.height * 0.5599186,
        size.width * 0.6573963,
        size.height * 0.5599186);
    path_11.cubicTo(
        size.width * 0.6756402,
        size.height * 0.5599186,
        size.width * 0.6940000,
        size.height * 0.5546179,
        size.width * 0.7081037,
        size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.7222256,
        size.height * 0.5330979,
        size.width * 0.7295854,
        size.height * 0.5187283,
        size.width * 0.7295854,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.7295854,
        size.height * 0.4893352,
        size.width * 0.7222256,
        size.height * 0.4749655,
        size.width * 0.7081037,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.6940000,
        size.height * 0.4534455,
        size.width * 0.6756402,
        size.height * 0.4481448,
        size.width * 0.6573963,
        size.height * 0.4481448);
    path_11.cubicTo(
        size.width * 0.6391524,
        size.height * 0.4481448,
        size.width * 0.6207927,
        size.height * 0.4534455,
        size.width * 0.6066927,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.5925720,
        size.height * 0.4749655,
        size.width * 0.5852110,
        size.height * 0.4893352,
        size.width * 0.5852110,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.5852110,
        size.height * 0.5187283,
        size.width * 0.5925720,
        size.height * 0.5330979,
        size.width * 0.6066927,
        size.height * 0.5438655);
    path_11.close();

    Paint paint_11_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_11_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_stroke);

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.6903171, size.height * 0.4569959);
    path_12.cubicTo(
        size.width * 0.6649817,
        size.height * 0.4490062,
        size.width * 0.6347378,
        size.height * 0.4528634,
        size.width * 0.6141463,
        size.height * 0.4685662);
    path_12.cubicTo(
        size.width * 0.5868463,
        size.height * 0.4893814,
        size.width * 0.5868463,
        size.height * 0.5231297,
        size.width * 0.6141463,
        size.height * 0.5439448);
    path_12.cubicTo(
        size.width * 0.6191463,
        size.height * 0.5477593,
        size.width * 0.6247195,
        size.height * 0.5508752,
        size.width * 0.6306524,
        size.height * 0.5532917);
    path_12.cubicTo(
        size.width * 0.6224024,
        size.height * 0.5506903,
        size.width * 0.6146768,
        size.height * 0.5468338,
        size.width * 0.6079707,
        size.height * 0.5417214);
    path_12.cubicTo(
        size.width * 0.5806732,
        size.height * 0.5209055,
        size.width * 0.5806732,
        size.height * 0.4871572,
        size.width * 0.6079707,
        size.height * 0.4663421);
    path_12.cubicTo(
        size.width * 0.6302683,
        size.height * 0.4493414,
        size.width * 0.6638780,
        size.height * 0.4462262,
        size.width * 0.6903171,
        size.height * 0.4569959);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.5449695, size.height * 0.4958455);
    path_13.lineTo(size.width * 0.5451689, size.height * 0.4958455);
    path_13.cubicTo(
        size.width * 0.5466945,
        size.height * 0.5152110,
        size.width * 0.5571445,
        size.height * 0.5339655,
        size.width * 0.5760457,
        size.height * 0.5483786);
    path_13.cubicTo(
        size.width * 0.5965402,
        size.height * 0.5640062,
        size.width * 0.6232805,
        size.height * 0.5717448,
        size.width * 0.6499024,
        size.height * 0.5717448);
    path_13.cubicTo(
        size.width * 0.6765244,
        size.height * 0.5717448,
        size.width * 0.7032683,
        size.height * 0.5640062,
        size.width * 0.7237622,
        size.height * 0.5483786);
    path_13.cubicTo(
        size.width * 0.7426585,
        size.height * 0.5339655,
        size.width * 0.7531098,
        size.height * 0.5152110,
        size.width * 0.7546341,
        size.height * 0.4958455);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4958455);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4932593);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4555138);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.7526341, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.7426220, size.height * 0.4529276);
    path_13.cubicTo(
        size.width * 0.7377561,
        size.height * 0.4458641,
        size.width * 0.7314634,
        size.height * 0.4392752,
        size.width * 0.7237622,
        size.height * 0.4334028);
    path_13.cubicTo(
        size.width * 0.7032683,
        size.height * 0.4177752,
        size.width * 0.6765244,
        size.height * 0.4100366,
        size.width * 0.6499024,
        size.height * 0.4100366);
    path_13.cubicTo(
        size.width * 0.6232805,
        size.height * 0.4100366,
        size.width * 0.5965402,
        size.height * 0.4177752,
        size.width * 0.5760457,
        size.height * 0.4334028);
    path_13.cubicTo(
        size.width * 0.5683439,
        size.height * 0.4392752,
        size.width * 0.5620476,
        size.height * 0.4458641,
        size.width * 0.5571835,
        size.height * 0.4529276);
    path_13.lineTo(size.width * 0.5472561, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4555138);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4932593);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4958455);
    path_13.close();

    Paint paint_13_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_13_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_stroke);

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffB17518).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.5760530, size.height * 0.5185648);
    path_14.cubicTo(
        size.width * 0.5965476,
        size.height * 0.5341924,
        size.width * 0.6232866,
        size.height * 0.5419310,
        size.width * 0.6499085,
        size.height * 0.5419310);
    path_14.cubicTo(
        size.width * 0.6765366,
        size.height * 0.5419310,
        size.width * 0.7032744,
        size.height * 0.5341924,
        size.width * 0.7237683,
        size.height * 0.5185648);
    path_14.cubicTo(
        size.width * 0.7442805,
        size.height * 0.5029221,
        size.width * 0.7548415,
        size.height * 0.4821628,
        size.width * 0.7548415,
        size.height * 0.4610766);
    path_14.cubicTo(
        size.width * 0.7548415,
        size.height * 0.4399910,
        size.width * 0.7442805,
        size.height * 0.4192317,
        size.width * 0.7237683,
        size.height * 0.4035890);
    path_14.cubicTo(
        size.width * 0.7032744,
        size.height * 0.3879614,
        size.width * 0.6765366,
        size.height * 0.3802228,
        size.width * 0.6499085,
        size.height * 0.3802228);
    path_14.cubicTo(
        size.width * 0.6232866,
        size.height * 0.3802228,
        size.width * 0.5965476,
        size.height * 0.3879614,
        size.width * 0.5760530,
        size.height * 0.4035890);
    path_14.cubicTo(
        size.width * 0.5555390,
        size.height * 0.4192317,
        size.width * 0.5449817,
        size.height * 0.4399910,
        size.width * 0.5449817,
        size.height * 0.4610766);
    path_14.cubicTo(
        size.width * 0.5449817,
        size.height * 0.4821628,
        size.width * 0.5555390,
        size.height * 0.5029221,
        size.width * 0.5760530,
        size.height * 0.5185648);
    path_14.close();

    Paint paint_14_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_14_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_stroke);

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.5992018, size.height * 0.5009103);
    path_15.cubicTo(
        size.width * 0.6133049,
        size.height * 0.5116628,
        size.width * 0.6316585,
        size.height * 0.5169634,
        size.width * 0.6499085,
        size.height * 0.5169634);
    path_15.cubicTo(
        size.width * 0.6681524,
        size.height * 0.5169634,
        size.width * 0.6865122,
        size.height * 0.5116628,
        size.width * 0.7006098,
        size.height * 0.5009103);
    path_15.cubicTo(
        size.width * 0.7147317,
        size.height * 0.4901428,
        size.width * 0.7220915,
        size.height * 0.4757731,
        size.width * 0.7220915,
        size.height * 0.4610766);
    path_15.cubicTo(
        size.width * 0.7220915,
        size.height * 0.4463800,
        size.width * 0.7147317,
        size.height * 0.4320103,
        size.width * 0.7006098,
        size.height * 0.4212428);
    path_15.cubicTo(
        size.width * 0.6865122,
        size.height * 0.4104897,
        size.width * 0.6681524,
        size.height * 0.4051890,
        size.width * 0.6499085,
        size.height * 0.4051890);
    path_15.cubicTo(
        size.width * 0.6316585,
        size.height * 0.4051890,
        size.width * 0.6133049,
        size.height * 0.4104897,
        size.width * 0.5992018,
        size.height * 0.4212428);
    path_15.cubicTo(
        size.width * 0.5850805,
        size.height * 0.4320103,
        size.width * 0.5777201,
        size.height * 0.4463800,
        size.width * 0.5777201,
        size.height * 0.4610766);
    path_15.cubicTo(
        size.width * 0.5777201,
        size.height * 0.4757731,
        size.width * 0.5850805,
        size.height * 0.4901428,
        size.width * 0.5992018,
        size.height * 0.5009103);
    path_15.close();

    Paint paint_15_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_15_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_stroke);

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.6828232, size.height * 0.4140407);
    path_16.cubicTo(
        size.width * 0.6574939,
        size.height * 0.4060510,
        size.width * 0.6272439,
        size.height * 0.4099083,
        size.width * 0.6066530,
        size.height * 0.4256110);
    path_16.cubicTo(
        size.width * 0.5793555,
        size.height * 0.4464262,
        size.width * 0.5793555,
        size.height * 0.4801745,
        size.width * 0.6066530,
        size.height * 0.5009897);
    path_16.cubicTo(
        size.width * 0.6116585,
        size.height * 0.5048041,
        size.width * 0.6172256,
        size.height * 0.5079200,
        size.width * 0.6231585,
        size.height * 0.5103359);
    path_16.cubicTo(
        size.width * 0.6149146,
        size.height * 0.5077352,
        size.width * 0.6071848,
        size.height * 0.5038779,
        size.width * 0.6004799,
        size.height * 0.4987655);
    path_16.cubicTo(
        size.width * 0.5731823,
        size.height * 0.4779503,
        size.width * 0.5731823,
        size.height * 0.4442021,
        size.width * 0.6004799,
        size.height * 0.4233869);
    path_16.cubicTo(
        size.width * 0.6227744,
        size.height * 0.4063862,
        size.width * 0.6563841,
        size.height * 0.4032703,
        size.width * 0.6828232,
        size.height * 0.4140407);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.5328341, size.height * 0.4326621);
    path_17.lineTo(size.width * 0.5330335, size.height * 0.4326621);
    path_17.cubicTo(
        size.width * 0.5345585,
        size.height * 0.4520276,
        size.width * 0.5450085,
        size.height * 0.4707821,
        size.width * 0.5639098,
        size.height * 0.4851952);
    path_17.cubicTo(
        size.width * 0.5844043,
        size.height * 0.5008228,
        size.width * 0.6111402,
        size.height * 0.5085607,
        size.width * 0.6377683,
        size.height * 0.5085607);
    path_17.cubicTo(
        size.width * 0.6643902,
        size.height * 0.5085607,
        size.width * 0.6911280,
        size.height * 0.5008228,
        size.width * 0.7116220,
        size.height * 0.4851952);
    path_17.cubicTo(
        size.width * 0.7305244,
        size.height * 0.4707821,
        size.width * 0.7409756,
        size.height * 0.4520276,
        size.width * 0.7425000,
        size.height * 0.4326621);
    path_17.lineTo(size.width * 0.7427866, size.height * 0.4326621);
    path_17.lineTo(size.width * 0.7427866, size.height * 0.4300759);
    path_17.lineTo(size.width * 0.7427866, size.height * 0.3923297);
    path_17.lineTo(size.width * 0.7427866, size.height * 0.3897434);
    path_17.lineTo(size.width * 0.7405000, size.height * 0.3897434);
    path_17.lineTo(size.width * 0.7304878, size.height * 0.3897434);
    path_17.cubicTo(
        size.width * 0.7256220,
        size.height * 0.3826807,
        size.width * 0.7193232,
        size.height * 0.3760917,
        size.width * 0.7116220,
        size.height * 0.3702193);
    path_17.cubicTo(
        size.width * 0.6911280,
        size.height * 0.3545910,
        size.width * 0.6643902,
        size.height * 0.3468531,
        size.width * 0.6377683,
        size.height * 0.3468531);
    path_17.cubicTo(
        size.width * 0.6111402,
        size.height * 0.3468531,
        size.width * 0.5844043,
        size.height * 0.3545910,
        size.width * 0.5639098,
        size.height * 0.3702193);
    path_17.cubicTo(
        size.width * 0.5562079,
        size.height * 0.3760917,
        size.width * 0.5499116,
        size.height * 0.3826807,
        size.width * 0.5450482,
        size.height * 0.3897434);
    path_17.lineTo(size.width * 0.5351207, size.height * 0.3897434);
    path_17.lineTo(size.width * 0.5328341, size.height * 0.3897434);
    path_17.lineTo(size.width * 0.5328341, size.height * 0.3923297);
    path_17.lineTo(size.width * 0.5328341, size.height * 0.4300759);
    path_17.lineTo(size.width * 0.5328341, size.height * 0.4326621);
    path_17.close();

    Paint paint_17_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_17_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_stroke);

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xffB17518).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.5639171, size.height * 0.4553814);
    path_18.cubicTo(
        size.width * 0.5844116,
        size.height * 0.4710090,
        size.width * 0.6111524,
        size.height * 0.4787469,
        size.width * 0.6377744,
        size.height * 0.4787469);
    path_18.cubicTo(
        size.width * 0.6643963,
        size.height * 0.4787469,
        size.width * 0.6911341,
        size.height * 0.4710090,
        size.width * 0.7116341,
        size.height * 0.4553814);
    path_18.cubicTo(
        size.width * 0.7321463,
        size.height * 0.4397386,
        size.width * 0.7427012,
        size.height * 0.4189793,
        size.width * 0.7427012,
        size.height * 0.3978931);
    path_18.cubicTo(
        size.width * 0.7427012,
        size.height * 0.3768076,
        size.width * 0.7321463,
        size.height * 0.3560483,
        size.width * 0.7116341,
        size.height * 0.3404055);
    path_18.cubicTo(
        size.width * 0.6911341,
        size.height * 0.3247772,
        size.width * 0.6643963,
        size.height * 0.3170393,
        size.width * 0.6377744,
        size.height * 0.3170393);
    path_18.cubicTo(
        size.width * 0.6111524,
        size.height * 0.3170393,
        size.width * 0.5844116,
        size.height * 0.3247772,
        size.width * 0.5639171,
        size.height * 0.3404055);
    path_18.cubicTo(
        size.width * 0.5434030,
        size.height * 0.3560483,
        size.width * 0.5328457,
        size.height * 0.3768076,
        size.width * 0.5328457,
        size.height * 0.3978931);
    path_18.cubicTo(
        size.width * 0.5328457,
        size.height * 0.4189793,
        size.width * 0.5434030,
        size.height * 0.4397386,
        size.width * 0.5639171,
        size.height * 0.4553814);
    path_18.close();

    Paint paint_18_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_18_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_stroke);

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(size.width * 0.5870659, size.height * 0.4377269);
    path_19.cubicTo(
        size.width * 0.6011671,
        size.height * 0.4484793,
        size.width * 0.6195244,
        size.height * 0.4537800,
        size.width * 0.6377683,
        size.height * 0.4537800);
    path_19.cubicTo(
        size.width * 0.6560183,
        size.height * 0.4537800,
        size.width * 0.6743720,
        size.height * 0.4484793,
        size.width * 0.6884756,
        size.height * 0.4377262);
    path_19.cubicTo(
        size.width * 0.7025976,
        size.height * 0.4269586,
        size.width * 0.7099573,
        size.height * 0.4125890,
        size.width * 0.7099573,
        size.height * 0.3978924);
    path_19.cubicTo(
        size.width * 0.7099573,
        size.height * 0.3831966,
        size.width * 0.7025976,
        size.height * 0.3688269,
        size.width * 0.6884756,
        size.height * 0.3580586);
    path_19.cubicTo(
        size.width * 0.6743720,
        size.height * 0.3473062,
        size.width * 0.6560183,
        size.height * 0.3420055,
        size.width * 0.6377683,
        size.height * 0.3420055);
    path_19.cubicTo(
        size.width * 0.6195244,
        size.height * 0.3420055,
        size.width * 0.6011671,
        size.height * 0.3473062,
        size.width * 0.5870659,
        size.height * 0.3580586);
    path_19.cubicTo(
        size.width * 0.5729451,
        size.height * 0.3688269,
        size.width * 0.5655848,
        size.height * 0.3831966,
        size.width * 0.5655848,
        size.height * 0.3978924);
    path_19.cubicTo(
        size.width * 0.5655848,
        size.height * 0.4125890,
        size.width * 0.5729451,
        size.height * 0.4269586,
        size.width * 0.5870659,
        size.height * 0.4377269);
    path_19.close();

    Paint paint_19_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_19_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_stroke);

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.6706890, size.height * 0.3508566);
    path_20.cubicTo(
        size.width * 0.6453537,
        size.height * 0.3428676,
        size.width * 0.6151098,
        size.height * 0.3467241,
        size.width * 0.5945177,
        size.height * 0.3624269);
    path_20.cubicTo(
        size.width * 0.5672201,
        size.height * 0.3832428,
        size.width * 0.5672201,
        size.height * 0.4169910,
        size.width * 0.5945177,
        size.height * 0.4378062);
    path_20.cubicTo(
        size.width * 0.5995201,
        size.height * 0.4416207,
        size.width * 0.6050921,
        size.height * 0.4447359,
        size.width * 0.6110244,
        size.height * 0.4471524);
    path_20.cubicTo(
        size.width * 0.6027768,
        size.height * 0.4445517,
        size.width * 0.5950488,
        size.height * 0.4406945,
        size.width * 0.5883445,
        size.height * 0.4355821);
    path_20.cubicTo(
        size.width * 0.5610470,
        size.height * 0.4147669,
        size.width * 0.5610470,
        size.height * 0.3810186,
        size.width * 0.5883445,
        size.height * 0.3602034);
    path_20.cubicTo(
        size.width * 0.6106402,
        size.height * 0.3432028,
        size.width * 0.6442500,
        size.height * 0.3400869,
        size.width * 0.6706890,
        size.height * 0.3508566);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.3841341, size.height * 0.5519172);
    path_21.lineTo(size.width * 0.3843293, size.height * 0.5519172);
    path_21.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5712572,
        size.width * 0.3960012,
        size.height * 0.5900103,
        size.width * 0.4144537,
        size.height * 0.6044331);
    path_21.cubicTo(
        size.width * 0.4344610,
        size.height * 0.6200717,
        size.width * 0.4605652,
        size.height * 0.6278159,
        size.width * 0.4865591,
        size.height * 0.6278159);
    path_21.cubicTo(
        size.width * 0.5125524,
        size.height * 0.6278159,
        size.width * 0.5386567,
        size.height * 0.6200717,
        size.width * 0.5586640,
        size.height * 0.6044331);
    path_21.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5900103,
        size.width * 0.5873012,
        size.height * 0.5712572,
        size.width * 0.5887884,
        size.height * 0.5519172);
    path_21.lineTo(size.width * 0.5890683, size.height * 0.5519172);
    path_21.lineTo(size.width * 0.5890683, size.height * 0.5493310);
    path_21.lineTo(size.width * 0.5890683, size.height * 0.5115848);
    path_21.lineTo(size.width * 0.5890683, size.height * 0.5089986);
    path_21.lineTo(size.width * 0.5867817, size.height * 0.5089986);
    path_21.lineTo(size.width * 0.5770561, size.height * 0.5089986);
    path_21.cubicTo(
        size.width * 0.5723134,
        size.height * 0.5019441,
        size.width * 0.5661738,
        size.height * 0.4953607,
        size.width * 0.5586640,
        size.height * 0.4894910);
    path_21.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4738524,
        size.width * 0.5125524,
        size.height * 0.4661083,
        size.width * 0.4865591,
        size.height * 0.4661083);
    path_21.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4661083,
        size.width * 0.4344610,
        size.height * 0.4738524,
        size.width * 0.4144537,
        size.height * 0.4894910);
    path_21.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4953607,
        size.width * 0.4008049,
        size.height * 0.5019441,
        size.width * 0.3960616,
        size.height * 0.5089986);
    path_21.lineTo(size.width * 0.3864207, size.height * 0.5089986);
    path_21.lineTo(size.width * 0.3841341, size.height * 0.5089986);
    path_21.lineTo(size.width * 0.3841341, size.height * 0.5115848);
    path_21.lineTo(size.width * 0.3841341, size.height * 0.5493310);
    path_21.lineTo(size.width * 0.3841341, size.height * 0.5519172);
    path_21.close();

    Paint paint_21_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_21_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_stroke);

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.4144494, size.height * 0.5746214);
    path_22.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5902593,
        size.width * 0.4605610,
        size.height * 0.5980041,
        size.width * 0.4865543,
        size.height * 0.5980041);
    path_22.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5980041,
        size.width * 0.5386524,
        size.height * 0.5902593,
        size.width * 0.5586598,
        size.height * 0.5746214);
    path_22.cubicTo(
        size.width * 0.5786890,
        size.height * 0.5589655,
        size.width * 0.5889744,
        size.height * 0.5382069,
        size.width * 0.5889744,
        size.height * 0.5171503);
    path_22.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4960931,
        size.width * 0.5786890,
        size.height * 0.4753345,
        size.width * 0.5586598,
        size.height * 0.4596786);
    path_22.cubicTo(
        size.width * 0.5386524,
        size.height * 0.4440407,
        size.width * 0.5125482,
        size.height * 0.4362959,
        size.width * 0.4865543,
        size.height * 0.4362959);
    path_22.cubicTo(
        size.width * 0.4605610,
        size.height * 0.4362959,
        size.width * 0.4344567,
        size.height * 0.4440407,
        size.width * 0.4144494,
        size.height * 0.4596786);
    path_22.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4753345,
        size.width * 0.3841341,
        size.height * 0.4960931,
        size.width * 0.3841341,
        size.height * 0.5171503);
    path_22.cubicTo(
        size.width * 0.3841341,
        size.height * 0.5382069,
        size.width * 0.3944201,
        size.height * 0.5589655,
        size.width * 0.4144494,
        size.height * 0.5746214);
    path_22.close();

    Paint paint_22_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_22_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_stroke);

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(size.width * 0.4370348, size.height * 0.5569669);
    path_23.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5677297,
        size.width * 0.4687348,
        size.height * 0.5730366,
        size.width * 0.4865537,
        size.height * 0.5730366);
    path_23.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5730366,
        size.width * 0.5223018,
        size.height * 0.5677297,
        size.width * 0.5360720,
        size.height * 0.5569662);
    path_23.cubicTo(
        size.width * 0.5498646,
        size.height * 0.5461862,
        size.width * 0.5570317,
        size.height * 0.5318166,
        size.width * 0.5570317,
        size.height * 0.5171497);
    path_23.cubicTo(
        size.width * 0.5570317,
        size.height * 0.5024821,
        size.width * 0.5498646,
        size.height * 0.4881131,
        size.width * 0.5360720,
        size.height * 0.4773324);
    path_23.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4665690,
        size.width * 0.5043726,
        size.height * 0.4612628,
        size.width * 0.4865537,
        size.height * 0.4612628);
    path_23.cubicTo(
        size.width * 0.4687348,
        size.height * 0.4612628,
        size.width * 0.4508049,
        size.height * 0.4665690,
        size.width * 0.4370348,
        size.height * 0.4773324);
    path_23.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4881131,
        size.width * 0.4160750,
        size.height * 0.5024821,
        size.width * 0.4160750,
        size.height * 0.5171497);
    path_23.cubicTo(
        size.width * 0.4160750,
        size.height * 0.5318166,
        size.width * 0.4232427,
        size.height * 0.5461862,
        size.width * 0.4370348,
        size.height * 0.5569669);
    path_23.close();

    Paint paint_23_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_23_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_stroke);

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(size.width * 0.5186683, size.height * 0.4701138);
    path_24.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4621241,
        size.width * 0.4644470,
        size.height * 0.4659814,
        size.width * 0.4443573,
        size.height * 0.4816841);
    path_24.cubicTo(
        size.width * 0.4177262,
        size.height * 0.5024993,
        size.width * 0.4177262,
        size.height * 0.5362476,
        size.width * 0.4443573,
        size.height * 0.5570628);
    path_24.cubicTo(
        size.width * 0.4492372,
        size.height * 0.5608772,
        size.width * 0.4546732,
        size.height * 0.5639931,
        size.width * 0.4604610,
        size.height * 0.5664097);
    path_24.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5638083,
        size.width * 0.4448756,
        size.height * 0.5599517,
        size.width * 0.4383348,
        size.height * 0.5548393);
    path_24.cubicTo(
        size.width * 0.4117043,
        size.height * 0.5340234,
        size.width * 0.4117043,
        size.height * 0.5002752,
        size.width * 0.4383348,
        size.height * 0.4794600);
    path_24.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4624593,
        size.width * 0.4928726,
        size.height * 0.4593441,
        size.width * 0.5186683,
        size.height * 0.4701138);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(size.width * 0.3841341, size.height * 0.4901428);
    path_25.lineTo(size.width * 0.3843293, size.height * 0.4901428);
    path_25.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5094828,
        size.width * 0.3960012,
        size.height * 0.5282359,
        size.width * 0.4144537,
        size.height * 0.5426593);
    path_25.cubicTo(
        size.width * 0.4344610,
        size.height * 0.5582972,
        size.width * 0.4605652,
        size.height * 0.5660414,
        size.width * 0.4865591,
        size.height * 0.5660414);
    path_25.cubicTo(
        size.width * 0.5125524,
        size.height * 0.5660414,
        size.width * 0.5386567,
        size.height * 0.5582972,
        size.width * 0.5586640,
        size.height * 0.5426593);
    path_25.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5282359,
        size.width * 0.5873012,
        size.height * 0.5094828,
        size.width * 0.5887884,
        size.height * 0.4901428);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.4901428);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.4875566);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.4498110);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.4472248);
    path_25.lineTo(size.width * 0.5867817, size.height * 0.4472248);
    path_25.lineTo(size.width * 0.5770561, size.height * 0.4472248);
    path_25.cubicTo(
        size.width * 0.5723134,
        size.height * 0.4401697,
        size.width * 0.5661738,
        size.height * 0.4335862,
        size.width * 0.5586640,
        size.height * 0.4277166);
    path_25.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4120779,
        size.width * 0.5125524,
        size.height * 0.4043338,
        size.width * 0.4865591,
        size.height * 0.4043338);
    path_25.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4043338,
        size.width * 0.4344610,
        size.height * 0.4120779,
        size.width * 0.4144537,
        size.height * 0.4277166);
    path_25.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4335862,
        size.width * 0.4008049,
        size.height * 0.4401697,
        size.width * 0.3960616,
        size.height * 0.4472248);
    path_25.lineTo(size.width * 0.3864207, size.height * 0.4472248);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.4472248);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.4498110);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.4875566);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.4901428);
    path_25.close();

    Paint paint_25_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_25_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_stroke);

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(size.width * 0.4144494, size.height * 0.5128469);
    path_26.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5284855,
        size.width * 0.4605610,
        size.height * 0.5362297,
        size.width * 0.4865543,
        size.height * 0.5362297);
    path_26.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5362297,
        size.width * 0.5386524,
        size.height * 0.5284855,
        size.width * 0.5586598,
        size.height * 0.5128469);
    path_26.cubicTo(
        size.width * 0.5786890,
        size.height * 0.4971917,
        size.width * 0.5889744,
        size.height * 0.4764324,
        size.width * 0.5889744,
        size.height * 0.4553759);
    path_26.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4343186,
        size.width * 0.5786890,
        size.height * 0.4135600,
        size.width * 0.5586598,
        size.height * 0.3979048);
    path_26.cubicTo(
        size.width * 0.5386524,
        size.height * 0.3822662,
        size.width * 0.5125482,
        size.height * 0.3745221,
        size.width * 0.4865543,
        size.height * 0.3745221);
    path_26.cubicTo(
        size.width * 0.4605610,
        size.height * 0.3745221,
        size.width * 0.4344567,
        size.height * 0.3822662,
        size.width * 0.4144494,
        size.height * 0.3979048);
    path_26.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4135600,
        size.width * 0.3841341,
        size.height * 0.4343193,
        size.width * 0.3841341,
        size.height * 0.4553759);
    path_26.cubicTo(
        size.width * 0.3841341,
        size.height * 0.4764324,
        size.width * 0.3944201,
        size.height * 0.4971917,
        size.width * 0.4144494,
        size.height * 0.5128469);
    path_26.close();

    Paint paint_26_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_26_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_stroke);

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(size.width * 0.4370348, size.height * 0.4951924);
    path_27.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5059559,
        size.width * 0.4687348,
        size.height * 0.5112621,
        size.width * 0.4865537,
        size.height * 0.5112621);
    path_27.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5112621,
        size.width * 0.5223018,
        size.height * 0.5059559,
        size.width * 0.5360720,
        size.height * 0.4951924);
    path_27.cubicTo(
        size.width * 0.5498646,
        size.height * 0.4844117,
        size.width * 0.5570317,
        size.height * 0.4700428,
        size.width * 0.5570317,
        size.height * 0.4553752);
    path_27.cubicTo(
        size.width * 0.5570317,
        size.height * 0.4407083,
        size.width * 0.5498646,
        size.height * 0.4263386,
        size.width * 0.5360720,
        size.height * 0.4155579);
    path_27.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4047952,
        size.width * 0.5043726,
        size.height * 0.3994883,
        size.width * 0.4865537,
        size.height * 0.3994883);
    path_27.cubicTo(
        size.width * 0.4687348,
        size.height * 0.3994883,
        size.width * 0.4508049,
        size.height * 0.4047952,
        size.width * 0.4370348,
        size.height * 0.4155579);
    path_27.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4263386,
        size.width * 0.4160750,
        size.height * 0.4407083,
        size.width * 0.4160750,
        size.height * 0.4553752);
    path_27.cubicTo(
        size.width * 0.4160750,
        size.height * 0.4700428,
        size.width * 0.4232427,
        size.height * 0.4844117,
        size.width * 0.4370348,
        size.height * 0.4951924);
    path_27.close();

    Paint paint_27_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_27_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_stroke);

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(size.width * 0.5186683, size.height * 0.4083393);
    path_28.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4003503,
        size.width * 0.4644470,
        size.height * 0.4042069,
        size.width * 0.4443573,
        size.height * 0.4199097);
    path_28.cubicTo(
        size.width * 0.4177262,
        size.height * 0.4407248,
        size.width * 0.4177262,
        size.height * 0.4744731,
        size.width * 0.4443573,
        size.height * 0.4952883);
    path_28.cubicTo(
        size.width * 0.4492372,
        size.height * 0.4991028,
        size.width * 0.4546732,
        size.height * 0.5022186,
        size.width * 0.4604610,
        size.height * 0.5046352);
    path_28.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5020338,
        size.width * 0.4448756,
        size.height * 0.4981772,
        size.width * 0.4383348,
        size.height * 0.4930648);
    path_28.cubicTo(
        size.width * 0.4117043,
        size.height * 0.4722497,
        size.width * 0.4117043,
        size.height * 0.4385014,
        size.width * 0.4383348,
        size.height * 0.4176855);
    path_28.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4006848,
        size.width * 0.4928726,
        size.height * 0.3975697,
        size.width * 0.5186683,
        size.height * 0.4083393);
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);

    Path path_29 = Path();
    path_29.moveTo(size.width * 0.3589817, size.height * 0.4509676);
    path_29.lineTo(size.width * 0.3591768, size.height * 0.4509676);
    path_29.cubicTo(
        size.width * 0.3606646,
        size.height * 0.4703076,
        size.width * 0.3708488,
        size.height * 0.4890607,
        size.width * 0.3893012,
        size.height * 0.5034834);
    path_29.cubicTo(
        size.width * 0.4093085,
        size.height * 0.5191221,
        size.width * 0.4354128,
        size.height * 0.5268662,
        size.width * 0.4614067,
        size.height * 0.5268662);
    path_29.cubicTo(
        size.width * 0.4874000,
        size.height * 0.5268662,
        size.width * 0.5135043,
        size.height * 0.5191221,
        size.width * 0.5335116,
        size.height * 0.5034834);
    path_29.cubicTo(
        size.width * 0.5519640,
        size.height * 0.4890607,
        size.width * 0.5621488,
        size.height * 0.4703076,
        size.width * 0.5636360,
        size.height * 0.4509676);
    path_29.lineTo(size.width * 0.5639159, size.height * 0.4509676);
    path_29.lineTo(size.width * 0.5639159, size.height * 0.4483814);
    path_29.lineTo(size.width * 0.5639159, size.height * 0.4106352);
    path_29.lineTo(size.width * 0.5639159, size.height * 0.4080490);
    path_29.lineTo(size.width * 0.5616293, size.height * 0.4080490);
    path_29.lineTo(size.width * 0.5519037, size.height * 0.4080490);
    path_29.cubicTo(
        size.width * 0.5471610,
        size.height * 0.4009945,
        size.width * 0.5410213,
        size.height * 0.3944110,
        size.width * 0.5335116,
        size.height * 0.3885414);
    path_29.cubicTo(
        size.width * 0.5135043,
        size.height * 0.3729028,
        size.width * 0.4874000,
        size.height * 0.3651586,
        size.width * 0.4614067,
        size.height * 0.3651586);
    path_29.cubicTo(
        size.width * 0.4354128,
        size.height * 0.3651586,
        size.width * 0.4093085,
        size.height * 0.3729028,
        size.width * 0.3893012,
        size.height * 0.3885414);
    path_29.cubicTo(
        size.width * 0.3817915,
        size.height * 0.3944110,
        size.width * 0.3756524,
        size.height * 0.4009945,
        size.width * 0.3709091,
        size.height * 0.4080490);
    path_29.lineTo(size.width * 0.3612683, size.height * 0.4080490);
    path_29.lineTo(size.width * 0.3589817, size.height * 0.4080490);
    path_29.lineTo(size.width * 0.3589817, size.height * 0.4106352);
    path_29.lineTo(size.width * 0.3589817, size.height * 0.4483814);
    path_29.lineTo(size.width * 0.3589817, size.height * 0.4509676);
    path_29.close();

    Paint paint_29_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_29_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_stroke);

    Paint paint_29_fill = Paint()..style = PaintingStyle.fill;
    paint_29_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_fill);

    Path path_30 = Path();
    path_30.moveTo(size.width * 0.3892970, size.height * 0.4736717);
    path_30.cubicTo(
        size.width * 0.4093043,
        size.height * 0.4893097,
        size.width * 0.4354085,
        size.height * 0.4970545,
        size.width * 0.4614018,
        size.height * 0.4970545);
    path_30.cubicTo(
        size.width * 0.4873957,
        size.height * 0.4970545,
        size.width * 0.5135000,
        size.height * 0.4893097,
        size.width * 0.5335073,
        size.height * 0.4736717);
    path_30.cubicTo(
        size.width * 0.5535366,
        size.height * 0.4580159,
        size.width * 0.5638220,
        size.height * 0.4372572,
        size.width * 0.5638220,
        size.height * 0.4162007);
    path_30.cubicTo(
        size.width * 0.5638220,
        size.height * 0.3951434,
        size.width * 0.5535366,
        size.height * 0.3743848,
        size.width * 0.5335073,
        size.height * 0.3587290);
    path_30.cubicTo(
        size.width * 0.5135000,
        size.height * 0.3430910,
        size.width * 0.4873957,
        size.height * 0.3353462,
        size.width * 0.4614018,
        size.height * 0.3353462);
    path_30.cubicTo(
        size.width * 0.4354085,
        size.height * 0.3353462,
        size.width * 0.4093043,
        size.height * 0.3430910,
        size.width * 0.3892970,
        size.height * 0.3587290);
    path_30.cubicTo(
        size.width * 0.3692677,
        size.height * 0.3743848,
        size.width * 0.3589817,
        size.height * 0.3951434,
        size.width * 0.3589817,
        size.height * 0.4162007);
    path_30.cubicTo(
        size.width * 0.3589817,
        size.height * 0.4372572,
        size.width * 0.3692677,
        size.height * 0.4580159,
        size.width * 0.3892970,
        size.height * 0.4736717);
    path_30.close();

    Paint paint_30_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_30_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_stroke);

    Paint paint_30_fill = Paint()..style = PaintingStyle.fill;
    paint_30_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_fill);

    Path path_31 = Path();
    path_31.moveTo(size.width * 0.4118823, size.height * 0.4560172);
    path_31.cubicTo(
        size.width * 0.4256524,
        size.height * 0.4667800,
        size.width * 0.4435823,
        size.height * 0.4720869,
        size.width * 0.4614012,
        size.height * 0.4720869);
    path_31.cubicTo(
        size.width * 0.4792201,
        size.height * 0.4720869,
        size.width * 0.4971494,
        size.height * 0.4667800,
        size.width * 0.5109195,
        size.height * 0.4560172);
    path_31.cubicTo(
        size.width * 0.5247122,
        size.height * 0.4452366,
        size.width * 0.5318793,
        size.height * 0.4308669,
        size.width * 0.5318793,
        size.height * 0.4162000);
    path_31.cubicTo(
        size.width * 0.5318793,
        size.height * 0.4015324,
        size.width * 0.5247122,
        size.height * 0.3871634,
        size.width * 0.5109195,
        size.height * 0.3763828);
    path_31.cubicTo(
        size.width * 0.4971494,
        size.height * 0.3656193,
        size.width * 0.4792201,
        size.height * 0.3603131,
        size.width * 0.4614012,
        size.height * 0.3603131);
    path_31.cubicTo(
        size.width * 0.4435823,
        size.height * 0.3603131,
        size.width * 0.4256524,
        size.height * 0.3656193,
        size.width * 0.4118823,
        size.height * 0.3763828);
    path_31.cubicTo(
        size.width * 0.3980902,
        size.height * 0.3871634,
        size.width * 0.3909226,
        size.height * 0.4015324,
        size.width * 0.3909226,
        size.height * 0.4162000);
    path_31.cubicTo(
        size.width * 0.3909226,
        size.height * 0.4308669,
        size.width * 0.3980902,
        size.height * 0.4452366,
        size.width * 0.4118823,
        size.height * 0.4560172);
    path_31.close();

    Paint paint_31_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_31_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_stroke);

    Paint paint_31_fill = Paint()..style = PaintingStyle.fill;
    paint_31_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_fill);

    Path path_32 = Path();
    path_32.moveTo(size.width * 0.4935159, size.height * 0.3691641);
    path_32.cubicTo(
        size.width * 0.4688006,
        size.height * 0.3611745,
        size.width * 0.4392945,
        size.height * 0.3650317,
        size.width * 0.4192049,
        size.height * 0.3807345);
    path_32.cubicTo(
        size.width * 0.3925738,
        size.height * 0.4015497,
        size.width * 0.3925738,
        size.height * 0.4352979,
        size.width * 0.4192049,
        size.height * 0.4561131);
    path_32.cubicTo(
        size.width * 0.4240848,
        size.height * 0.4599276,
        size.width * 0.4295207,
        size.height * 0.4630434,
        size.width * 0.4353085,
        size.height * 0.4654600);
    path_32.cubicTo(
        size.width * 0.4272622,
        size.height * 0.4628586,
        size.width * 0.4197232,
        size.height * 0.4590021,
        size.width * 0.4131823,
        size.height * 0.4538897);
    path_32.cubicTo(
        size.width * 0.3865518,
        size.height * 0.4330738,
        size.width * 0.3865518,
        size.height * 0.3993255,
        size.width * 0.4131823,
        size.height * 0.3785103);
    path_32.cubicTo(
        size.width * 0.4349323,
        size.height * 0.3615097,
        size.width * 0.4677201,
        size.height * 0.3583945,
        size.width * 0.4935159,
        size.height * 0.3691641);
    path_32.close();

    Paint paint_32_fill = Paint()..style = PaintingStyle.fill;
    paint_32_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_32, paint_32_fill);

    Path path_33 = Path();
    path_33.moveTo(size.width * 0.3660561, size.height * 0.4026731);
    path_33.lineTo(size.width * 0.3662512, size.height * 0.4026731);
    path_33.cubicTo(
        size.width * 0.3677390,
        size.height * 0.4220131,
        size.width * 0.3779232,
        size.height * 0.4407662,
        size.width * 0.3963756,
        size.height * 0.4551897);
    path_33.cubicTo(
        size.width * 0.4163829,
        size.height * 0.4708276,
        size.width * 0.4424872,
        size.height * 0.4785717,
        size.width * 0.4684805,
        size.height * 0.4785717);
    path_33.cubicTo(
        size.width * 0.4944744,
        size.height * 0.4785717,
        size.width * 0.5205787,
        size.height * 0.4708276,
        size.width * 0.5405860,
        size.height * 0.4551897);
    path_33.cubicTo(
        size.width * 0.5590384,
        size.height * 0.4407662,
        size.width * 0.5692226,
        size.height * 0.4220131,
        size.width * 0.5707104,
        size.height * 0.4026731);
    path_33.lineTo(size.width * 0.5709896, size.height * 0.4026731);
    path_33.lineTo(size.width * 0.5709896, size.height * 0.4000869);
    path_33.lineTo(size.width * 0.5709896, size.height * 0.3623414);
    path_33.lineTo(size.width * 0.5709896, size.height * 0.3597552);
    path_33.lineTo(size.width * 0.5687030, size.height * 0.3597552);
    path_33.lineTo(size.width * 0.5589780, size.height * 0.3597552);
    path_33.cubicTo(
        size.width * 0.5542348,
        size.height * 0.3527000,
        size.width * 0.5480957,
        size.height * 0.3461166,
        size.width * 0.5405860,
        size.height * 0.3402469);
    path_33.cubicTo(
        size.width * 0.5205787,
        size.height * 0.3246083,
        size.width * 0.4944744,
        size.height * 0.3168641,
        size.width * 0.4684805,
        size.height * 0.3168641);
    path_33.cubicTo(
        size.width * 0.4424872,
        size.height * 0.3168641,
        size.width * 0.4163829,
        size.height * 0.3246083,
        size.width * 0.3963756,
        size.height * 0.3402469);
    path_33.cubicTo(
        size.width * 0.3888659,
        size.height * 0.3461166,
        size.width * 0.3827268,
        size.height * 0.3527000,
        size.width * 0.3779835,
        size.height * 0.3597552);
    path_33.lineTo(size.width * 0.3683427, size.height * 0.3597552);
    path_33.lineTo(size.width * 0.3660561, size.height * 0.3597552);
    path_33.lineTo(size.width * 0.3660561, size.height * 0.3623414);
    path_33.lineTo(size.width * 0.3660561, size.height * 0.4000869);
    path_33.lineTo(size.width * 0.3660561, size.height * 0.4026731);
    path_33.close();

    Paint paint_33_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_33_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_33, paint_33_stroke);

    Paint paint_33_fill = Paint()..style = PaintingStyle.fill;
    paint_33_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_33, paint_33_fill);

    Path path_34 = Path();
    path_34.moveTo(size.width * 0.3963713, size.height * 0.4253772);
    path_34.cubicTo(
        size.width * 0.4163787,
        size.height * 0.4410159,
        size.width * 0.4424829,
        size.height * 0.4487600,
        size.width * 0.4684762,
        size.height * 0.4487600);
    path_34.cubicTo(
        size.width * 0.4944695,
        size.height * 0.4487600,
        size.width * 0.5205738,
        size.height * 0.4410159,
        size.width * 0.5405811,
        size.height * 0.4253772);
    path_34.cubicTo(
        size.width * 0.5606104,
        size.height * 0.4097214,
        size.width * 0.5708963,
        size.height * 0.3889628,
        size.width * 0.5708963,
        size.height * 0.3679062);
    path_34.cubicTo(
        size.width * 0.5708963,
        size.height * 0.3468490,
        size.width * 0.5606104,
        size.height * 0.3260903,
        size.width * 0.5405811,
        size.height * 0.3104345);
    path_34.cubicTo(
        size.width * 0.5205738,
        size.height * 0.2947966,
        size.width * 0.4944695,
        size.height * 0.2870524,
        size.width * 0.4684762,
        size.height * 0.2870524);
    path_34.cubicTo(
        size.width * 0.4424829,
        size.height * 0.2870524,
        size.width * 0.4163787,
        size.height * 0.2947966,
        size.width * 0.3963713,
        size.height * 0.3104352);
    path_34.cubicTo(
        size.width * 0.3763421,
        size.height * 0.3260903,
        size.width * 0.3660561,
        size.height * 0.3468490,
        size.width * 0.3660561,
        size.height * 0.3679062);
    path_34.cubicTo(
        size.width * 0.3660561,
        size.height * 0.3889628,
        size.width * 0.3763421,
        size.height * 0.4097214,
        size.width * 0.3963713,
        size.height * 0.4253772);
    path_34.close();

    Paint paint_34_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_34_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_34, paint_34_stroke);

    Paint paint_34_fill = Paint()..style = PaintingStyle.fill;
    paint_34_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_34, paint_34_fill);

    Path path_35 = Path();
    path_35.moveTo(size.width * 0.4189561, size.height * 0.4077228);
    path_35.cubicTo(
        size.width * 0.4327268,
        size.height * 0.4184855,
        size.width * 0.4506561,
        size.height * 0.4237924,
        size.width * 0.4684750,
        size.height * 0.4237924);
    path_35.cubicTo(
        size.width * 0.4862939,
        size.height * 0.4237924,
        size.width * 0.5042238,
        size.height * 0.4184855,
        size.width * 0.5179939,
        size.height * 0.4077228);
    path_35.cubicTo(
        size.width * 0.5317860,
        size.height * 0.3969421,
        size.width * 0.5389537,
        size.height * 0.3825724,
        size.width * 0.5389537,
        size.height * 0.3679055);
    path_35.cubicTo(
        size.width * 0.5389537,
        size.height * 0.3532386,
        size.width * 0.5317860,
        size.height * 0.3388690,
        size.width * 0.5179939,
        size.height * 0.3280883);
    path_35.cubicTo(
        size.width * 0.5042238,
        size.height * 0.3173255,
        size.width * 0.4862939,
        size.height * 0.3120186,
        size.width * 0.4684750,
        size.height * 0.3120186);
    path_35.cubicTo(
        size.width * 0.4506561,
        size.height * 0.3120186,
        size.width * 0.4327268,
        size.height * 0.3173255,
        size.width * 0.4189561,
        size.height * 0.3280883);
    path_35.cubicTo(
        size.width * 0.4051640,
        size.height * 0.3388690,
        size.width * 0.3979970,
        size.height * 0.3532386,
        size.width * 0.3979970,
        size.height * 0.3679055);
    path_35.cubicTo(
        size.width * 0.3979970,
        size.height * 0.3825724,
        size.width * 0.4051640,
        size.height * 0.3969421,
        size.width * 0.4189561,
        size.height * 0.4077228);
    path_35.close();

    Paint paint_35_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_35_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_35, paint_35_stroke);

    Paint paint_35_fill = Paint()..style = PaintingStyle.fill;
    paint_35_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_35, paint_35_fill);

    Path path_36 = Path();
    path_36.moveTo(size.width * 0.5005896, size.height * 0.3208697);
    path_36.cubicTo(
        size.width * 0.4758744,
        size.height * 0.3128807,
        size.width * 0.4463683,
        size.height * 0.3167372,
        size.width * 0.4262787,
        size.height * 0.3324400);
    path_36.cubicTo(
        size.width * 0.3996482,
        size.height * 0.3532552,
        size.width * 0.3996482,
        size.height * 0.3870034,
        size.width * 0.4262787,
        size.height * 0.4078186);
    path_36.cubicTo(
        size.width * 0.4311591,
        size.height * 0.4116331,
        size.width * 0.4365951,
        size.height * 0.4147490,
        size.width * 0.4423829,
        size.height * 0.4171655);
    path_36.cubicTo(
        size.width * 0.4343360,
        size.height * 0.4145641,
        size.width * 0.4267970,
        size.height * 0.4107076,
        size.width * 0.4202561,
        size.height * 0.4055952);
    path_36.cubicTo(
        size.width * 0.3936256,
        size.height * 0.3847800,
        size.width * 0.3936256,
        size.height * 0.3510317,
        size.width * 0.4202561,
        size.height * 0.3302159);
    path_36.cubicTo(
        size.width * 0.4420067,
        size.height * 0.3132152,
        size.width * 0.4747945,
        size.height * 0.3101000,
        size.width * 0.5005896,
        size.height * 0.3208697);
    path_36.close();

    Paint paint_36_fill = Paint()..style = PaintingStyle.fill;
    paint_36_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_36, paint_36_fill);

    Path path_37 = Path();
    path_37.moveTo(size.width * 0.7744024, size.height * 0.2241372);
    path_37.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2138345,
        size.width * 0.7798110,
        size.height * 0.2031117,
        size.width * 0.7798110,
        size.height * 0.1921007);
    path_37.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1124841,
        size.width * 0.6821220,
        size.height * 0.04794248,
        size.width * 0.5616250,
        size.height * 0.04794248);
    path_37.cubicTo(
        size.width * 0.4411250,
        size.height * 0.04794248,
        size.width * 0.3434402,
        size.height * 0.1124841,
        size.width * 0.3434402,
        size.height * 0.1921007);
    path_37.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2031110,
        size.width * 0.3453085,
        size.height * 0.2138331,
        size.width * 0.3488470,
        size.height * 0.2241359);
    path_37.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1599379,
        size.width * 0.4577890,
        size.height * 0.1120138,
        size.width * 0.5616244,
        size.height * 0.1120138);
    path_37.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1120138,
        size.width * 0.7523537,
        size.height * 0.1599393,
        size.width * 0.7744024,
        size.height * 0.2241372);
    path_37.close();

    Paint paint_37_fill = Paint()..style = PaintingStyle.fill;
    paint_37_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_37, paint_37_fill);

    Path path_38 = Path();
    path_38.moveTo(size.width * 0.3293390, size.height * 0.2071000);
    path_38.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2182041,
        size.width * 0.3235116,
        size.height * 0.2297593,
        size.width * 0.3235116,
        size.height * 0.2416255);
    path_38.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3274269,
        size.width * 0.4287841,
        size.height * 0.3969828,
        size.width * 0.5586451,
        size.height * 0.3969828);
    path_38.cubicTo(
        size.width * 0.6885061,
        size.height * 0.3969828,
        size.width * 0.7937805,
        size.height * 0.3274269,
        size.width * 0.7937805,
        size.height * 0.2416255);
    path_38.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2297600,
        size.width * 0.7917683,
        size.height * 0.2182055,
        size.width * 0.7879512,
        size.height * 0.2071021);
    path_38.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2762869,
        size.width * 0.6705488,
        size.height * 0.3279338,
        size.width * 0.5586457,
        size.height * 0.3279338);
    path_38.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3279338,
        size.width * 0.3530988,
        size.height * 0.2762855,
        size.width * 0.3293390,
        size.height * 0.2071000);
    path_38.close();

    Paint paint_38_fill = Paint()..style = PaintingStyle.fill;
    paint_38_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_38, paint_38_fill);

    Path path_39 = Path();
    path_39.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_39.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_39.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_39.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_39.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_39.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_39.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_39.close();

    Paint paint_39_fill = Paint()..style = PaintingStyle.fill;
    paint_39_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_39, paint_39_fill);

    Path path_40 = Path();
    path_40.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_40.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_40.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_40.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_40.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_40.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_40.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_40.close();

    Paint paint_40_fill = Paint()..style = PaintingStyle.fill;
    paint_40_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_40, paint_40_fill);

    Path path_41 = Path();
    path_41.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_41.lineTo(size.width * 0.3232665, size.height * 0.2214455);
    path_41.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_41.lineTo(size.width * 0.3171854, size.height * 0.2219545);
    path_41.close();
    path_41.moveTo(size.width * 0.7993598, size.height * 0.2219545);
    path_41.lineTo(size.width * 0.8054390, size.height * 0.2214317);
    path_41.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_41.lineTo(size.width * 0.7993598, size.height * 0.2219545);
    path_41.close();
    path_41.moveTo(size.width * 0.5582720, size.height * 0.3865172);
    path_41.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_41.lineTo(size.width * 0.5582720, size.height * 0.3865172);
    path_41.close();
    path_41.moveTo(size.width * 0.3230152, size.height * 0.2299497);
    path_41.cubicTo(
        size.width * 0.3230152,
        size.height * 0.2274441,
        size.width * 0.3230994,
        size.height * 0.2249531,
        size.width * 0.3232652,
        size.height * 0.2224766);
    path_41.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_41.cubicTo(
        size.width * 0.3109159,
        size.height * 0.2242552,
        size.width * 0.3108201,
        size.height * 0.2270945,
        size.width * 0.3108201,
        size.height * 0.2299497);
    path_41.lineTo(size.width * 0.3230152, size.height * 0.2299497);
    path_41.close();
    path_41.moveTo(size.width * 0.5582720, size.height * 0.3912448);
    path_41.cubicTo(
        size.width * 0.4925677,
        size.height * 0.3912448,
        size.width * 0.4333756,
        size.height * 0.3726717,
        size.width * 0.3908073,
        size.height * 0.3430076);
    path_41.cubicTo(
        size.width * 0.3481415,
        size.height * 0.3132752,
        size.width * 0.3230152,
        size.height * 0.2731103,
        size.width * 0.3230152,
        size.height * 0.2299497);
    path_41.lineTo(size.width * 0.3108201, size.height * 0.2299497);
    path_41.cubicTo(
        size.width * 0.3108201,
        size.height * 0.2796786,
        size.width * 0.3397226,
        size.height * 0.3236097,
        size.width * 0.3844098,
        size.height * 0.3547503);
    path_41.cubicTo(
        size.width * 0.4291945,
        size.height * 0.3859593,
        size.width * 0.4906799,
        size.height * 0.4050379,
        size.width * 0.5582720,
        size.height * 0.4050379);
    path_41.lineTo(size.width * 0.5582720, size.height * 0.3912448);
    path_41.close();
    path_41.moveTo(size.width * 0.7935305, size.height * 0.2299497);
    path_41.cubicTo(
        size.width * 0.7935305,
        size.height * 0.2731103,
        size.width * 0.7684024,
        size.height * 0.3132752,
        size.width * 0.7257378,
        size.height * 0.3430076);
    path_41.cubicTo(
        size.width * 0.6831707,
        size.height * 0.3726717,
        size.width * 0.6239756,
        size.height * 0.3912448,
        size.width * 0.5582720,
        size.height * 0.3912448);
    path_41.lineTo(size.width * 0.5582720, size.height * 0.4050379);
    path_41.cubicTo(
        size.width * 0.6258659,
        size.height * 0.4050379,
        size.width * 0.6873476,
        size.height * 0.3859593,
        size.width * 0.7321341,
        size.height * 0.3547503);
    path_41.cubicTo(
        size.width * 0.7768232,
        size.height * 0.3236097,
        size.width * 0.8057256,
        size.height * 0.2796786,
        size.width * 0.8057256,
        size.height * 0.2299497);
    path_41.lineTo(size.width * 0.7935305, size.height * 0.2299497);
    path_41.close();
    path_41.moveTo(size.width * 0.7932805, size.height * 0.2224766);
    path_41.cubicTo(
        size.width * 0.7934451,
        size.height * 0.2249531,
        size.width * 0.7935305,
        size.height * 0.2274441,
        size.width * 0.7935305,
        size.height * 0.2299497);
    path_41.lineTo(size.width * 0.8057256, size.height * 0.2299497);
    path_41.cubicTo(
        size.width * 0.8057256,
        size.height * 0.2270952,
        size.width * 0.8056280,
        size.height * 0.2242552,
        size.width * 0.8054390,
        size.height * 0.2214317);
    path_41.lineTo(size.width * 0.7932805, size.height * 0.2224766);
    path_41.close();
    path_41.moveTo(size.width * 0.7932744, size.height * 0.2214455);
    path_41.cubicTo(
        size.width * 0.7904817,
        size.height * 0.2642455,
        size.width * 0.7642988,
        size.height * 0.3036821,
        size.width * 0.7219512,
        size.height * 0.3326897);
    path_41.cubicTo(
        size.width * 0.6796951,
        size.height * 0.3616386,
        size.width * 0.6220427,
        size.height * 0.3796207,
        size.width * 0.5582720,
        size.height * 0.3796207);
    path_41.lineTo(size.width * 0.5582720, size.height * 0.3934138);
    path_41.cubicTo(
        size.width * 0.6239512,
        size.height * 0.3934138,
        size.width * 0.6838476,
        size.height * 0.3749193,
        size.width * 0.7282744,
        size.height * 0.3444876);
    path_41.cubicTo(
        size.width * 0.7726098,
        size.height * 0.3141166,
        size.width * 0.8022500,
        size.height * 0.2712710,
        size.width * 0.8054390,
        size.height * 0.2224628);
    path_41.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_41.close();
    path_41.moveTo(size.width * 0.5582720, size.height * 0.3796207);
    path_41.cubicTo(
        size.width * 0.4944988,
        size.height * 0.3796207,
        size.width * 0.4368488,
        size.height * 0.3616386,
        size.width * 0.3945896,
        size.height * 0.3326897);
    path_41.cubicTo(
        size.width * 0.3522433,
        size.height * 0.3036821,
        size.width * 0.3260646,
        size.height * 0.2642455,
        size.width * 0.3232665,
        size.height * 0.2214455);
    path_41.lineTo(size.width * 0.3111043, size.height * 0.2224628);
    path_41.cubicTo(
        size.width * 0.3142951,
        size.height * 0.2712710,
        size.width * 0.3439348,
        size.height * 0.3141159,
        size.width * 0.3882720,
        size.height * 0.3444876);
    path_41.cubicTo(
        size.width * 0.4326957,
        size.height * 0.3749193,
        size.width * 0.4925951,
        size.height * 0.3934138,
        size.width * 0.5582720,
        size.height * 0.3934138);
    path_41.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_41.close();

    Paint paint_41_fill = Paint()..style = PaintingStyle.fill;
    paint_41_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_41, paint_41_fill);

    Path path_42 = Path();
    path_42.moveTo(size.width * 0.7796707, size.height * 0.1913793);
    path_42.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2300317,
        size.width * 0.7558537,
        size.height * 0.2656938,
        size.width * 0.7160671,
        size.height * 0.2918931);
    path_42.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3180400,
        size.width * 0.6212927,
        size.height * 0.3343283,
        size.width * 0.5602970,
        size.height * 0.3343283);
    path_42.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3343283,
        size.width * 0.4442335,
        size.height * 0.3180400,
        size.width * 0.4045250,
        size.height * 0.2918931);
    path_42.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2656938,
        size.width * 0.3409213,
        size.height * 0.2300317,
        size.width * 0.3409213,
        size.height * 0.1913793);
    path_42.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1527269,
        size.width * 0.3647378,
        size.height * 0.1170648,
        size.width * 0.4045250,
        size.height * 0.09086552);
    path_42.cubicTo(
        size.width * 0.4442335,
        size.height * 0.06471834,
        size.width * 0.4993000,
        size.height * 0.04843062,
        size.width * 0.5602970,
        size.height * 0.04843062);
    path_42.cubicTo(
        size.width * 0.6212927,
        size.height * 0.04843062,
        size.width * 0.6763598,
        size.height * 0.06471834,
        size.width * 0.7160671,
        size.height * 0.09086552);
    path_42.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1170648,
        size.width * 0.7796707,
        size.height * 0.1527269,
        size.width * 0.7796707,
        size.height * 0.1913793);
    path_42.close();

    Paint paint_42_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_42_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_42, paint_42_stroke);

    Paint paint_42_fill = Paint()..style = PaintingStyle.fill;
    paint_42_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_42, paint_42_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 7
class WinPrizeClaimAsset7 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6776366),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6714021),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2729986,
        size.width * 0.3100006,
        size.height * 0.2467310,
        size.width * 0.3226079,
        size.height * 0.2426034);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2080717);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1773372,
        size.width * 0.3263305,
        size.height * 0.1454572,
        size.width * 0.3437433,
        size.height * 0.1218614);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.05412041,
        size.width * 0.4950689,
        size.height * 0.02758621,
        size.width * 0.5575037,
        size.height * 0.02758621);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.02758621,
        size.width * 0.7592073,
        size.height * 0.08968069,
        size.width * 0.7860122,
        size.height * 0.1389848);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1593966,
        size.width * 0.7993659,
        size.height * 0.1838607,
        size.width * 0.7993659,
        size.height * 0.2078221);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2426034);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2741241,
        size.width * 0.8385183,
        size.height * 0.3180283,
        size.width * 0.8361951,
        size.height * 0.3360400);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6399910);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.6970276,
        size.width * 0.7394512,
        size.height * 0.8084000,
        size.width * 0.5475506,
        size.height * 0.7975931);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.7867862,
        size.width * 0.2890988,
        size.height * 0.6880228,
        size.width * 0.2798091,
        size.height * 0.6399910);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3450462);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5516043, size.height * 0.5887262),
            width: size.width * 0.5083622,
            height: size.height * 0.3259228),
        paint_3_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5768939, size.height * 0.5780490),
            width: size.width * 0.3446463,
            height: size.height * 0.2379876),
        paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.3687598, size.height * 0.5924614);
    path_5.lineTo(size.width * 0.3689591, size.height * 0.5924614);
    path_5.cubicTo(
        size.width * 0.3704841,
        size.height * 0.6118269,
        size.width * 0.3809341,
        size.height * 0.6305814,
        size.width * 0.3998354,
        size.height * 0.6449945);
    path_5.cubicTo(
        size.width * 0.4203299,
        size.height * 0.6606221,
        size.width * 0.4470683,
        size.height * 0.6683600,
        size.width * 0.4736927,
        size.height * 0.6683600);
    path_5.cubicTo(
        size.width * 0.5003171,
        size.height * 0.6683600,
        size.width * 0.5270555,
        size.height * 0.6606221,
        size.width * 0.5475500,
        size.height * 0.6449945);
    path_5.cubicTo(
        size.width * 0.5664512,
        size.height * 0.6305814,
        size.width * 0.5769012,
        size.height * 0.6118269,
        size.width * 0.5784262,
        size.height * 0.5924614);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5924614);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5898752);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5521290);
    path_5.lineTo(size.width * 0.5787122, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.5764256, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.5664116, size.height * 0.5495428);
    path_5.cubicTo(
        size.width * 0.5615482,
        size.height * 0.5424800,
        size.width * 0.5552518,
        size.height * 0.5358910,
        size.width * 0.5475500,
        size.height * 0.5300186);
    path_5.cubicTo(
        size.width * 0.5270555,
        size.height * 0.5143903,
        size.width * 0.5003171,
        size.height * 0.5066524,
        size.width * 0.4736927,
        size.height * 0.5066524);
    path_5.cubicTo(
        size.width * 0.4470683,
        size.height * 0.5066524,
        size.width * 0.4203299,
        size.height * 0.5143903,
        size.width * 0.3998354,
        size.height * 0.5300186);
    path_5.cubicTo(
        size.width * 0.3921335,
        size.height * 0.5358910,
        size.width * 0.3858372,
        size.height * 0.5424800,
        size.width * 0.3809738,
        size.height * 0.5495428);
    path_5.lineTo(size.width * 0.3710463, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5495428);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5521290);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5898752);
    path_5.lineTo(size.width * 0.3687598, size.height * 0.5924614);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.3998427, size.height * 0.6151786);
    path_6.cubicTo(
        size.width * 0.4203372,
        size.height * 0.6308062,
        size.width * 0.4470756,
        size.height * 0.6385448,
        size.width * 0.4737000,
        size.height * 0.6385448);
    path_6.cubicTo(
        size.width * 0.5003244,
        size.height * 0.6385448,
        size.width * 0.5270628,
        size.height * 0.6308062,
        size.width * 0.5475573,
        size.height * 0.6151786);
    path_6.cubicTo(
        size.width * 0.5680713,
        size.height * 0.5995359,
        size.width * 0.5786287,
        size.height * 0.5787766,
        size.width * 0.5786287,
        size.height * 0.5576910);
    path_6.cubicTo(
        size.width * 0.5786287,
        size.height * 0.5366048,
        size.width * 0.5680713,
        size.height * 0.5158455,
        size.width * 0.5475573,
        size.height * 0.5002028);
    path_6.cubicTo(
        size.width * 0.5270628,
        size.height * 0.4845752,
        size.width * 0.5003244,
        size.height * 0.4768372,
        size.width * 0.4737000,
        size.height * 0.4768372);
    path_6.cubicTo(
        size.width * 0.4470756,
        size.height * 0.4768372,
        size.width * 0.4203372,
        size.height * 0.4845752,
        size.width * 0.3998427,
        size.height * 0.5002028);
    path_6.cubicTo(
        size.width * 0.3793287,
        size.height * 0.5158455,
        size.width * 0.3687713,
        size.height * 0.5366048,
        size.width * 0.3687713,
        size.height * 0.5576910);
    path_6.cubicTo(
        size.width * 0.3687713,
        size.height * 0.5787766,
        size.width * 0.3793287,
        size.height * 0.5995359,
        size.width * 0.3998427,
        size.height * 0.6151786);
    path_6.close();

    Paint paint_6_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_6_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_stroke);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.4229915, size.height * 0.5975255);
    path_7.cubicTo(
        size.width * 0.4370927,
        size.height * 0.6082786,
        size.width * 0.4554518,
        size.height * 0.6135793,
        size.width * 0.4736970,
        size.height * 0.6135793);
    path_7.cubicTo(
        size.width * 0.4919415,
        size.height * 0.6135793,
        size.width * 0.5103006,
        size.height * 0.6082786,
        size.width * 0.5244018,
        size.height * 0.5975255);
    path_7.cubicTo(
        size.width * 0.5385226,
        size.height * 0.5867579,
        size.width * 0.5458835,
        size.height * 0.5723883,
        size.width * 0.5458835,
        size.height * 0.5576917);
    path_7.cubicTo(
        size.width * 0.5458835,
        size.height * 0.5429959,
        size.width * 0.5385226,
        size.height * 0.5286262,
        size.width * 0.5244018,
        size.height * 0.5178579);
    path_7.cubicTo(
        size.width * 0.5103006,
        size.height * 0.5071055,
        size.width * 0.4919415,
        size.height * 0.5018048,
        size.width * 0.4736970,
        size.height * 0.5018048);
    path_7.cubicTo(
        size.width * 0.4554518,
        size.height * 0.5018048,
        size.width * 0.4370927,
        size.height * 0.5071055,
        size.width * 0.4229915,
        size.height * 0.5178579);
    path_7.cubicTo(
        size.width * 0.4088707,
        size.height * 0.5286262,
        size.width * 0.4015104,
        size.height * 0.5429959,
        size.width * 0.4015104,
        size.height * 0.5576917);
    path_7.cubicTo(
        size.width * 0.4015104,
        size.height * 0.5723883,
        size.width * 0.4088707,
        size.height * 0.5867579,
        size.width * 0.4229915,
        size.height * 0.5975255);
    path_7.close();

    Paint paint_7_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_7_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_stroke);

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.5066159, size.height * 0.5106559);
    path_8.cubicTo(
        size.width * 0.4812817,
        size.height * 0.5026669,
        size.width * 0.4510360,
        size.height * 0.5065234,
        size.width * 0.4304433,
        size.height * 0.5222262);
    path_8.cubicTo(
        size.width * 0.4031457,
        size.height * 0.5430421,
        size.width * 0.4031457,
        size.height * 0.5767903,
        size.width * 0.4304433,
        size.height * 0.5976055);
    path_8.cubicTo(
        size.width * 0.4354457,
        size.height * 0.6014200,
        size.width * 0.4410177,
        size.height * 0.6045352,
        size.width * 0.4469506,
        size.height * 0.6069517);
    path_8.cubicTo(
        size.width * 0.4387024,
        size.height * 0.6043510,
        size.width * 0.4309744,
        size.height * 0.6004938,
        size.width * 0.4242701,
        size.height * 0.5953814);
    path_8.cubicTo(
        size.width * 0.3969726,
        size.height * 0.5745662,
        size.width * 0.3969726,
        size.height * 0.5408179,
        size.width * 0.4242701,
        size.height * 0.5200028);
    path_8.cubicTo(
        size.width * 0.4465652,
        size.height * 0.5030021,
        size.width * 0.4801744,
        size.height * 0.4998862,
        size.width * 0.5066159,
        size.height * 0.5106559);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.5526598, size.height * 0.5388007);
    path_9.cubicTo(
        size.width * 0.5541854,
        size.height * 0.5581662,
        size.width * 0.5646354,
        size.height * 0.5769214,
        size.width * 0.5835366,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.6040311,
        size.height * 0.6069614,
        size.width * 0.6307683,
        size.height * 0.6147000,
        size.width * 0.6573963,
        size.height * 0.6147000);
    path_9.cubicTo(
        size.width * 0.6840183,
        size.height * 0.6147000,
        size.width * 0.7107561,
        size.height * 0.6069614,
        size.width * 0.7312500,
        size.height * 0.5913338);
    path_9.cubicTo(
        size.width * 0.7501524,
        size.height * 0.5769214,
        size.width * 0.7606037,
        size.height * 0.5581662,
        size.width * 0.7621280,
        size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5388007);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.7624146, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7601280, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.7501098, size.height * 0.4958828);
    path_9.cubicTo(
        size.width * 0.7452500,
        size.height * 0.4888193,
        size.width * 0.7389512,
        size.height * 0.4822310,
        size.width * 0.7312500,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.7107561,
        size.height * 0.4607303,
        size.width * 0.6840183,
        size.height * 0.4529917,
        size.width * 0.6573963,
        size.height * 0.4529917);
    path_9.cubicTo(
        size.width * 0.6307683,
        size.height * 0.4529917,
        size.width * 0.6040311,
        size.height * 0.4607303,
        size.width * 0.5835366,
        size.height * 0.4763579);
    path_9.cubicTo(
        size.width * 0.5758348,
        size.height * 0.4822310,
        size.width * 0.5695384,
        size.height * 0.4888193,
        size.width * 0.5646744,
        size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5547470, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4958828);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.4984690);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5362145);
    path_9.lineTo(size.width * 0.5524604, size.height * 0.5388007);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffB17518).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5835439, size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.6040384,
        size.height * 0.5771476,
        size.width * 0.6307744,
        size.height * 0.5848862,
        size.width * 0.6574024,
        size.height * 0.5848862);
    path_10.cubicTo(
        size.width * 0.6840244,
        size.height * 0.5848862,
        size.width * 0.7107622,
        size.height * 0.5771476,
        size.width * 0.7312561,
        size.height * 0.5615200);
    path_10.cubicTo(
        size.width * 0.7517744,
        size.height * 0.5458772,
        size.width * 0.7623293,
        size.height * 0.5251179,
        size.width * 0.7623293,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.7623293,
        size.height * 0.4829462,
        size.width * 0.7517744,
        size.height * 0.4621869,
        size.width * 0.7312561,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.7107622,
        size.height * 0.4309166,
        size.width * 0.6840244,
        size.height * 0.4231779,
        size.width * 0.6574024,
        size.height * 0.4231779);
    path_10.cubicTo(
        size.width * 0.6307744,
        size.height * 0.4231779,
        size.width * 0.6040384,
        size.height * 0.4309166,
        size.width * 0.5835439,
        size.height * 0.4465441);
    path_10.cubicTo(
        size.width * 0.5630299,
        size.height * 0.4621869,
        size.width * 0.5524726,
        size.height * 0.4829462,
        size.width * 0.5524726,
        size.height * 0.5040324);
    path_10.cubicTo(
        size.width * 0.5524726,
        size.height * 0.5251179,
        size.width * 0.5630299,
        size.height * 0.5458772,
        size.width * 0.5835439,
        size.height * 0.5615200);
    path_10.close();

    Paint paint_10_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_10_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_stroke);

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.6066927, size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.6207927,
        size.height * 0.5546179,
        size.width * 0.6391524,
        size.height * 0.5599186,
        size.width * 0.6573963,
        size.height * 0.5599186);
    path_11.cubicTo(
        size.width * 0.6756402,
        size.height * 0.5599186,
        size.width * 0.6940000,
        size.height * 0.5546179,
        size.width * 0.7081037,
        size.height * 0.5438655);
    path_11.cubicTo(
        size.width * 0.7222256,
        size.height * 0.5330979,
        size.width * 0.7295854,
        size.height * 0.5187283,
        size.width * 0.7295854,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.7295854,
        size.height * 0.4893352,
        size.width * 0.7222256,
        size.height * 0.4749655,
        size.width * 0.7081037,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.6940000,
        size.height * 0.4534455,
        size.width * 0.6756402,
        size.height * 0.4481448,
        size.width * 0.6573963,
        size.height * 0.4481448);
    path_11.cubicTo(
        size.width * 0.6391524,
        size.height * 0.4481448,
        size.width * 0.6207927,
        size.height * 0.4534455,
        size.width * 0.6066927,
        size.height * 0.4641979);
    path_11.cubicTo(
        size.width * 0.5925720,
        size.height * 0.4749655,
        size.width * 0.5852110,
        size.height * 0.4893352,
        size.width * 0.5852110,
        size.height * 0.5040317);
    path_11.cubicTo(
        size.width * 0.5852110,
        size.height * 0.5187283,
        size.width * 0.5925720,
        size.height * 0.5330979,
        size.width * 0.6066927,
        size.height * 0.5438655);
    path_11.close();

    Paint paint_11_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_11_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_stroke);

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.6903171, size.height * 0.4569959);
    path_12.cubicTo(
        size.width * 0.6649817,
        size.height * 0.4490062,
        size.width * 0.6347378,
        size.height * 0.4528634,
        size.width * 0.6141463,
        size.height * 0.4685662);
    path_12.cubicTo(
        size.width * 0.5868463,
        size.height * 0.4893814,
        size.width * 0.5868463,
        size.height * 0.5231297,
        size.width * 0.6141463,
        size.height * 0.5439448);
    path_12.cubicTo(
        size.width * 0.6191463,
        size.height * 0.5477593,
        size.width * 0.6247195,
        size.height * 0.5508752,
        size.width * 0.6306524,
        size.height * 0.5532917);
    path_12.cubicTo(
        size.width * 0.6224024,
        size.height * 0.5506903,
        size.width * 0.6146768,
        size.height * 0.5468338,
        size.width * 0.6079707,
        size.height * 0.5417214);
    path_12.cubicTo(
        size.width * 0.5806732,
        size.height * 0.5209055,
        size.width * 0.5806732,
        size.height * 0.4871572,
        size.width * 0.6079707,
        size.height * 0.4663421);
    path_12.cubicTo(
        size.width * 0.6302683,
        size.height * 0.4493414,
        size.width * 0.6638780,
        size.height * 0.4462262,
        size.width * 0.6903171,
        size.height * 0.4569959);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.5449695, size.height * 0.4958455);
    path_13.lineTo(size.width * 0.5451689, size.height * 0.4958455);
    path_13.cubicTo(
        size.width * 0.5466945,
        size.height * 0.5152110,
        size.width * 0.5571445,
        size.height * 0.5339655,
        size.width * 0.5760457,
        size.height * 0.5483786);
    path_13.cubicTo(
        size.width * 0.5965402,
        size.height * 0.5640062,
        size.width * 0.6232805,
        size.height * 0.5717448,
        size.width * 0.6499024,
        size.height * 0.5717448);
    path_13.cubicTo(
        size.width * 0.6765244,
        size.height * 0.5717448,
        size.width * 0.7032683,
        size.height * 0.5640062,
        size.width * 0.7237622,
        size.height * 0.5483786);
    path_13.cubicTo(
        size.width * 0.7426585,
        size.height * 0.5339655,
        size.width * 0.7531098,
        size.height * 0.5152110,
        size.width * 0.7546341,
        size.height * 0.4958455);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4958455);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4932593);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4555138);
    path_13.lineTo(size.width * 0.7549207, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.7526341, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.7426220, size.height * 0.4529276);
    path_13.cubicTo(
        size.width * 0.7377561,
        size.height * 0.4458641,
        size.width * 0.7314634,
        size.height * 0.4392752,
        size.width * 0.7237622,
        size.height * 0.4334028);
    path_13.cubicTo(
        size.width * 0.7032683,
        size.height * 0.4177752,
        size.width * 0.6765244,
        size.height * 0.4100366,
        size.width * 0.6499024,
        size.height * 0.4100366);
    path_13.cubicTo(
        size.width * 0.6232805,
        size.height * 0.4100366,
        size.width * 0.5965402,
        size.height * 0.4177752,
        size.width * 0.5760457,
        size.height * 0.4334028);
    path_13.cubicTo(
        size.width * 0.5683439,
        size.height * 0.4392752,
        size.width * 0.5620476,
        size.height * 0.4458641,
        size.width * 0.5571835,
        size.height * 0.4529276);
    path_13.lineTo(size.width * 0.5472561, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4529276);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4555138);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4932593);
    path_13.lineTo(size.width * 0.5449695, size.height * 0.4958455);
    path_13.close();

    Paint paint_13_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_13_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_stroke);

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffB17518).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.5760530, size.height * 0.5185648);
    path_14.cubicTo(
        size.width * 0.5965476,
        size.height * 0.5341924,
        size.width * 0.6232866,
        size.height * 0.5419310,
        size.width * 0.6499085,
        size.height * 0.5419310);
    path_14.cubicTo(
        size.width * 0.6765366,
        size.height * 0.5419310,
        size.width * 0.7032744,
        size.height * 0.5341924,
        size.width * 0.7237683,
        size.height * 0.5185648);
    path_14.cubicTo(
        size.width * 0.7442805,
        size.height * 0.5029221,
        size.width * 0.7548415,
        size.height * 0.4821628,
        size.width * 0.7548415,
        size.height * 0.4610766);
    path_14.cubicTo(
        size.width * 0.7548415,
        size.height * 0.4399910,
        size.width * 0.7442805,
        size.height * 0.4192317,
        size.width * 0.7237683,
        size.height * 0.4035890);
    path_14.cubicTo(
        size.width * 0.7032744,
        size.height * 0.3879614,
        size.width * 0.6765366,
        size.height * 0.3802228,
        size.width * 0.6499085,
        size.height * 0.3802228);
    path_14.cubicTo(
        size.width * 0.6232866,
        size.height * 0.3802228,
        size.width * 0.5965476,
        size.height * 0.3879614,
        size.width * 0.5760530,
        size.height * 0.4035890);
    path_14.cubicTo(
        size.width * 0.5555390,
        size.height * 0.4192317,
        size.width * 0.5449817,
        size.height * 0.4399910,
        size.width * 0.5449817,
        size.height * 0.4610766);
    path_14.cubicTo(
        size.width * 0.5449817,
        size.height * 0.4821628,
        size.width * 0.5555390,
        size.height * 0.5029221,
        size.width * 0.5760530,
        size.height * 0.5185648);
    path_14.close();

    Paint paint_14_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_14_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_stroke);

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.5992018, size.height * 0.5009103);
    path_15.cubicTo(
        size.width * 0.6133049,
        size.height * 0.5116628,
        size.width * 0.6316585,
        size.height * 0.5169634,
        size.width * 0.6499085,
        size.height * 0.5169634);
    path_15.cubicTo(
        size.width * 0.6681524,
        size.height * 0.5169634,
        size.width * 0.6865122,
        size.height * 0.5116628,
        size.width * 0.7006098,
        size.height * 0.5009103);
    path_15.cubicTo(
        size.width * 0.7147317,
        size.height * 0.4901428,
        size.width * 0.7220915,
        size.height * 0.4757731,
        size.width * 0.7220915,
        size.height * 0.4610766);
    path_15.cubicTo(
        size.width * 0.7220915,
        size.height * 0.4463800,
        size.width * 0.7147317,
        size.height * 0.4320103,
        size.width * 0.7006098,
        size.height * 0.4212428);
    path_15.cubicTo(
        size.width * 0.6865122,
        size.height * 0.4104897,
        size.width * 0.6681524,
        size.height * 0.4051890,
        size.width * 0.6499085,
        size.height * 0.4051890);
    path_15.cubicTo(
        size.width * 0.6316585,
        size.height * 0.4051890,
        size.width * 0.6133049,
        size.height * 0.4104897,
        size.width * 0.5992018,
        size.height * 0.4212428);
    path_15.cubicTo(
        size.width * 0.5850805,
        size.height * 0.4320103,
        size.width * 0.5777201,
        size.height * 0.4463800,
        size.width * 0.5777201,
        size.height * 0.4610766);
    path_15.cubicTo(
        size.width * 0.5777201,
        size.height * 0.4757731,
        size.width * 0.5850805,
        size.height * 0.4901428,
        size.width * 0.5992018,
        size.height * 0.5009103);
    path_15.close();

    Paint paint_15_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_15_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_stroke);

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.6828232, size.height * 0.4140407);
    path_16.cubicTo(
        size.width * 0.6574939,
        size.height * 0.4060510,
        size.width * 0.6272439,
        size.height * 0.4099083,
        size.width * 0.6066530,
        size.height * 0.4256110);
    path_16.cubicTo(
        size.width * 0.5793555,
        size.height * 0.4464262,
        size.width * 0.5793555,
        size.height * 0.4801745,
        size.width * 0.6066530,
        size.height * 0.5009897);
    path_16.cubicTo(
        size.width * 0.6116585,
        size.height * 0.5048041,
        size.width * 0.6172256,
        size.height * 0.5079200,
        size.width * 0.6231585,
        size.height * 0.5103359);
    path_16.cubicTo(
        size.width * 0.6149146,
        size.height * 0.5077352,
        size.width * 0.6071848,
        size.height * 0.5038779,
        size.width * 0.6004799,
        size.height * 0.4987655);
    path_16.cubicTo(
        size.width * 0.5731823,
        size.height * 0.4779503,
        size.width * 0.5731823,
        size.height * 0.4442021,
        size.width * 0.6004799,
        size.height * 0.4233869);
    path_16.cubicTo(
        size.width * 0.6227744,
        size.height * 0.4063862,
        size.width * 0.6563841,
        size.height * 0.4032703,
        size.width * 0.6828232,
        size.height * 0.4140407);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.5559738, size.height * 0.4456269);
    path_17.lineTo(size.width * 0.5561732, size.height * 0.4456269);
    path_17.cubicTo(
        size.width * 0.5576982,
        size.height * 0.4649924,
        size.width * 0.5681488,
        size.height * 0.4837469,
        size.width * 0.5870500,
        size.height * 0.4981600);
    path_17.cubicTo(
        size.width * 0.6075445,
        size.height * 0.5137876,
        size.width * 0.6342805,
        size.height * 0.5215255,
        size.width * 0.6609085,
        size.height * 0.5215255);
    path_17.cubicTo(
        size.width * 0.6875305,
        size.height * 0.5215255,
        size.width * 0.7142683,
        size.height * 0.5137876,
        size.width * 0.7347622,
        size.height * 0.4981600);
    path_17.cubicTo(
        size.width * 0.7536646,
        size.height * 0.4837469,
        size.width * 0.7641159,
        size.height * 0.4649924,
        size.width * 0.7656402,
        size.height * 0.4456269);
    path_17.lineTo(size.width * 0.7659268, size.height * 0.4456269);
    path_17.lineTo(size.width * 0.7659268, size.height * 0.4430407);
    path_17.lineTo(size.width * 0.7659268, size.height * 0.4052945);
    path_17.lineTo(size.width * 0.7659268, size.height * 0.4027083);
    path_17.lineTo(size.width * 0.7636402, size.height * 0.4027083);
    path_17.lineTo(size.width * 0.7536280, size.height * 0.4027083);
    path_17.cubicTo(
        size.width * 0.7487622,
        size.height * 0.3956448,
        size.width * 0.7424634,
        size.height * 0.3890566,
        size.width * 0.7347622,
        size.height * 0.3831834);
    path_17.cubicTo(
        size.width * 0.7142683,
        size.height * 0.3675559,
        size.width * 0.6875305,
        size.height * 0.3598179,
        size.width * 0.6609085,
        size.height * 0.3598179);
    path_17.cubicTo(
        size.width * 0.6342805,
        size.height * 0.3598179,
        size.width * 0.6075445,
        size.height * 0.3675559,
        size.width * 0.5870500,
        size.height * 0.3831834);
    path_17.cubicTo(
        size.width * 0.5793482,
        size.height * 0.3890566,
        size.width * 0.5730518,
        size.height * 0.3956448,
        size.width * 0.5681878,
        size.height * 0.4027083);
    path_17.lineTo(size.width * 0.5582604, size.height * 0.4027083);
    path_17.lineTo(size.width * 0.5559738, size.height * 0.4027083);
    path_17.lineTo(size.width * 0.5559738, size.height * 0.4052945);
    path_17.lineTo(size.width * 0.5559738, size.height * 0.4430407);
    path_17.lineTo(size.width * 0.5559738, size.height * 0.4456269);
    path_17.close();

    Paint paint_17_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_17_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_stroke);

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xffB17518).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.5870573, size.height * 0.4683462);
    path_18.cubicTo(
        size.width * 0.6075518,
        size.height * 0.4839738,
        size.width * 0.6342927,
        size.height * 0.4917117,
        size.width * 0.6609146,
        size.height * 0.4917117);
    path_18.cubicTo(
        size.width * 0.6875366,
        size.height * 0.4917117,
        size.width * 0.7142744,
        size.height * 0.4839738,
        size.width * 0.7347683,
        size.height * 0.4683462);
    path_18.cubicTo(
        size.width * 0.7552866,
        size.height * 0.4527034,
        size.width * 0.7658415,
        size.height * 0.4319441,
        size.width * 0.7658415,
        size.height * 0.4108579);
    path_18.cubicTo(
        size.width * 0.7658415,
        size.height * 0.3897717,
        size.width * 0.7552866,
        size.height * 0.3690124,
        size.width * 0.7347683,
        size.height * 0.3533697);
    path_18.cubicTo(
        size.width * 0.7142744,
        size.height * 0.3377421,
        size.width * 0.6875366,
        size.height * 0.3300041,
        size.width * 0.6609146,
        size.height * 0.3300041);
    path_18.cubicTo(
        size.width * 0.6342927,
        size.height * 0.3300041,
        size.width * 0.6075518,
        size.height * 0.3377421,
        size.width * 0.5870573,
        size.height * 0.3533697);
    path_18.cubicTo(
        size.width * 0.5665427,
        size.height * 0.3690124,
        size.width * 0.5559854,
        size.height * 0.3897717,
        size.width * 0.5559854,
        size.height * 0.4108579);
    path_18.cubicTo(
        size.width * 0.5559854,
        size.height * 0.4319441,
        size.width * 0.5665427,
        size.height * 0.4527034,
        size.width * 0.5870573,
        size.height * 0.4683462);
    path_18.close();

    Paint paint_18_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_18_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_stroke);

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(size.width * 0.6102073, size.height * 0.4506910);
    path_19.cubicTo(
        size.width * 0.6243049,
        size.height * 0.4614441,
        size.width * 0.6426646,
        size.height * 0.4667448,
        size.width * 0.6609085,
        size.height * 0.4667448);
    path_19.cubicTo(
        size.width * 0.6791585,
        size.height * 0.4667448,
        size.width * 0.6975122,
        size.height * 0.4614441,
        size.width * 0.7116159,
        size.height * 0.4506910);
    path_19.cubicTo(
        size.width * 0.7257378,
        size.height * 0.4399234,
        size.width * 0.7330976,
        size.height * 0.4255538,
        size.width * 0.7330976,
        size.height * 0.4108572);
    path_19.cubicTo(
        size.width * 0.7330976,
        size.height * 0.3961614,
        size.width * 0.7257378,
        size.height * 0.3817910,
        size.width * 0.7116159,
        size.height * 0.3710234);
    path_19.cubicTo(
        size.width * 0.6975122,
        size.height * 0.3602710,
        size.width * 0.6791585,
        size.height * 0.3549703,
        size.width * 0.6609085,
        size.height * 0.3549703);
    path_19.cubicTo(
        size.width * 0.6426646,
        size.height * 0.3549703,
        size.width * 0.6243049,
        size.height * 0.3602710,
        size.width * 0.6102073,
        size.height * 0.3710234);
    path_19.cubicTo(
        size.width * 0.5960848,
        size.height * 0.3817910,
        size.width * 0.5887244,
        size.height * 0.3961614,
        size.width * 0.5887244,
        size.height * 0.4108572);
    path_19.cubicTo(
        size.width * 0.5887244,
        size.height * 0.4255538,
        size.width * 0.5960848,
        size.height * 0.4399234,
        size.width * 0.6102073,
        size.height * 0.4506910);
    path_19.close();

    Paint paint_19_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_19_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_stroke);

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.6938293, size.height * 0.3638214);
    path_20.cubicTo(
        size.width * 0.6684939,
        size.height * 0.3558324,
        size.width * 0.6382500,
        size.height * 0.3596890,
        size.width * 0.6176585,
        size.height * 0.3753917);
    path_20.cubicTo(
        size.width * 0.5903598,
        size.height * 0.3962069,
        size.width * 0.5903598,
        size.height * 0.4299552,
        size.width * 0.6176585,
        size.height * 0.4507710);
    path_20.cubicTo(
        size.width * 0.6226585,
        size.height * 0.4545855,
        size.width * 0.6282317,
        size.height * 0.4577007,
        size.width * 0.6341646,
        size.height * 0.4601172);
    path_20.cubicTo(
        size.width * 0.6259146,
        size.height * 0.4575159,
        size.width * 0.6181890,
        size.height * 0.4536593,
        size.width * 0.6114817,
        size.height * 0.4485469);
    path_20.cubicTo(
        size.width * 0.5841866,
        size.height * 0.4277317,
        size.width * 0.5841866,
        size.height * 0.3939834,
        size.width * 0.6114817,
        size.height * 0.3731683);
    path_20.cubicTo(
        size.width * 0.6337805,
        size.height * 0.3561676,
        size.width * 0.6673902,
        size.height * 0.3530517,
        size.width * 0.6938293,
        size.height * 0.3638214);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.5339299, size.height * 0.3877655);
    path_21.lineTo(size.width * 0.5341293, size.height * 0.3877655);
    path_21.cubicTo(
        size.width * 0.5356543,
        size.height * 0.4071310,
        size.width * 0.5461043,
        size.height * 0.4258855,
        size.width * 0.5650055,
        size.height * 0.4402986);
    path_21.cubicTo(
        size.width * 0.5855000,
        size.height * 0.4559262,
        size.width * 0.6122378,
        size.height * 0.4636641,
        size.width * 0.6388598,
        size.height * 0.4636641);
    path_21.cubicTo(
        size.width * 0.6654878,
        size.height * 0.4636641,
        size.width * 0.6922256,
        size.height * 0.4559262,
        size.width * 0.7127195,
        size.height * 0.4402986);
    path_21.cubicTo(
        size.width * 0.7316220,
        size.height * 0.4258855,
        size.width * 0.7420732,
        size.height * 0.4071310,
        size.width * 0.7435976,
        size.height * 0.3877655);
    path_21.lineTo(size.width * 0.7438841, size.height * 0.3877655);
    path_21.lineTo(size.width * 0.7438841, size.height * 0.3851793);
    path_21.lineTo(size.width * 0.7438841, size.height * 0.3474331);
    path_21.lineTo(size.width * 0.7438841, size.height * 0.3448469);
    path_21.lineTo(size.width * 0.7415976, size.height * 0.3448469);
    path_21.lineTo(size.width * 0.7315793, size.height * 0.3448469);
    path_21.cubicTo(
        size.width * 0.7267195,
        size.height * 0.3377841,
        size.width * 0.7204207,
        size.height * 0.3311952,
        size.width * 0.7127195,
        size.height * 0.3253221);
    path_21.cubicTo(
        size.width * 0.6922256,
        size.height * 0.3096945,
        size.width * 0.6654878,
        size.height * 0.3019566,
        size.width * 0.6388598,
        size.height * 0.3019566);
    path_21.cubicTo(
        size.width * 0.6122378,
        size.height * 0.3019566,
        size.width * 0.5855000,
        size.height * 0.3096945,
        size.width * 0.5650055,
        size.height * 0.3253221);
    path_21.cubicTo(
        size.width * 0.5573037,
        size.height * 0.3311952,
        size.width * 0.5510073,
        size.height * 0.3377841,
        size.width * 0.5461439,
        size.height * 0.3448469);
    path_21.lineTo(size.width * 0.5362165, size.height * 0.3448469);
    path_21.lineTo(size.width * 0.5339299, size.height * 0.3448469);
    path_21.lineTo(size.width * 0.5339299, size.height * 0.3474331);
    path_21.lineTo(size.width * 0.5339299, size.height * 0.3851793);
    path_21.lineTo(size.width * 0.5339299, size.height * 0.3877655);
    path_21.close();

    Paint paint_21_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_21_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_stroke);

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.5650128, size.height * 0.4104848);
    path_22.cubicTo(
        size.width * 0.5855073,
        size.height * 0.4261124,
        size.width * 0.6122439,
        size.height * 0.4338503,
        size.width * 0.6388720,
        size.height * 0.4338503);
    path_22.cubicTo(
        size.width * 0.6654939,
        size.height * 0.4338503,
        size.width * 0.6922317,
        size.height * 0.4261124,
        size.width * 0.7127256,
        size.height * 0.4104848);
    path_22.cubicTo(
        size.width * 0.7332439,
        size.height * 0.3948421,
        size.width * 0.7437988,
        size.height * 0.3740828,
        size.width * 0.7437988,
        size.height * 0.3529966);
    path_22.cubicTo(
        size.width * 0.7437988,
        size.height * 0.3319103,
        size.width * 0.7332439,
        size.height * 0.3111510,
        size.width * 0.7127256,
        size.height * 0.2955083);
    path_22.cubicTo(
        size.width * 0.6922317,
        size.height * 0.2798807,
        size.width * 0.6654939,
        size.height * 0.2721428,
        size.width * 0.6388720,
        size.height * 0.2721428);
    path_22.cubicTo(
        size.width * 0.6122439,
        size.height * 0.2721428,
        size.width * 0.5855073,
        size.height * 0.2798807,
        size.width * 0.5650128,
        size.height * 0.2955083);
    path_22.cubicTo(
        size.width * 0.5444988,
        size.height * 0.3111510,
        size.width * 0.5339415,
        size.height * 0.3319103,
        size.width * 0.5339415,
        size.height * 0.3529966);
    path_22.cubicTo(
        size.width * 0.5339415,
        size.height * 0.3740828,
        size.width * 0.5444988,
        size.height * 0.3948421,
        size.width * 0.5650128,
        size.height * 0.4104848);
    path_22.close();

    Paint paint_22_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_22_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_stroke);

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(size.width * 0.5881616, size.height * 0.3928297);
    path_23.cubicTo(
        size.width * 0.6022628,
        size.height * 0.4035828,
        size.width * 0.6206220,
        size.height * 0.4088834,
        size.width * 0.6388659,
        size.height * 0.4088834);
    path_23.cubicTo(
        size.width * 0.6571098,
        size.height * 0.4088834,
        size.width * 0.6754695,
        size.height * 0.4035828,
        size.width * 0.6895732,
        size.height * 0.3928297);
    path_23.cubicTo(
        size.width * 0.7036951,
        size.height * 0.3820621,
        size.width * 0.7110549,
        size.height * 0.3676924,
        size.width * 0.7110549,
        size.height * 0.3529959);
    path_23.cubicTo(
        size.width * 0.7110549,
        size.height * 0.3383000,
        size.width * 0.7036951,
        size.height * 0.3239297,
        size.width * 0.6895732,
        size.height * 0.3131621);
    path_23.cubicTo(
        size.width * 0.6754695,
        size.height * 0.3024097,
        size.width * 0.6571098,
        size.height * 0.2971090,
        size.width * 0.6388659,
        size.height * 0.2971090);
    path_23.cubicTo(
        size.width * 0.6206220,
        size.height * 0.2971090,
        size.width * 0.6022628,
        size.height * 0.3024097,
        size.width * 0.5881616,
        size.height * 0.3131621);
    path_23.cubicTo(
        size.width * 0.5740409,
        size.height * 0.3239297,
        size.width * 0.5666799,
        size.height * 0.3383000,
        size.width * 0.5666799,
        size.height * 0.3529959);
    path_23.cubicTo(
        size.width * 0.5666799,
        size.height * 0.3676924,
        size.width * 0.5740409,
        size.height * 0.3820621,
        size.width * 0.5881616,
        size.height * 0.3928297);
    path_23.close();

    Paint paint_23_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_23_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_stroke);

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(size.width * 0.6717866, size.height * 0.3059600);
    path_24.cubicTo(
        size.width * 0.6464512,
        size.height * 0.2979710,
        size.width * 0.6162073,
        size.height * 0.3018276,
        size.width * 0.5956134,
        size.height * 0.3175303);
    path_24.cubicTo(
        size.width * 0.5683159,
        size.height * 0.3383462,
        size.width * 0.5683159,
        size.height * 0.3720938,
        size.width * 0.5956134,
        size.height * 0.3929097);
    path_24.cubicTo(
        size.width * 0.6006159,
        size.height * 0.3967241,
        size.width * 0.6061878,
        size.height * 0.3998393,
        size.width * 0.6121220,
        size.height * 0.4022559);
    path_24.cubicTo(
        size.width * 0.6038726,
        size.height * 0.3996552,
        size.width * 0.5961445,
        size.height * 0.3957979,
        size.width * 0.5894402,
        size.height * 0.3906855);
    path_24.cubicTo(
        size.width * 0.5621421,
        size.height * 0.3698703,
        size.width * 0.5621421,
        size.height * 0.3361221,
        size.width * 0.5894402,
        size.height * 0.3153069);
    path_24.cubicTo(
        size.width * 0.6117378,
        size.height * 0.2983062,
        size.width * 0.6453415,
        size.height * 0.2951903,
        size.width * 0.6717866,
        size.height * 0.3059600);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(size.width * 0.3841341, size.height * 0.5519172);
    path_25.lineTo(size.width * 0.3843293, size.height * 0.5519172);
    path_25.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5712572,
        size.width * 0.3960012,
        size.height * 0.5900103,
        size.width * 0.4144537,
        size.height * 0.6044331);
    path_25.cubicTo(
        size.width * 0.4344610,
        size.height * 0.6200717,
        size.width * 0.4605652,
        size.height * 0.6278159,
        size.width * 0.4865591,
        size.height * 0.6278159);
    path_25.cubicTo(
        size.width * 0.5125524,
        size.height * 0.6278159,
        size.width * 0.5386567,
        size.height * 0.6200717,
        size.width * 0.5586640,
        size.height * 0.6044331);
    path_25.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5900103,
        size.width * 0.5873012,
        size.height * 0.5712572,
        size.width * 0.5887884,
        size.height * 0.5519172);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.5519172);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.5493310);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.5115848);
    path_25.lineTo(size.width * 0.5890683, size.height * 0.5089986);
    path_25.lineTo(size.width * 0.5867817, size.height * 0.5089986);
    path_25.lineTo(size.width * 0.5770561, size.height * 0.5089986);
    path_25.cubicTo(
        size.width * 0.5723134,
        size.height * 0.5019441,
        size.width * 0.5661738,
        size.height * 0.4953607,
        size.width * 0.5586640,
        size.height * 0.4894910);
    path_25.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4738524,
        size.width * 0.5125524,
        size.height * 0.4661083,
        size.width * 0.4865591,
        size.height * 0.4661083);
    path_25.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4661083,
        size.width * 0.4344610,
        size.height * 0.4738524,
        size.width * 0.4144537,
        size.height * 0.4894910);
    path_25.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4953607,
        size.width * 0.4008049,
        size.height * 0.5019441,
        size.width * 0.3960616,
        size.height * 0.5089986);
    path_25.lineTo(size.width * 0.3864207, size.height * 0.5089986);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.5089986);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.5115848);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.5493310);
    path_25.lineTo(size.width * 0.3841341, size.height * 0.5519172);
    path_25.close();

    Paint paint_25_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_25_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_stroke);

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(size.width * 0.4144494, size.height * 0.5746214);
    path_26.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5902593,
        size.width * 0.4605610,
        size.height * 0.5980041,
        size.width * 0.4865543,
        size.height * 0.5980041);
    path_26.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5980041,
        size.width * 0.5386524,
        size.height * 0.5902593,
        size.width * 0.5586598,
        size.height * 0.5746214);
    path_26.cubicTo(
        size.width * 0.5786890,
        size.height * 0.5589655,
        size.width * 0.5889744,
        size.height * 0.5382069,
        size.width * 0.5889744,
        size.height * 0.5171503);
    path_26.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4960931,
        size.width * 0.5786890,
        size.height * 0.4753345,
        size.width * 0.5586598,
        size.height * 0.4596786);
    path_26.cubicTo(
        size.width * 0.5386524,
        size.height * 0.4440407,
        size.width * 0.5125482,
        size.height * 0.4362959,
        size.width * 0.4865543,
        size.height * 0.4362959);
    path_26.cubicTo(
        size.width * 0.4605610,
        size.height * 0.4362959,
        size.width * 0.4344567,
        size.height * 0.4440407,
        size.width * 0.4144494,
        size.height * 0.4596786);
    path_26.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4753345,
        size.width * 0.3841341,
        size.height * 0.4960931,
        size.width * 0.3841341,
        size.height * 0.5171503);
    path_26.cubicTo(
        size.width * 0.3841341,
        size.height * 0.5382069,
        size.width * 0.3944201,
        size.height * 0.5589655,
        size.width * 0.4144494,
        size.height * 0.5746214);
    path_26.close();

    Paint paint_26_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_26_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_stroke);

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(size.width * 0.4370348, size.height * 0.5569669);
    path_27.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5677297,
        size.width * 0.4687348,
        size.height * 0.5730366,
        size.width * 0.4865537,
        size.height * 0.5730366);
    path_27.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5730366,
        size.width * 0.5223018,
        size.height * 0.5677297,
        size.width * 0.5360720,
        size.height * 0.5569662);
    path_27.cubicTo(
        size.width * 0.5498646,
        size.height * 0.5461862,
        size.width * 0.5570317,
        size.height * 0.5318166,
        size.width * 0.5570317,
        size.height * 0.5171497);
    path_27.cubicTo(
        size.width * 0.5570317,
        size.height * 0.5024821,
        size.width * 0.5498646,
        size.height * 0.4881131,
        size.width * 0.5360720,
        size.height * 0.4773324);
    path_27.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4665690,
        size.width * 0.5043726,
        size.height * 0.4612628,
        size.width * 0.4865537,
        size.height * 0.4612628);
    path_27.cubicTo(
        size.width * 0.4687348,
        size.height * 0.4612628,
        size.width * 0.4508049,
        size.height * 0.4665690,
        size.width * 0.4370348,
        size.height * 0.4773324);
    path_27.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4881131,
        size.width * 0.4160750,
        size.height * 0.5024821,
        size.width * 0.4160750,
        size.height * 0.5171497);
    path_27.cubicTo(
        size.width * 0.4160750,
        size.height * 0.5318166,
        size.width * 0.4232427,
        size.height * 0.5461862,
        size.width * 0.4370348,
        size.height * 0.5569669);
    path_27.close();

    Paint paint_27_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_27_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_stroke);

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(size.width * 0.5186683, size.height * 0.4701138);
    path_28.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4621241,
        size.width * 0.4644470,
        size.height * 0.4659814,
        size.width * 0.4443573,
        size.height * 0.4816841);
    path_28.cubicTo(
        size.width * 0.4177262,
        size.height * 0.5024993,
        size.width * 0.4177262,
        size.height * 0.5362476,
        size.width * 0.4443573,
        size.height * 0.5570628);
    path_28.cubicTo(
        size.width * 0.4492372,
        size.height * 0.5608772,
        size.width * 0.4546732,
        size.height * 0.5639931,
        size.width * 0.4604610,
        size.height * 0.5664097);
    path_28.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5638083,
        size.width * 0.4448756,
        size.height * 0.5599517,
        size.width * 0.4383348,
        size.height * 0.5548393);
    path_28.cubicTo(
        size.width * 0.4117043,
        size.height * 0.5340234,
        size.width * 0.4117043,
        size.height * 0.5002752,
        size.width * 0.4383348,
        size.height * 0.4794600);
    path_28.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4624593,
        size.width * 0.4928726,
        size.height * 0.4593441,
        size.width * 0.5186683,
        size.height * 0.4701138);
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);

    Path path_29 = Path();
    path_29.moveTo(size.width * 0.3841341, size.height * 0.4901428);
    path_29.lineTo(size.width * 0.3843293, size.height * 0.4901428);
    path_29.cubicTo(
        size.width * 0.3858171,
        size.height * 0.5094828,
        size.width * 0.3960012,
        size.height * 0.5282359,
        size.width * 0.4144537,
        size.height * 0.5426593);
    path_29.cubicTo(
        size.width * 0.4344610,
        size.height * 0.5582972,
        size.width * 0.4605652,
        size.height * 0.5660414,
        size.width * 0.4865591,
        size.height * 0.5660414);
    path_29.cubicTo(
        size.width * 0.5125524,
        size.height * 0.5660414,
        size.width * 0.5386567,
        size.height * 0.5582972,
        size.width * 0.5586640,
        size.height * 0.5426593);
    path_29.cubicTo(
        size.width * 0.5771165,
        size.height * 0.5282359,
        size.width * 0.5873012,
        size.height * 0.5094828,
        size.width * 0.5887884,
        size.height * 0.4901428);
    path_29.lineTo(size.width * 0.5890683, size.height * 0.4901428);
    path_29.lineTo(size.width * 0.5890683, size.height * 0.4875566);
    path_29.lineTo(size.width * 0.5890683, size.height * 0.4498110);
    path_29.lineTo(size.width * 0.5890683, size.height * 0.4472248);
    path_29.lineTo(size.width * 0.5867817, size.height * 0.4472248);
    path_29.lineTo(size.width * 0.5770561, size.height * 0.4472248);
    path_29.cubicTo(
        size.width * 0.5723134,
        size.height * 0.4401697,
        size.width * 0.5661738,
        size.height * 0.4335862,
        size.width * 0.5586640,
        size.height * 0.4277166);
    path_29.cubicTo(
        size.width * 0.5386567,
        size.height * 0.4120779,
        size.width * 0.5125524,
        size.height * 0.4043338,
        size.width * 0.4865591,
        size.height * 0.4043338);
    path_29.cubicTo(
        size.width * 0.4605652,
        size.height * 0.4043338,
        size.width * 0.4344610,
        size.height * 0.4120779,
        size.width * 0.4144537,
        size.height * 0.4277166);
    path_29.cubicTo(
        size.width * 0.4069439,
        size.height * 0.4335862,
        size.width * 0.4008049,
        size.height * 0.4401697,
        size.width * 0.3960616,
        size.height * 0.4472248);
    path_29.lineTo(size.width * 0.3864207, size.height * 0.4472248);
    path_29.lineTo(size.width * 0.3841341, size.height * 0.4472248);
    path_29.lineTo(size.width * 0.3841341, size.height * 0.4498110);
    path_29.lineTo(size.width * 0.3841341, size.height * 0.4875566);
    path_29.lineTo(size.width * 0.3841341, size.height * 0.4901428);
    path_29.close();

    Paint paint_29_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_29_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_stroke);

    Paint paint_29_fill = Paint()..style = PaintingStyle.fill;
    paint_29_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_fill);

    Path path_30 = Path();
    path_30.moveTo(size.width * 0.4144494, size.height * 0.5128469);
    path_30.cubicTo(
        size.width * 0.4344567,
        size.height * 0.5284855,
        size.width * 0.4605610,
        size.height * 0.5362297,
        size.width * 0.4865543,
        size.height * 0.5362297);
    path_30.cubicTo(
        size.width * 0.5125482,
        size.height * 0.5362297,
        size.width * 0.5386524,
        size.height * 0.5284855,
        size.width * 0.5586598,
        size.height * 0.5128469);
    path_30.cubicTo(
        size.width * 0.5786890,
        size.height * 0.4971917,
        size.width * 0.5889744,
        size.height * 0.4764324,
        size.width * 0.5889744,
        size.height * 0.4553759);
    path_30.cubicTo(
        size.width * 0.5889744,
        size.height * 0.4343186,
        size.width * 0.5786890,
        size.height * 0.4135600,
        size.width * 0.5586598,
        size.height * 0.3979048);
    path_30.cubicTo(
        size.width * 0.5386524,
        size.height * 0.3822662,
        size.width * 0.5125482,
        size.height * 0.3745221,
        size.width * 0.4865543,
        size.height * 0.3745221);
    path_30.cubicTo(
        size.width * 0.4605610,
        size.height * 0.3745221,
        size.width * 0.4344567,
        size.height * 0.3822662,
        size.width * 0.4144494,
        size.height * 0.3979048);
    path_30.cubicTo(
        size.width * 0.3944201,
        size.height * 0.4135600,
        size.width * 0.3841341,
        size.height * 0.4343193,
        size.width * 0.3841341,
        size.height * 0.4553759);
    path_30.cubicTo(
        size.width * 0.3841341,
        size.height * 0.4764324,
        size.width * 0.3944201,
        size.height * 0.4971917,
        size.width * 0.4144494,
        size.height * 0.5128469);
    path_30.close();

    Paint paint_30_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_30_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_stroke);

    Paint paint_30_fill = Paint()..style = PaintingStyle.fill;
    paint_30_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_fill);

    Path path_31 = Path();
    path_31.moveTo(size.width * 0.4370348, size.height * 0.4951924);
    path_31.cubicTo(
        size.width * 0.4508049,
        size.height * 0.5059559,
        size.width * 0.4687348,
        size.height * 0.5112621,
        size.width * 0.4865537,
        size.height * 0.5112621);
    path_31.cubicTo(
        size.width * 0.5043726,
        size.height * 0.5112621,
        size.width * 0.5223018,
        size.height * 0.5059559,
        size.width * 0.5360720,
        size.height * 0.4951924);
    path_31.cubicTo(
        size.width * 0.5498646,
        size.height * 0.4844117,
        size.width * 0.5570317,
        size.height * 0.4700428,
        size.width * 0.5570317,
        size.height * 0.4553752);
    path_31.cubicTo(
        size.width * 0.5570317,
        size.height * 0.4407083,
        size.width * 0.5498646,
        size.height * 0.4263386,
        size.width * 0.5360720,
        size.height * 0.4155579);
    path_31.cubicTo(
        size.width * 0.5223018,
        size.height * 0.4047952,
        size.width * 0.5043726,
        size.height * 0.3994883,
        size.width * 0.4865537,
        size.height * 0.3994883);
    path_31.cubicTo(
        size.width * 0.4687348,
        size.height * 0.3994883,
        size.width * 0.4508049,
        size.height * 0.4047952,
        size.width * 0.4370348,
        size.height * 0.4155579);
    path_31.cubicTo(
        size.width * 0.4232427,
        size.height * 0.4263386,
        size.width * 0.4160750,
        size.height * 0.4407083,
        size.width * 0.4160750,
        size.height * 0.4553752);
    path_31.cubicTo(
        size.width * 0.4160750,
        size.height * 0.4700428,
        size.width * 0.4232427,
        size.height * 0.4844117,
        size.width * 0.4370348,
        size.height * 0.4951924);
    path_31.close();

    Paint paint_31_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_31_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_stroke);

    Paint paint_31_fill = Paint()..style = PaintingStyle.fill;
    paint_31_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_fill);

    Path path_32 = Path();
    path_32.moveTo(size.width * 0.5186683, size.height * 0.4083393);
    path_32.cubicTo(
        size.width * 0.4939530,
        size.height * 0.4003503,
        size.width * 0.4644470,
        size.height * 0.4042069,
        size.width * 0.4443573,
        size.height * 0.4199097);
    path_32.cubicTo(
        size.width * 0.4177262,
        size.height * 0.4407248,
        size.width * 0.4177262,
        size.height * 0.4744731,
        size.width * 0.4443573,
        size.height * 0.4952883);
    path_32.cubicTo(
        size.width * 0.4492372,
        size.height * 0.4991028,
        size.width * 0.4546732,
        size.height * 0.5022186,
        size.width * 0.4604610,
        size.height * 0.5046352);
    path_32.cubicTo(
        size.width * 0.4524146,
        size.height * 0.5020338,
        size.width * 0.4448756,
        size.height * 0.4981772,
        size.width * 0.4383348,
        size.height * 0.4930648);
    path_32.cubicTo(
        size.width * 0.4117043,
        size.height * 0.4722497,
        size.width * 0.4117043,
        size.height * 0.4385014,
        size.width * 0.4383348,
        size.height * 0.4176855);
    path_32.cubicTo(
        size.width * 0.4600848,
        size.height * 0.4006848,
        size.width * 0.4928726,
        size.height * 0.3975697,
        size.width * 0.5186683,
        size.height * 0.4083393);
    path_32.close();

    Paint paint_32_fill = Paint()..style = PaintingStyle.fill;
    paint_32_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_32, paint_32_fill);

    Path path_33 = Path();
    path_33.moveTo(size.width * 0.3589817, size.height * 0.4509676);
    path_33.lineTo(size.width * 0.3591768, size.height * 0.4509676);
    path_33.cubicTo(
        size.width * 0.3606646,
        size.height * 0.4703076,
        size.width * 0.3708488,
        size.height * 0.4890607,
        size.width * 0.3893012,
        size.height * 0.5034834);
    path_33.cubicTo(
        size.width * 0.4093085,
        size.height * 0.5191221,
        size.width * 0.4354128,
        size.height * 0.5268662,
        size.width * 0.4614067,
        size.height * 0.5268662);
    path_33.cubicTo(
        size.width * 0.4874000,
        size.height * 0.5268662,
        size.width * 0.5135043,
        size.height * 0.5191221,
        size.width * 0.5335116,
        size.height * 0.5034834);
    path_33.cubicTo(
        size.width * 0.5519640,
        size.height * 0.4890607,
        size.width * 0.5621488,
        size.height * 0.4703076,
        size.width * 0.5636360,
        size.height * 0.4509676);
    path_33.lineTo(size.width * 0.5639159, size.height * 0.4509676);
    path_33.lineTo(size.width * 0.5639159, size.height * 0.4483814);
    path_33.lineTo(size.width * 0.5639159, size.height * 0.4106352);
    path_33.lineTo(size.width * 0.5639159, size.height * 0.4080490);
    path_33.lineTo(size.width * 0.5616293, size.height * 0.4080490);
    path_33.lineTo(size.width * 0.5519037, size.height * 0.4080490);
    path_33.cubicTo(
        size.width * 0.5471610,
        size.height * 0.4009945,
        size.width * 0.5410213,
        size.height * 0.3944110,
        size.width * 0.5335116,
        size.height * 0.3885414);
    path_33.cubicTo(
        size.width * 0.5135043,
        size.height * 0.3729028,
        size.width * 0.4874000,
        size.height * 0.3651586,
        size.width * 0.4614067,
        size.height * 0.3651586);
    path_33.cubicTo(
        size.width * 0.4354128,
        size.height * 0.3651586,
        size.width * 0.4093085,
        size.height * 0.3729028,
        size.width * 0.3893012,
        size.height * 0.3885414);
    path_33.cubicTo(
        size.width * 0.3817915,
        size.height * 0.3944110,
        size.width * 0.3756524,
        size.height * 0.4009945,
        size.width * 0.3709091,
        size.height * 0.4080490);
    path_33.lineTo(size.width * 0.3612683, size.height * 0.4080490);
    path_33.lineTo(size.width * 0.3589817, size.height * 0.4080490);
    path_33.lineTo(size.width * 0.3589817, size.height * 0.4106352);
    path_33.lineTo(size.width * 0.3589817, size.height * 0.4483814);
    path_33.lineTo(size.width * 0.3589817, size.height * 0.4509676);
    path_33.close();

    Paint paint_33_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_33_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_33, paint_33_stroke);

    Paint paint_33_fill = Paint()..style = PaintingStyle.fill;
    paint_33_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_33, paint_33_fill);

    Path path_34 = Path();
    path_34.moveTo(size.width * 0.3892970, size.height * 0.4736717);
    path_34.cubicTo(
        size.width * 0.4093043,
        size.height * 0.4893097,
        size.width * 0.4354085,
        size.height * 0.4970545,
        size.width * 0.4614018,
        size.height * 0.4970545);
    path_34.cubicTo(
        size.width * 0.4873957,
        size.height * 0.4970545,
        size.width * 0.5135000,
        size.height * 0.4893097,
        size.width * 0.5335073,
        size.height * 0.4736717);
    path_34.cubicTo(
        size.width * 0.5535366,
        size.height * 0.4580159,
        size.width * 0.5638220,
        size.height * 0.4372572,
        size.width * 0.5638220,
        size.height * 0.4162007);
    path_34.cubicTo(
        size.width * 0.5638220,
        size.height * 0.3951434,
        size.width * 0.5535366,
        size.height * 0.3743848,
        size.width * 0.5335073,
        size.height * 0.3587290);
    path_34.cubicTo(
        size.width * 0.5135000,
        size.height * 0.3430910,
        size.width * 0.4873957,
        size.height * 0.3353462,
        size.width * 0.4614018,
        size.height * 0.3353462);
    path_34.cubicTo(
        size.width * 0.4354085,
        size.height * 0.3353462,
        size.width * 0.4093043,
        size.height * 0.3430910,
        size.width * 0.3892970,
        size.height * 0.3587290);
    path_34.cubicTo(
        size.width * 0.3692677,
        size.height * 0.3743848,
        size.width * 0.3589817,
        size.height * 0.3951434,
        size.width * 0.3589817,
        size.height * 0.4162007);
    path_34.cubicTo(
        size.width * 0.3589817,
        size.height * 0.4372572,
        size.width * 0.3692677,
        size.height * 0.4580159,
        size.width * 0.3892970,
        size.height * 0.4736717);
    path_34.close();

    Paint paint_34_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_34_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_34, paint_34_stroke);

    Paint paint_34_fill = Paint()..style = PaintingStyle.fill;
    paint_34_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_34, paint_34_fill);

    Path path_35 = Path();
    path_35.moveTo(size.width * 0.4118823, size.height * 0.4560172);
    path_35.cubicTo(
        size.width * 0.4256524,
        size.height * 0.4667800,
        size.width * 0.4435823,
        size.height * 0.4720869,
        size.width * 0.4614012,
        size.height * 0.4720869);
    path_35.cubicTo(
        size.width * 0.4792201,
        size.height * 0.4720869,
        size.width * 0.4971494,
        size.height * 0.4667800,
        size.width * 0.5109195,
        size.height * 0.4560172);
    path_35.cubicTo(
        size.width * 0.5247122,
        size.height * 0.4452366,
        size.width * 0.5318793,
        size.height * 0.4308669,
        size.width * 0.5318793,
        size.height * 0.4162000);
    path_35.cubicTo(
        size.width * 0.5318793,
        size.height * 0.4015324,
        size.width * 0.5247122,
        size.height * 0.3871634,
        size.width * 0.5109195,
        size.height * 0.3763828);
    path_35.cubicTo(
        size.width * 0.4971494,
        size.height * 0.3656193,
        size.width * 0.4792201,
        size.height * 0.3603131,
        size.width * 0.4614012,
        size.height * 0.3603131);
    path_35.cubicTo(
        size.width * 0.4435823,
        size.height * 0.3603131,
        size.width * 0.4256524,
        size.height * 0.3656193,
        size.width * 0.4118823,
        size.height * 0.3763828);
    path_35.cubicTo(
        size.width * 0.3980902,
        size.height * 0.3871634,
        size.width * 0.3909226,
        size.height * 0.4015324,
        size.width * 0.3909226,
        size.height * 0.4162000);
    path_35.cubicTo(
        size.width * 0.3909226,
        size.height * 0.4308669,
        size.width * 0.3980902,
        size.height * 0.4452366,
        size.width * 0.4118823,
        size.height * 0.4560172);
    path_35.close();

    Paint paint_35_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_35_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_35, paint_35_stroke);

    Paint paint_35_fill = Paint()..style = PaintingStyle.fill;
    paint_35_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_35, paint_35_fill);

    Path path_36 = Path();
    path_36.moveTo(size.width * 0.4935159, size.height * 0.3691641);
    path_36.cubicTo(
        size.width * 0.4688006,
        size.height * 0.3611745,
        size.width * 0.4392945,
        size.height * 0.3650317,
        size.width * 0.4192049,
        size.height * 0.3807345);
    path_36.cubicTo(
        size.width * 0.3925738,
        size.height * 0.4015497,
        size.width * 0.3925738,
        size.height * 0.4352979,
        size.width * 0.4192049,
        size.height * 0.4561131);
    path_36.cubicTo(
        size.width * 0.4240848,
        size.height * 0.4599276,
        size.width * 0.4295207,
        size.height * 0.4630434,
        size.width * 0.4353085,
        size.height * 0.4654600);
    path_36.cubicTo(
        size.width * 0.4272622,
        size.height * 0.4628586,
        size.width * 0.4197232,
        size.height * 0.4590021,
        size.width * 0.4131823,
        size.height * 0.4538897);
    path_36.cubicTo(
        size.width * 0.3865518,
        size.height * 0.4330738,
        size.width * 0.3865518,
        size.height * 0.3993255,
        size.width * 0.4131823,
        size.height * 0.3785103);
    path_36.cubicTo(
        size.width * 0.4349323,
        size.height * 0.3615097,
        size.width * 0.4677201,
        size.height * 0.3583945,
        size.width * 0.4935159,
        size.height * 0.3691641);
    path_36.close();

    Paint paint_36_fill = Paint()..style = PaintingStyle.fill;
    paint_36_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_36, paint_36_fill);

    Path path_37 = Path();
    path_37.moveTo(size.width * 0.3660561, size.height * 0.4026731);
    path_37.lineTo(size.width * 0.3662512, size.height * 0.4026731);
    path_37.cubicTo(
        size.width * 0.3677390,
        size.height * 0.4220131,
        size.width * 0.3779232,
        size.height * 0.4407662,
        size.width * 0.3963756,
        size.height * 0.4551897);
    path_37.cubicTo(
        size.width * 0.4163829,
        size.height * 0.4708276,
        size.width * 0.4424872,
        size.height * 0.4785717,
        size.width * 0.4684805,
        size.height * 0.4785717);
    path_37.cubicTo(
        size.width * 0.4944744,
        size.height * 0.4785717,
        size.width * 0.5205787,
        size.height * 0.4708276,
        size.width * 0.5405860,
        size.height * 0.4551897);
    path_37.cubicTo(
        size.width * 0.5590384,
        size.height * 0.4407662,
        size.width * 0.5692226,
        size.height * 0.4220131,
        size.width * 0.5707104,
        size.height * 0.4026731);
    path_37.lineTo(size.width * 0.5709896, size.height * 0.4026731);
    path_37.lineTo(size.width * 0.5709896, size.height * 0.4000869);
    path_37.lineTo(size.width * 0.5709896, size.height * 0.3623414);
    path_37.lineTo(size.width * 0.5709896, size.height * 0.3597552);
    path_37.lineTo(size.width * 0.5687030, size.height * 0.3597552);
    path_37.lineTo(size.width * 0.5589780, size.height * 0.3597552);
    path_37.cubicTo(
        size.width * 0.5542348,
        size.height * 0.3527000,
        size.width * 0.5480957,
        size.height * 0.3461166,
        size.width * 0.5405860,
        size.height * 0.3402469);
    path_37.cubicTo(
        size.width * 0.5205787,
        size.height * 0.3246083,
        size.width * 0.4944744,
        size.height * 0.3168641,
        size.width * 0.4684805,
        size.height * 0.3168641);
    path_37.cubicTo(
        size.width * 0.4424872,
        size.height * 0.3168641,
        size.width * 0.4163829,
        size.height * 0.3246083,
        size.width * 0.3963756,
        size.height * 0.3402469);
    path_37.cubicTo(
        size.width * 0.3888659,
        size.height * 0.3461166,
        size.width * 0.3827268,
        size.height * 0.3527000,
        size.width * 0.3779835,
        size.height * 0.3597552);
    path_37.lineTo(size.width * 0.3683427, size.height * 0.3597552);
    path_37.lineTo(size.width * 0.3660561, size.height * 0.3597552);
    path_37.lineTo(size.width * 0.3660561, size.height * 0.3623414);
    path_37.lineTo(size.width * 0.3660561, size.height * 0.4000869);
    path_37.lineTo(size.width * 0.3660561, size.height * 0.4026731);
    path_37.close();

    Paint paint_37_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_37_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_37, paint_37_stroke);

    Paint paint_37_fill = Paint()..style = PaintingStyle.fill;
    paint_37_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_37, paint_37_fill);

    Path path_38 = Path();
    path_38.moveTo(size.width * 0.3963713, size.height * 0.4253772);
    path_38.cubicTo(
        size.width * 0.4163787,
        size.height * 0.4410159,
        size.width * 0.4424829,
        size.height * 0.4487600,
        size.width * 0.4684762,
        size.height * 0.4487600);
    path_38.cubicTo(
        size.width * 0.4944695,
        size.height * 0.4487600,
        size.width * 0.5205738,
        size.height * 0.4410159,
        size.width * 0.5405811,
        size.height * 0.4253772);
    path_38.cubicTo(
        size.width * 0.5606104,
        size.height * 0.4097214,
        size.width * 0.5708963,
        size.height * 0.3889628,
        size.width * 0.5708963,
        size.height * 0.3679062);
    path_38.cubicTo(
        size.width * 0.5708963,
        size.height * 0.3468490,
        size.width * 0.5606104,
        size.height * 0.3260903,
        size.width * 0.5405811,
        size.height * 0.3104345);
    path_38.cubicTo(
        size.width * 0.5205738,
        size.height * 0.2947966,
        size.width * 0.4944695,
        size.height * 0.2870524,
        size.width * 0.4684762,
        size.height * 0.2870524);
    path_38.cubicTo(
        size.width * 0.4424829,
        size.height * 0.2870524,
        size.width * 0.4163787,
        size.height * 0.2947966,
        size.width * 0.3963713,
        size.height * 0.3104352);
    path_38.cubicTo(
        size.width * 0.3763421,
        size.height * 0.3260903,
        size.width * 0.3660561,
        size.height * 0.3468490,
        size.width * 0.3660561,
        size.height * 0.3679062);
    path_38.cubicTo(
        size.width * 0.3660561,
        size.height * 0.3889628,
        size.width * 0.3763421,
        size.height * 0.4097214,
        size.width * 0.3963713,
        size.height * 0.4253772);
    path_38.close();

    Paint paint_38_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_38_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_38, paint_38_stroke);

    Paint paint_38_fill = Paint()..style = PaintingStyle.fill;
    paint_38_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_38, paint_38_fill);

    Path path_39 = Path();
    path_39.moveTo(size.width * 0.4189561, size.height * 0.4077228);
    path_39.cubicTo(
        size.width * 0.4327268,
        size.height * 0.4184855,
        size.width * 0.4506561,
        size.height * 0.4237924,
        size.width * 0.4684750,
        size.height * 0.4237924);
    path_39.cubicTo(
        size.width * 0.4862939,
        size.height * 0.4237924,
        size.width * 0.5042238,
        size.height * 0.4184855,
        size.width * 0.5179939,
        size.height * 0.4077228);
    path_39.cubicTo(
        size.width * 0.5317860,
        size.height * 0.3969421,
        size.width * 0.5389537,
        size.height * 0.3825724,
        size.width * 0.5389537,
        size.height * 0.3679055);
    path_39.cubicTo(
        size.width * 0.5389537,
        size.height * 0.3532386,
        size.width * 0.5317860,
        size.height * 0.3388690,
        size.width * 0.5179939,
        size.height * 0.3280883);
    path_39.cubicTo(
        size.width * 0.5042238,
        size.height * 0.3173255,
        size.width * 0.4862939,
        size.height * 0.3120186,
        size.width * 0.4684750,
        size.height * 0.3120186);
    path_39.cubicTo(
        size.width * 0.4506561,
        size.height * 0.3120186,
        size.width * 0.4327268,
        size.height * 0.3173255,
        size.width * 0.4189561,
        size.height * 0.3280883);
    path_39.cubicTo(
        size.width * 0.4051640,
        size.height * 0.3388690,
        size.width * 0.3979970,
        size.height * 0.3532386,
        size.width * 0.3979970,
        size.height * 0.3679055);
    path_39.cubicTo(
        size.width * 0.3979970,
        size.height * 0.3825724,
        size.width * 0.4051640,
        size.height * 0.3969421,
        size.width * 0.4189561,
        size.height * 0.4077228);
    path_39.close();

    Paint paint_39_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_39_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_39, paint_39_stroke);

    Paint paint_39_fill = Paint()..style = PaintingStyle.fill;
    paint_39_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_39, paint_39_fill);

    Path path_40 = Path();
    path_40.moveTo(size.width * 0.5005896, size.height * 0.3208697);
    path_40.cubicTo(
        size.width * 0.4758744,
        size.height * 0.3128807,
        size.width * 0.4463683,
        size.height * 0.3167372,
        size.width * 0.4262787,
        size.height * 0.3324400);
    path_40.cubicTo(
        size.width * 0.3996482,
        size.height * 0.3532552,
        size.width * 0.3996482,
        size.height * 0.3870034,
        size.width * 0.4262787,
        size.height * 0.4078186);
    path_40.cubicTo(
        size.width * 0.4311591,
        size.height * 0.4116331,
        size.width * 0.4365951,
        size.height * 0.4147490,
        size.width * 0.4423829,
        size.height * 0.4171655);
    path_40.cubicTo(
        size.width * 0.4343360,
        size.height * 0.4145641,
        size.width * 0.4267970,
        size.height * 0.4107076,
        size.width * 0.4202561,
        size.height * 0.4055952);
    path_40.cubicTo(
        size.width * 0.3936256,
        size.height * 0.3847800,
        size.width * 0.3936256,
        size.height * 0.3510317,
        size.width * 0.4202561,
        size.height * 0.3302159);
    path_40.cubicTo(
        size.width * 0.4420067,
        size.height * 0.3132152,
        size.width * 0.4747945,
        size.height * 0.3101000,
        size.width * 0.5005896,
        size.height * 0.3208697);
    path_40.close();

    Paint paint_40_fill = Paint()..style = PaintingStyle.fill;
    paint_40_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_40, paint_40_fill);

    Path path_41 = Path();
    path_41.moveTo(size.width * 0.5458835, size.height * 0.5110014);
    path_41.lineTo(size.width * 0.5460049, size.height * 0.5111745);
    path_41.cubicTo(
        size.width * 0.5335348,
        size.height * 0.5245131,
        size.width * 0.5268768,
        size.height * 0.5451938,
        size.width * 0.5283567,
        size.height * 0.5705076);
    path_41.cubicTo(
        size.width * 0.5299622,
        size.height * 0.5979545,
        size.width * 0.5408244,
        size.height * 0.6258966,
        size.width * 0.5569811,
        size.height * 0.6489262);
    path_41.cubicTo(
        size.width * 0.5731384,
        size.height * 0.6719566,
        size.width * 0.5947280,
        size.height * 0.6902690,
        size.width * 0.6179939,
        size.height * 0.6982759);
    path_41.cubicTo(
        size.width * 0.6394512,
        size.height * 0.7056621,
        size.width * 0.6587744,
        size.height * 0.7030276,
        size.width * 0.6730915,
        size.height * 0.6923241);
    path_41.lineTo(size.width * 0.6732683, size.height * 0.6925724);
    path_41.lineTo(size.width * 0.6750549, size.height * 0.6909655);
    path_41.lineTo(size.width * 0.7012012, size.height * 0.6675028);
    path_41.lineTo(size.width * 0.7029939, size.height * 0.6658952);
    path_41.lineTo(size.width * 0.7015671, size.height * 0.6638690);
    path_41.lineTo(size.width * 0.6955244, size.height * 0.6552524);
    path_41.cubicTo(
        size.width * 0.6974634,
        size.height * 0.6466648,
        size.width * 0.6982073,
        size.height * 0.6371338,
        size.width * 0.6976037,
        size.height * 0.6268317);
    path_41.cubicTo(
        size.width * 0.6960000,
        size.height * 0.5993848,
        size.width * 0.6851341,
        size.height * 0.5714428,
        size.width * 0.6689817,
        size.height * 0.5484124);
    path_41.cubicTo(
        size.width * 0.6528232,
        size.height * 0.5253821,
        size.width * 0.6312317,
        size.height * 0.5070676,
        size.width * 0.6079659,
        size.height * 0.4990614);
    path_41.cubicTo(
        size.width * 0.5992323,
        size.height * 0.4960566,
        size.width * 0.5908567,
        size.height * 0.4947090,
        size.width * 0.5830226,
        size.height * 0.4948917);
    path_41.lineTo(size.width * 0.5770299, size.height * 0.4863503);
    path_41.lineTo(size.width * 0.5756085, size.height * 0.4843241);
    path_41.lineTo(size.width * 0.5738177, size.height * 0.4859317);
    path_41.lineTo(size.width * 0.5476750, size.height * 0.5093938);
    path_41.lineTo(size.width * 0.5458835, size.height * 0.5110014);
    path_41.close();

    Paint paint_41_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_41_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_41, paint_41_stroke);

    Paint paint_41_fill = Paint()..style = PaintingStyle.fill;
    paint_41_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_41, paint_41_fill);

    Path path_42 = Path();
    path_42.moveTo(size.width * 0.5490049, size.height * 0.5519772);
    path_42.cubicTo(
        size.width * 0.5506098,
        size.height * 0.5794241,
        size.width * 0.5614720,
        size.height * 0.6073662,
        size.width * 0.5776293,
        size.height * 0.6303966);
    path_42.cubicTo(
        size.width * 0.5937860,
        size.height * 0.6534269,
        size.width * 0.6153780,
        size.height * 0.6717414,
        size.width * 0.6386402,
        size.height * 0.6797469);
    path_42.cubicTo(
        size.width * 0.6619329,
        size.height * 0.6877621,
        size.width * 0.6827073,
        size.height * 0.6839717,
        size.width * 0.6972927,
        size.height * 0.6708834);
    path_42.cubicTo(
        size.width * 0.7118720,
        size.height * 0.6577952,
        size.width * 0.7198598,
        size.height * 0.6357786,
        size.width * 0.7182500,
        size.height * 0.6083014);
    path_42.cubicTo(
        size.width * 0.7166463,
        size.height * 0.5808545,
        size.width * 0.7057866,
        size.height * 0.5529124,
        size.width * 0.6896280,
        size.height * 0.5298821);
    path_42.cubicTo(
        size.width * 0.6734695,
        size.height * 0.5068524,
        size.width * 0.6518780,
        size.height * 0.4885372,
        size.width * 0.6286159,
        size.height * 0.4805317);
    path_42.cubicTo(
        size.width * 0.6053213,
        size.height * 0.4725166,
        size.width * 0.5845500,
        size.height * 0.4763069,
        size.width * 0.5699665,
        size.height * 0.4893952);
    path_42.cubicTo(
        size.width * 0.5553823,
        size.height * 0.5024841,
        size.width * 0.5473982,
        size.height * 0.5245000,
        size.width * 0.5490049,
        size.height * 0.5519772);
    path_42.close();

    Paint paint_42_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_42_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_42, paint_42_stroke);

    Paint paint_42_fill = Paint()..style = PaintingStyle.fill;
    paint_42_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_42, paint_42_fill);

    Path path_43 = Path();
    path_43.moveTo(size.width * 0.5752695, size.height * 0.5610131);
    path_43.cubicTo(
        size.width * 0.5763744,
        size.height * 0.5799041,
        size.width * 0.5838433,
        size.height * 0.5990883,
        size.width * 0.5949189,
        size.height * 0.6148759);
    path_43.cubicTo(
        size.width * 0.6059951,
        size.height * 0.6306634,
        size.width * 0.6208171,
        size.height * 0.6432503,
        size.width * 0.6368293,
        size.height * 0.6487607);
    path_43.cubicTo(
        size.width * 0.6528659,
        size.height * 0.6542793,
        size.width * 0.6672744,
        size.height * 0.6516979,
        size.width * 0.6774329,
        size.height * 0.6425814);
    path_43.cubicTo(
        size.width * 0.6875915,
        size.height * 0.6334641,
        size.width * 0.6930915,
        size.height * 0.6181821,
        size.width * 0.6919817,
        size.height * 0.5992614);
    path_43.cubicTo(
        size.width * 0.6908780,
        size.height * 0.5803710,
        size.width * 0.6834085,
        size.height * 0.5611869,
        size.width * 0.6723354,
        size.height * 0.5453993);
    path_43.cubicTo(
        size.width * 0.6612561,
        size.height * 0.5296117,
        size.width * 0.6464390,
        size.height * 0.5170248,
        size.width * 0.6304207,
        size.height * 0.5115145);
    path_43.cubicTo(
        size.width * 0.6143841,
        size.height * 0.5059959,
        size.width * 0.5999768,
        size.height * 0.5085772,
        size.width * 0.5898189,
        size.height * 0.5176938);
    path_43.cubicTo(
        size.width * 0.5796604,
        size.height * 0.5268110,
        size.width * 0.5741628,
        size.height * 0.5420924,
        size.width * 0.5752695,
        size.height * 0.5610131);
    path_43.close();

    Paint paint_43_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_43_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_43, paint_43_stroke);

    Paint paint_43_fill = Paint()..style = PaintingStyle.fill;
    paint_43_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_43, paint_43_fill);

    Path path_44 = Path();
    path_44.moveTo(size.width * 0.6861646, size.height * 0.5793545);
    path_44.cubicTo(
        size.width * 0.6763354,
        size.height * 0.5524910,
        size.width * 0.6553232,
        size.height * 0.5287455,
        size.width * 0.6319634,
        size.height * 0.5207069);
    path_44.cubicTo(
        size.width * 0.6009921,
        size.height * 0.5100503,
        size.width * 0.5776177,
        size.height * 0.5310276,
        size.width * 0.5797543,
        size.height * 0.5675607);
    path_44.cubicTo(
        size.width * 0.5801457,
        size.height * 0.5742559,
        size.width * 0.5813665,
        size.height * 0.5810083,
        size.width * 0.5832909,
        size.height * 0.5876386);
    path_44.cubicTo(
        size.width * 0.5800909,
        size.height * 0.5788924,
        size.width * 0.5780756,
        size.height * 0.5698159,
        size.width * 0.5775512,
        size.height * 0.5608428);
    path_44.cubicTo(
        size.width * 0.5754146,
        size.height * 0.5243097,
        size.width * 0.5987884,
        size.height * 0.5033324,
        size.width * 0.6297561,
        size.height * 0.5139890);
    path_44.cubicTo(
        size.width * 0.6550549,
        size.height * 0.5226924,
        size.width * 0.6775915,
        size.height * 0.5498055,
        size.width * 0.6861646,
        size.height * 0.5793545);
    path_44.close();

    Paint paint_44_fill = Paint()..style = PaintingStyle.fill;
    paint_44_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_44, paint_44_fill);

    Path path_45 = Path();
    path_45.moveTo(size.width * 0.7744024, size.height * 0.2241372);
    path_45.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2138345,
        size.width * 0.7798110,
        size.height * 0.2031117,
        size.width * 0.7798110,
        size.height * 0.1921007);
    path_45.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1124841,
        size.width * 0.6821220,
        size.height * 0.04794248,
        size.width * 0.5616250,
        size.height * 0.04794248);
    path_45.cubicTo(
        size.width * 0.4411250,
        size.height * 0.04794248,
        size.width * 0.3434402,
        size.height * 0.1124841,
        size.width * 0.3434402,
        size.height * 0.1921007);
    path_45.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2031110,
        size.width * 0.3453085,
        size.height * 0.2138331,
        size.width * 0.3488470,
        size.height * 0.2241359);
    path_45.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1599379,
        size.width * 0.4577890,
        size.height * 0.1120138,
        size.width * 0.5616244,
        size.height * 0.1120138);
    path_45.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1120138,
        size.width * 0.7523537,
        size.height * 0.1599393,
        size.width * 0.7744024,
        size.height * 0.2241372);
    path_45.close();

    Paint paint_45_fill = Paint()..style = PaintingStyle.fill;
    paint_45_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_45, paint_45_fill);

    Path path_46 = Path();
    path_46.moveTo(size.width * 0.3293390, size.height * 0.2071000);
    path_46.cubicTo(
        size.width * 0.3255250,
        size.height * 0.2182041,
        size.width * 0.3235116,
        size.height * 0.2297593,
        size.width * 0.3235116,
        size.height * 0.2416255);
    path_46.cubicTo(
        size.width * 0.3235116,
        size.height * 0.3274269,
        size.width * 0.4287841,
        size.height * 0.3969828,
        size.width * 0.5586451,
        size.height * 0.3969828);
    path_46.cubicTo(
        size.width * 0.6885061,
        size.height * 0.3969828,
        size.width * 0.7937805,
        size.height * 0.3274269,
        size.width * 0.7937805,
        size.height * 0.2416255);
    path_46.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2297600,
        size.width * 0.7917683,
        size.height * 0.2182055,
        size.width * 0.7879512,
        size.height * 0.2071021);
    path_46.cubicTo(
        size.width * 0.7641890,
        size.height * 0.2762869,
        size.width * 0.6705488,
        size.height * 0.3279338,
        size.width * 0.5586457,
        size.height * 0.3279338);
    path_46.cubicTo(
        size.width * 0.4467439,
        size.height * 0.3279338,
        size.width * 0.3530988,
        size.height * 0.2762855,
        size.width * 0.3293390,
        size.height * 0.2071000);
    path_46.close();

    Paint paint_46_fill = Paint()..style = PaintingStyle.fill;
    paint_46_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_46, paint_46_fill);

    Path path_47 = Path();
    path_47.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_47.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_47.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_47.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_47.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_47.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_47.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_47.close();

    Paint paint_47_fill = Paint()..style = PaintingStyle.fill;
    paint_47_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_47, paint_47_fill);

    Path path_48 = Path();
    path_48.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_48.cubicTo(
        size.width * 0.3170073,
        size.height * 0.2246041,
        size.width * 0.3169177,
        size.height * 0.2272697,
        size.width * 0.3169177,
        size.height * 0.2299497);
    path_48.cubicTo(
        size.width * 0.3169177,
        size.height * 0.3228393,
        size.width * 0.4249756,
        size.height * 0.3981414,
        size.width * 0.5582720,
        size.height * 0.3981414);
    path_48.cubicTo(
        size.width * 0.6915671,
        size.height * 0.3981414,
        size.width * 0.7996280,
        size.height * 0.3228393,
        size.width * 0.7996280,
        size.height * 0.2299497);
    path_48.cubicTo(
        size.width * 0.7996280,
        size.height * 0.2272697,
        size.width * 0.7995366,
        size.height * 0.2246041,
        size.width * 0.7993598,
        size.height * 0.2219545);
    path_48.cubicTo(
        size.width * 0.7933720,
        size.height * 0.3135621,
        size.width * 0.6877195,
        size.height * 0.3865172,
        size.width * 0.5582720,
        size.height * 0.3865172);
    path_48.cubicTo(
        size.width * 0.4288220,
        size.height * 0.3865172,
        size.width * 0.3231744,
        size.height * 0.3135621,
        size.width * 0.3171854,
        size.height * 0.2219545);
    path_48.close();

    Paint paint_48_fill = Paint()..style = PaintingStyle.fill;
    paint_48_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_48, paint_48_fill);

    Path path_49 = Path();
    path_49.moveTo(size.width * 0.3171854, size.height * 0.2219545);
    path_49.lineTo(size.width * 0.3232665, size.height * 0.2214455);
    path_49.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_49.lineTo(size.width * 0.3171854, size.height * 0.2219545);
    path_49.close();
    path_49.moveTo(size.width * 0.7993598, size.height * 0.2219545);
    path_49.lineTo(size.width * 0.8054390, size.height * 0.2214317);
    path_49.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_49.lineTo(size.width * 0.7993598, size.height * 0.2219545);
    path_49.close();
    path_49.moveTo(size.width * 0.5582720, size.height * 0.3865172);
    path_49.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_49.lineTo(size.width * 0.5582720, size.height * 0.3865172);
    path_49.close();
    path_49.moveTo(size.width * 0.3230152, size.height * 0.2299497);
    path_49.cubicTo(
        size.width * 0.3230152,
        size.height * 0.2274441,
        size.width * 0.3230994,
        size.height * 0.2249531,
        size.width * 0.3232652,
        size.height * 0.2224766);
    path_49.lineTo(size.width * 0.3111055, size.height * 0.2214317);
    path_49.cubicTo(
        size.width * 0.3109159,
        size.height * 0.2242552,
        size.width * 0.3108201,
        size.height * 0.2270945,
        size.width * 0.3108201,
        size.height * 0.2299497);
    path_49.lineTo(size.width * 0.3230152, size.height * 0.2299497);
    path_49.close();
    path_49.moveTo(size.width * 0.5582720, size.height * 0.3912448);
    path_49.cubicTo(
        size.width * 0.4925677,
        size.height * 0.3912448,
        size.width * 0.4333756,
        size.height * 0.3726717,
        size.width * 0.3908073,
        size.height * 0.3430076);
    path_49.cubicTo(
        size.width * 0.3481415,
        size.height * 0.3132752,
        size.width * 0.3230152,
        size.height * 0.2731103,
        size.width * 0.3230152,
        size.height * 0.2299497);
    path_49.lineTo(size.width * 0.3108201, size.height * 0.2299497);
    path_49.cubicTo(
        size.width * 0.3108201,
        size.height * 0.2796786,
        size.width * 0.3397226,
        size.height * 0.3236097,
        size.width * 0.3844098,
        size.height * 0.3547503);
    path_49.cubicTo(
        size.width * 0.4291945,
        size.height * 0.3859593,
        size.width * 0.4906799,
        size.height * 0.4050379,
        size.width * 0.5582720,
        size.height * 0.4050379);
    path_49.lineTo(size.width * 0.5582720, size.height * 0.3912448);
    path_49.close();
    path_49.moveTo(size.width * 0.7935305, size.height * 0.2299497);
    path_49.cubicTo(
        size.width * 0.7935305,
        size.height * 0.2731103,
        size.width * 0.7684024,
        size.height * 0.3132752,
        size.width * 0.7257378,
        size.height * 0.3430076);
    path_49.cubicTo(
        size.width * 0.6831707,
        size.height * 0.3726717,
        size.width * 0.6239756,
        size.height * 0.3912448,
        size.width * 0.5582720,
        size.height * 0.3912448);
    path_49.lineTo(size.width * 0.5582720, size.height * 0.4050379);
    path_49.cubicTo(
        size.width * 0.6258659,
        size.height * 0.4050379,
        size.width * 0.6873476,
        size.height * 0.3859593,
        size.width * 0.7321341,
        size.height * 0.3547503);
    path_49.cubicTo(
        size.width * 0.7768232,
        size.height * 0.3236097,
        size.width * 0.8057256,
        size.height * 0.2796786,
        size.width * 0.8057256,
        size.height * 0.2299497);
    path_49.lineTo(size.width * 0.7935305, size.height * 0.2299497);
    path_49.close();
    path_49.moveTo(size.width * 0.7932805, size.height * 0.2224766);
    path_49.cubicTo(
        size.width * 0.7934451,
        size.height * 0.2249531,
        size.width * 0.7935305,
        size.height * 0.2274441,
        size.width * 0.7935305,
        size.height * 0.2299497);
    path_49.lineTo(size.width * 0.8057256, size.height * 0.2299497);
    path_49.cubicTo(
        size.width * 0.8057256,
        size.height * 0.2270952,
        size.width * 0.8056280,
        size.height * 0.2242552,
        size.width * 0.8054390,
        size.height * 0.2214317);
    path_49.lineTo(size.width * 0.7932805, size.height * 0.2224766);
    path_49.close();
    path_49.moveTo(size.width * 0.7932744, size.height * 0.2214455);
    path_49.cubicTo(
        size.width * 0.7904817,
        size.height * 0.2642455,
        size.width * 0.7642988,
        size.height * 0.3036821,
        size.width * 0.7219512,
        size.height * 0.3326897);
    path_49.cubicTo(
        size.width * 0.6796951,
        size.height * 0.3616386,
        size.width * 0.6220427,
        size.height * 0.3796207,
        size.width * 0.5582720,
        size.height * 0.3796207);
    path_49.lineTo(size.width * 0.5582720, size.height * 0.3934138);
    path_49.cubicTo(
        size.width * 0.6239512,
        size.height * 0.3934138,
        size.width * 0.6838476,
        size.height * 0.3749193,
        size.width * 0.7282744,
        size.height * 0.3444876);
    path_49.cubicTo(
        size.width * 0.7726098,
        size.height * 0.3141166,
        size.width * 0.8022500,
        size.height * 0.2712710,
        size.width * 0.8054390,
        size.height * 0.2224628);
    path_49.lineTo(size.width * 0.7932744, size.height * 0.2214455);
    path_49.close();
    path_49.moveTo(size.width * 0.5582720, size.height * 0.3796207);
    path_49.cubicTo(
        size.width * 0.4944988,
        size.height * 0.3796207,
        size.width * 0.4368488,
        size.height * 0.3616386,
        size.width * 0.3945896,
        size.height * 0.3326897);
    path_49.cubicTo(
        size.width * 0.3522433,
        size.height * 0.3036821,
        size.width * 0.3260646,
        size.height * 0.2642455,
        size.width * 0.3232665,
        size.height * 0.2214455);
    path_49.lineTo(size.width * 0.3111043, size.height * 0.2224628);
    path_49.cubicTo(
        size.width * 0.3142951,
        size.height * 0.2712710,
        size.width * 0.3439348,
        size.height * 0.3141159,
        size.width * 0.3882720,
        size.height * 0.3444876);
    path_49.cubicTo(
        size.width * 0.4326957,
        size.height * 0.3749193,
        size.width * 0.4925951,
        size.height * 0.3934138,
        size.width * 0.5582720,
        size.height * 0.3934138);
    path_49.lineTo(size.width * 0.5582720, size.height * 0.3796207);
    path_49.close();

    Paint paint_49_fill = Paint()..style = PaintingStyle.fill;
    paint_49_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_49, paint_49_fill);

    Path path_50 = Path();
    path_50.moveTo(size.width * 0.7796707, size.height * 0.1913793);
    path_50.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2300317,
        size.width * 0.7558537,
        size.height * 0.2656938,
        size.width * 0.7160671,
        size.height * 0.2918931);
    path_50.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3180400,
        size.width * 0.6212927,
        size.height * 0.3343283,
        size.width * 0.5602970,
        size.height * 0.3343283);
    path_50.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3343283,
        size.width * 0.4442335,
        size.height * 0.3180400,
        size.width * 0.4045250,
        size.height * 0.2918931);
    path_50.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2656938,
        size.width * 0.3409213,
        size.height * 0.2300317,
        size.width * 0.3409213,
        size.height * 0.1913793);
    path_50.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1527269,
        size.width * 0.3647378,
        size.height * 0.1170648,
        size.width * 0.4045250,
        size.height * 0.09086552);
    path_50.cubicTo(
        size.width * 0.4442335,
        size.height * 0.06471834,
        size.width * 0.4993000,
        size.height * 0.04843062,
        size.width * 0.5602970,
        size.height * 0.04843062);
    path_50.cubicTo(
        size.width * 0.6212927,
        size.height * 0.04843062,
        size.width * 0.6763598,
        size.height * 0.06471834,
        size.width * 0.7160671,
        size.height * 0.09086552);
    path_50.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1170648,
        size.width * 0.7796707,
        size.height * 0.1527269,
        size.width * 0.7796707,
        size.height * 0.1913793);
    path_50.close();

    Paint paint_50_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_50_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_50, paint_50_stroke);

    Paint paint_50_fill = Paint()..style = PaintingStyle.fill;
    paint_50_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_50, paint_50_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Asset 8
class WinPrizeClaimAsset8 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff919193).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5000000, size.height * 0.6922552),
            width: size.width * 0.9268293,
            height: size.height * 0.5896552),
        paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff232326).withOpacity(1.0);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5085159, size.height * 0.6860221),
            width: size.width * 0.6422695,
            height: size.height * 0.3652593),
        paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2798091, size.height * 0.3596662);
    path_2.cubicTo(
        size.width * 0.2837902,
        size.height * 0.2876179,
        size.width * 0.3100006,
        size.height * 0.2613510,
        size.width * 0.3226079,
        size.height * 0.2572234);
    path_2.lineTo(size.width * 0.3226079, size.height * 0.2226917);
    path_2.cubicTo(
        size.width * 0.3226079,
        size.height * 0.1919572,
        size.width * 0.3263305,
        size.height * 0.1600766,
        size.width * 0.3437433,
        size.height * 0.1364807);
    path_2.cubicTo(
        size.width * 0.3937329,
        size.height * 0.06874021,
        size.width * 0.4950689,
        size.height * 0.04220600,
        size.width * 0.5575037,
        size.height * 0.04220600);
    path_2.cubicTo(
        size.width * 0.6945610,
        size.height * 0.04220600,
        size.width * 0.7592073,
        size.height * 0.1043000,
        size.width * 0.7860122,
        size.height * 0.1536048);
    path_2.cubicTo(
        size.width * 0.7971098,
        size.height * 0.1740166,
        size.width * 0.7993659,
        size.height * 0.1984800,
        size.width * 0.7993659,
        size.height * 0.2224421);
    path_2.lineTo(size.width * 0.7993659, size.height * 0.2572234);
    path_2.cubicTo(
        size.width * 0.8344024,
        size.height * 0.2887441,
        size.width * 0.8385183,
        size.height * 0.3326483,
        size.width * 0.8361951,
        size.height * 0.3506600);
    path_2.lineTo(size.width * 0.8361951, size.height * 0.6546110);
    path_2.cubicTo(
        size.width * 0.8199390,
        size.height * 0.7116483,
        size.width * 0.7394512,
        size.height * 0.8230207,
        size.width * 0.5475506,
        size.height * 0.8122138);
    path_2.cubicTo(
        size.width * 0.3556524,
        size.height * 0.8014069,
        size.width * 0.2890988,
        size.height * 0.7026414,
        size.width * 0.2798091,
        size.height * 0.6546110);
    path_2.lineTo(size.width * 0.2798091, size.height * 0.3596662);
    path_2.close();

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.009556768;
    paint_2_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.2260640, size.height * 0.7348621);
    path_3.lineTo(size.width * 0.2261494, size.height * 0.7346759);
    path_3.cubicTo(
        size.width * 0.2411811,
        size.height * 0.7417448,
        size.width * 0.2595933,
        size.height * 0.7402897,
        size.width * 0.2784152,
        size.height * 0.7290759);
    path_3.cubicTo(
        size.width * 0.2988232,
        size.height * 0.7169103,
        size.width * 0.3160372,
        size.height * 0.6954759,
        size.width * 0.3274457,
        size.height * 0.6707572);
    path_3.cubicTo(
        size.width * 0.3388543,
        size.height * 0.6460359,
        size.width * 0.3445530,
        size.height * 0.6178097,
        size.width * 0.3417079,
        size.height * 0.5919172);
    path_3.cubicTo(
        size.width * 0.3390829,
        size.height * 0.5680379,
        size.width * 0.3296104,
        size.height * 0.5501207,
        size.width * 0.3158848,
        size.height * 0.5402179);
    path_3.lineTo(size.width * 0.3160073, size.height * 0.5399524);
    path_3.lineTo(size.width * 0.3140848, size.height * 0.5388172);
    path_3.lineTo(size.width * 0.2860220, size.height * 0.5222510);
    path_3.lineTo(size.width * 0.2840988, size.height * 0.5211159);
    path_3.lineTo(size.width * 0.2830951, size.height * 0.5232903);
    path_3.lineTo(size.width * 0.2788268, size.height * 0.5325400);
    path_3.cubicTo(
        size.width * 0.2715000,
        size.height * 0.5339545,
        size.width * 0.2639116,
        size.height * 0.5369041,
        size.width * 0.2562512,
        size.height * 0.5414703);
    path_3.cubicTo(
        size.width * 0.2358439,
        size.height * 0.5536352,
        size.width * 0.2186293,
        size.height * 0.5750634,
        size.width * 0.2072207,
        size.height * 0.5997855);
    path_3.cubicTo(
        size.width * 0.1958122,
        size.height * 0.6245076,
        size.width * 0.1901134,
        size.height * 0.6527331,
        size.width * 0.1929591,
        size.height * 0.6786255);
    path_3.cubicTo(
        size.width * 0.1940268,
        size.height * 0.6883441,
        size.width * 0.1962268,
        size.height * 0.6970690,
        size.width * 0.1993902,
        size.height * 0.7046828);
    path_3.lineTo(size.width * 0.1951591, size.height * 0.7138483);
    path_3.lineTo(size.width * 0.1941555, size.height * 0.7160207);
    path_3.lineTo(size.width * 0.1960780, size.height * 0.7171586);
    path_3.lineTo(size.width * 0.2241415, size.height * 0.7337241);
    path_3.lineTo(size.width * 0.2260640, size.height * 0.7348621);
    path_3.close();

    Paint paint_3_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004337823;
    paint_3_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_stroke);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.2562500, size.height * 0.7159862);
    path_4.cubicTo(
        size.width * 0.2766579,
        size.height * 0.7038207,
        size.width * 0.2938726,
        size.height * 0.6823924,
        size.width * 0.3052805,
        size.height * 0.6576710);
    path_4.cubicTo(
        size.width * 0.3166890,
        size.height * 0.6329490,
        size.width * 0.3223884,
        size.height * 0.6047228,
        size.width * 0.3195427,
        size.height * 0.5788310);
    path_4.cubicTo(
        size.width * 0.3166939,
        size.height * 0.5529103,
        size.width * 0.3057744,
        size.height * 0.5340172,
        size.width * 0.2901195,
        size.height * 0.5247752);
    path_4.cubicTo(
        size.width * 0.2744640,
        size.height * 0.5155338,
        size.width * 0.2545165,
        size.height * 0.5162055,
        size.width * 0.2340860,
        size.height * 0.5283834);
    path_4.cubicTo(
        size.width * 0.2136787,
        size.height * 0.5405483,
        size.width * 0.1964640,
        size.height * 0.5619766,
        size.width * 0.1850555,
        size.height * 0.5866986);
    path_4.cubicTo(
        size.width * 0.1736476,
        size.height * 0.6114207,
        size.width * 0.1679482,
        size.height * 0.6396469,
        size.width * 0.1707939,
        size.height * 0.6655386);
    path_4.cubicTo(
        size.width * 0.1736427,
        size.height * 0.6914621,
        size.width * 0.1845616,
        size.height * 0.7103517,
        size.width * 0.2002171,
        size.height * 0.7195931);
    path_4.cubicTo(
        size.width * 0.2158720,
        size.height * 0.7288345,
        size.width * 0.2358201,
        size.height * 0.7281655,
        size.width * 0.2562500,
        size.height * 0.7159862);
    path_4.close();

    Paint paint_4_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004337823;
    paint_4_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_stroke);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.2530402, size.height * 0.6867572);
    path_5.cubicTo(
        size.width * 0.2670860,
        size.height * 0.6783848,
        size.width * 0.2789006,
        size.height * 0.6636614,
        size.width * 0.2867213,
        size.height * 0.6467145);
    path_5.cubicTo(
        size.width * 0.2945421,
        size.height * 0.6297669,
        size.width * 0.2984652,
        size.height * 0.6103855,
        size.width * 0.2965067,
        size.height * 0.5925655);
    path_5.cubicTo(
        size.width * 0.2945451,
        size.height * 0.5747166,
        size.width * 0.2870079,
        size.height * 0.5615931,
        size.width * 0.2761030,
        size.height * 0.5551559);
    path_5.cubicTo(
        size.width * 0.2651988,
        size.height * 0.5487186,
        size.width * 0.2513695,
        size.height * 0.5492283,
        size.width * 0.2373012,
        size.height * 0.5576145);
    path_5.cubicTo(
        size.width * 0.2232555,
        size.height * 0.5659869,
        size.width * 0.2114409,
        size.height * 0.5807103,
        size.width * 0.2036207,
        size.height * 0.5976579);
    path_5.cubicTo(
        size.width * 0.1958000,
        size.height * 0.6146048,
        size.width * 0.1918762,
        size.height * 0.6339862,
        size.width * 0.1938348,
        size.height * 0.6518069);
    path_5.cubicTo(
        size.width * 0.1957963,
        size.height * 0.6696559,
        size.width * 0.2033341,
        size.height * 0.6827793,
        size.width * 0.2142384,
        size.height * 0.6892166);
    path_5.cubicTo(
        size.width * 0.2251433,
        size.height * 0.6956552,
        size.width * 0.2389720,
        size.height * 0.6951448,
        size.width * 0.2530402,
        size.height * 0.6867572);
    path_5.close();

    Paint paint_5_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004337823;
    paint_5_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_stroke);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.2242957, size.height * 0.5709986);
    path_6.cubicTo(
        size.width * 0.2075091,
        size.height * 0.5909986,
        size.width * 0.1974262,
        size.height * 0.6207538,
        size.width * 0.2002835,
        size.height * 0.6467524);
    path_6.cubicTo(
        size.width * 0.2040713,
        size.height * 0.6812159,
        size.width * 0.2291622,
        size.height * 0.6960276,
        size.width * 0.2563256,
        size.height * 0.6798359);
    path_6.cubicTo(
        size.width * 0.2613037,
        size.height * 0.6768683,
        size.width * 0.2660055,
        size.height * 0.6730655,
        size.width * 0.2703427,
        size.height * 0.6686214);
    path_6.cubicTo(
        size.width * 0.2648768,
        size.height * 0.6751331,
        size.width * 0.2587006,
        size.height * 0.6806103,
        size.width * 0.2520293,
        size.height * 0.6845876);
    path_6.cubicTo(
        size.width * 0.2248659,
        size.height * 0.7007793,
        size.width * 0.1997750,
        size.height * 0.6859676,
        size.width * 0.1959872,
        size.height * 0.6515041);
    path_6.cubicTo(
        size.width * 0.1928933,
        size.height * 0.6233566,
        size.width * 0.2049677,
        size.height * 0.5908055,
        size.width * 0.2242957,
        size.height * 0.5709986);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.7744024, size.height * 0.2387572);
    path_7.cubicTo(
        size.width * 0.7779390,
        size.height * 0.2284538,
        size.width * 0.7798110,
        size.height * 0.2177317,
        size.width * 0.7798110,
        size.height * 0.2067207);
    path_7.cubicTo(
        size.width * 0.7798110,
        size.height * 0.1271041,
        size.width * 0.6821220,
        size.height * 0.06256228,
        size.width * 0.5616250,
        size.height * 0.06256228);
    path_7.cubicTo(
        size.width * 0.4411250,
        size.height * 0.06256228,
        size.width * 0.3434402,
        size.height * 0.1271041,
        size.width * 0.3434402,
        size.height * 0.2067207);
    path_7.cubicTo(
        size.width * 0.3434402,
        size.height * 0.2177310,
        size.width * 0.3453085,
        size.height * 0.2284531,
        size.width * 0.3488470,
        size.height * 0.2387559);
    path_7.cubicTo(
        size.width * 0.3708951,
        size.height * 0.1745579,
        size.width * 0.4577890,
        size.height * 0.1266338,
        size.width * 0.5616244,
        size.height * 0.1266338);
    path_7.cubicTo(
        size.width * 0.6654573,
        size.height * 0.1266338,
        size.width * 0.7523537,
        size.height * 0.1745586,
        size.width * 0.7744024,
        size.height * 0.2387572);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xff1B262C).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.7773963, size.height * 0.2707931);
    path_8.cubicTo(
        size.width * 0.7773963,
        size.height * 0.3092317,
        size.width * 0.7537988,
        size.height * 0.3445331,
        size.width * 0.7146890,
        size.height * 0.3703752);
    path_8.cubicTo(
        size.width * 0.6756341,
        size.height * 0.3961786,
        size.width * 0.6215244,
        size.height * 0.4122262,
        size.width * 0.5616250,
        size.height * 0.4122262);
    path_8.cubicTo(
        size.width * 0.5017256,
        size.height * 0.4122262,
        size.width * 0.4476146,
        size.height * 0.3961786,
        size.width * 0.4085610,
        size.height * 0.3703752);
    path_8.cubicTo(
        size.width * 0.3694488,
        size.height * 0.3445331,
        size.width * 0.3458506,
        size.height * 0.3092317,
        size.width * 0.3458506,
        size.height * 0.2707931);
    path_8.cubicTo(
        size.width * 0.3458506,
        size.height * 0.2323552,
        size.width * 0.3694488,
        size.height * 0.1970538,
        size.width * 0.4085610,
        size.height * 0.1712117);
    path_8.cubicTo(
        size.width * 0.4476146,
        size.height * 0.1454083,
        size.width * 0.5017256,
        size.height * 0.1293607,
        size.width * 0.5616250,
        size.height * 0.1293607);
    path_8.cubicTo(
        size.width * 0.6215244,
        size.height * 0.1293607,
        size.width * 0.6756341,
        size.height * 0.1454083,
        size.width * 0.7146890,
        size.height * 0.1712117);
    path_8.cubicTo(
        size.width * 0.7537988,
        size.height * 0.1970538,
        size.width * 0.7773963,
        size.height * 0.2323552,
        size.width * 0.7773963,
        size.height * 0.2707931);
    path_8.close();

    Paint paint_8_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004820354;
    paint_8_stroke.color = Color(0xff093057).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_stroke);

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xffD9D9D9).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.5444457, size.height * 0.1954655);
    path_9.lineTo(size.width * 0.5446451, size.height * 0.1954655);
    path_9.cubicTo(
        size.width * 0.5461701,
        size.height * 0.2148303,
        size.width * 0.5566201,
        size.height * 0.2335855,
        size.width * 0.5755213,
        size.height * 0.2479979);
    path_9.cubicTo(
        size.width * 0.5960159,
        size.height * 0.2636255,
        size.width * 0.6227561,
        size.height * 0.2713641,
        size.width * 0.6493780,
        size.height * 0.2713641);
    path_9.cubicTo(
        size.width * 0.6760061,
        size.height * 0.2713641,
        size.width * 0.7027439,
        size.height * 0.2636255,
        size.width * 0.7232378,
        size.height * 0.2479979);
    path_9.cubicTo(
        size.width * 0.7421341,
        size.height * 0.2335855,
        size.width * 0.7525854,
        size.height * 0.2148303,
        size.width * 0.7541098,
        size.height * 0.1954655);
    path_9.lineTo(size.width * 0.7543963, size.height * 0.1954655);
    path_9.lineTo(size.width * 0.7543963, size.height * 0.1928793);
    path_9.lineTo(size.width * 0.7543963, size.height * 0.1551331);
    path_9.lineTo(size.width * 0.7543963, size.height * 0.1525469);
    path_9.lineTo(size.width * 0.7521098, size.height * 0.1525469);
    path_9.lineTo(size.width * 0.7420976, size.height * 0.1525469);
    path_9.cubicTo(
        size.width * 0.7372317,
        size.height * 0.1454834,
        size.width * 0.7309390,
        size.height * 0.1388952,
        size.width * 0.7232378,
        size.height * 0.1330221);
    path_9.cubicTo(
        size.width * 0.7027439,
        size.height * 0.1173945,
        size.width * 0.6760061,
        size.height * 0.1096559,
        size.width * 0.6493780,
        size.height * 0.1096559);
    path_9.cubicTo(
        size.width * 0.6227561,
        size.height * 0.1096559,
        size.width * 0.5960159,
        size.height * 0.1173945,
        size.width * 0.5755213,
        size.height * 0.1330221);
    path_9.cubicTo(
        size.width * 0.5678195,
        size.height * 0.1388952,
        size.width * 0.5615232,
        size.height * 0.1454834,
        size.width * 0.5566598,
        size.height * 0.1525469);
    path_9.lineTo(size.width * 0.5467323, size.height * 0.1525469);
    path_9.lineTo(size.width * 0.5444457, size.height * 0.1525469);
    path_9.lineTo(size.width * 0.5444457, size.height * 0.1551331);
    path_9.lineTo(size.width * 0.5444457, size.height * 0.1928793);
    path_9.lineTo(size.width * 0.5444457, size.height * 0.1954655);
    path_9.close();

    Paint paint_9_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_9_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_stroke);

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.5755287, size.height * 0.2181841);
    path_10.cubicTo(
        size.width * 0.5960232,
        size.height * 0.2338117,
        size.width * 0.6227622,
        size.height * 0.2415503,
        size.width * 0.6493841,
        size.height * 0.2415503);
    path_10.cubicTo(
        size.width * 0.6760122,
        size.height * 0.2415503,
        size.width * 0.7027500,
        size.height * 0.2338117,
        size.width * 0.7232439,
        size.height * 0.2181841);
    path_10.cubicTo(
        size.width * 0.7437561,
        size.height * 0.2025414,
        size.width * 0.7543171,
        size.height * 0.1817821,
        size.width * 0.7543171,
        size.height * 0.1606966);
    path_10.cubicTo(
        size.width * 0.7543171,
        size.height * 0.1396103,
        size.width * 0.7437561,
        size.height * 0.1188510,
        size.width * 0.7232439,
        size.height * 0.1032083);
    path_10.cubicTo(
        size.width * 0.7027500,
        size.height * 0.08758069,
        size.width * 0.6760122,
        size.height * 0.07984207,
        size.width * 0.6493841,
        size.height * 0.07984207);
    path_10.cubicTo(
        size.width * 0.6227622,
        size.height * 0.07984207,
        size.width * 0.5960232,
        size.height * 0.08758069,
        size.width * 0.5755287,
        size.height * 0.1032083);
    path_10.cubicTo(
        size.width * 0.5550146,
        size.height * 0.1188510,
        size.width * 0.5444573,
        size.height * 0.1396103,
        size.width * 0.5444573,
        size.height * 0.1606966);
    path_10.cubicTo(
        size.width * 0.5444573,
        size.height * 0.1817821,
        size.width * 0.5550146,
        size.height * 0.2025414,
        size.width * 0.5755287,
        size.height * 0.2181841);
    path_10.close();

    Paint paint_10_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_10_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_stroke);

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.5986774, size.height * 0.2005297);
    path_11.cubicTo(
        size.width * 0.6127805,
        size.height * 0.2112821,
        size.width * 0.6311402,
        size.height * 0.2165828,
        size.width * 0.6493841,
        size.height * 0.2165828);
    path_11.cubicTo(
        size.width * 0.6676280,
        size.height * 0.2165828,
        size.width * 0.6859878,
        size.height * 0.2112821,
        size.width * 0.7000854,
        size.height * 0.2005297);
    path_11.cubicTo(
        size.width * 0.7142073,
        size.height * 0.1897621,
        size.width * 0.7215671,
        size.height * 0.1753924,
        size.width * 0.7215671,
        size.height * 0.1606959);
    path_11.cubicTo(
        size.width * 0.7215671,
        size.height * 0.1459993,
        size.width * 0.7142073,
        size.height * 0.1316297,
        size.width * 0.7000854,
        size.height * 0.1208621);
    path_11.cubicTo(
        size.width * 0.6859878,
        size.height * 0.1101097,
        size.width * 0.6676280,
        size.height * 0.1048090,
        size.width * 0.6493841,
        size.height * 0.1048090);
    path_11.cubicTo(
        size.width * 0.6311402,
        size.height * 0.1048090,
        size.width * 0.6127805,
        size.height * 0.1101097,
        size.width * 0.5986774,
        size.height * 0.1208621);
    path_11.cubicTo(
        size.width * 0.5845567,
        size.height * 0.1316297,
        size.width * 0.5771963,
        size.height * 0.1459993,
        size.width * 0.5771963,
        size.height * 0.1606959);
    path_11.cubicTo(
        size.width * 0.5771963,
        size.height * 0.1753924,
        size.width * 0.5845567,
        size.height * 0.1897621,
        size.width * 0.5986774,
        size.height * 0.2005297);
    path_11.close();

    Paint paint_11_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_11_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_stroke);

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.6823049, size.height * 0.1136600);
    path_12.cubicTo(
        size.width * 0.6569695,
        size.height * 0.1056703,
        size.width * 0.6267195,
        size.height * 0.1095276,
        size.width * 0.6061293,
        size.height * 0.1252303);
    path_12.cubicTo(
        size.width * 0.5788317,
        size.height * 0.1460455,
        size.width * 0.5788317,
        size.height * 0.1797938,
        size.width * 0.6061293,
        size.height * 0.2006090);
    path_12.cubicTo(
        size.width * 0.6111341,
        size.height * 0.2044234,
        size.width * 0.6167012,
        size.height * 0.2075393,
        size.width * 0.6226341,
        size.height * 0.2099559);
    path_12.cubicTo(
        size.width * 0.6143902,
        size.height * 0.2073545,
        size.width * 0.6066604,
        size.height * 0.2034979,
        size.width * 0.5999561,
        size.height * 0.1983855);
    path_12.cubicTo(
        size.width * 0.5726585,
        size.height * 0.1775697,
        size.width * 0.5726585,
        size.height * 0.1438214,
        size.width * 0.5999561,
        size.height * 0.1230062);
    path_12.cubicTo(
        size.width * 0.6222500,
        size.height * 0.1060055,
        size.width * 0.6558598,
        size.height * 0.1028903,
        size.width * 0.6823049,
        size.height * 0.1136600);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.3508671, size.height * 0.2476379);
    path_13.lineTo(size.width * 0.3510201, size.height * 0.2477779);
    path_13.cubicTo(
        size.width * 0.3437671,
        size.height * 0.2603021,
        size.width * 0.3419616,
        size.height * 0.2771090,
        size.width * 0.3468268,
        size.height * 0.2957379);
    path_13.cubicTo(
        size.width * 0.3521646,
        size.height * 0.3161752,
        size.width * 0.3645628,
        size.height * 0.3351752,
        size.width * 0.3801963,
        size.height * 0.3494400);
    path_13.cubicTo(
        size.width * 0.3958293,
        size.height * 0.3637048,
        size.width * 0.4148701,
        size.height * 0.3733917,
        size.width * 0.4336604,
        size.height * 0.3749697);
    path_13.cubicTo(
        size.width * 0.4507872,
        size.height * 0.3764083,
        size.width * 0.4649287,
        size.height * 0.3708572,
        size.width * 0.4742177,
        size.height * 0.3601903);
    path_13.lineTo(size.width * 0.4744213, size.height * 0.3603766);
    path_13.lineTo(size.width * 0.4758573, size.height * 0.3583634);
    path_13.lineTo(size.width * 0.4919817, size.height * 0.3357579);
    path_13.lineTo(size.width * 0.4934171, size.height * 0.3337448);
    path_13.lineTo(size.width * 0.4916378, size.height * 0.3321214);
    path_13.lineTo(size.width * 0.4860159, size.height * 0.3269917);
    path_13.cubicTo(
        size.width * 0.4861585,
        size.height * 0.3201903,
        size.width * 0.4852817,
        size.height * 0.3129310,
        size.width * 0.4833061,
        size.height * 0.3053676);
    path_13.cubicTo(
        size.width * 0.4779683,
        size.height * 0.2849303,
        size.width * 0.4655701,
        size.height * 0.2659303,
        size.width * 0.4499372,
        size.height * 0.2516655);
    path_13.cubicTo(
        size.width * 0.4343037,
        size.height * 0.2374007,
        size.width * 0.4152628,
        size.height * 0.2277138,
        size.width * 0.3964732,
        size.height * 0.2261359);
    path_13.cubicTo(
        size.width * 0.3895189,
        size.height * 0.2255517,
        size.width * 0.3830604,
        size.height * 0.2261172,
        size.width * 0.3772134,
        size.height * 0.2277138);
    path_13.lineTo(size.width * 0.3716427, size.height * 0.2226303);
    path_13.lineTo(size.width * 0.3698628, size.height * 0.2210062);
    path_13.lineTo(size.width * 0.3684274, size.height * 0.2230193);
    path_13.lineTo(size.width * 0.3523024, size.height * 0.2456255);
    path_13.lineTo(size.width * 0.3508671, size.height * 0.2476379);
    path_13.close();

    Paint paint_13_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_13_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_stroke);

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(size.width * 0.3595671, size.height * 0.2778828);
    path_14.cubicTo(
        size.width * 0.3649049,
        size.height * 0.2983200,
        size.width * 0.3773030,
        size.height * 0.3173200,
        size.width * 0.3929366,
        size.height * 0.3315848);
    path_14.cubicTo(
        size.width * 0.4085695,
        size.height * 0.3458497,
        size.width * 0.4276110,
        size.height * 0.3555366,
        size.width * 0.4464006,
        size.height * 0.3571145);
    path_14.cubicTo(
        size.width * 0.4652171,
        size.height * 0.3586952,
        size.width * 0.4804299,
        size.height * 0.3518366,
        size.width * 0.4895561,
        size.height * 0.3390414);
    path_14.cubicTo(
        size.width * 0.4986823,
        size.height * 0.3262462,
        size.width * 0.5013921,
        size.height * 0.3079793,
        size.width * 0.4960463,
        size.height * 0.2875124);
    path_14.cubicTo(
        size.width * 0.4907085,
        size.height * 0.2670752,
        size.width * 0.4783104,
        size.height * 0.2480752,
        size.width * 0.4626774,
        size.height * 0.2338103);
    path_14.cubicTo(
        size.width * 0.4470439,
        size.height * 0.2195455,
        size.width * 0.4280030,
        size.height * 0.2098586,
        size.width * 0.4092134,
        size.height * 0.2082807);
    path_14.cubicTo(
        size.width * 0.3903970,
        size.height * 0.2067000,
        size.width * 0.3751841,
        size.height * 0.2135586,
        size.width * 0.3660579,
        size.height * 0.2263538);
    path_14.cubicTo(
        size.width * 0.3569311,
        size.height * 0.2391490,
        size.width * 0.3542220,
        size.height * 0.2574166,
        size.width * 0.3595671,
        size.height * 0.2778828);
    path_14.close();

    Paint paint_14_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_14_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_stroke);

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(size.width * 0.3806384, size.height * 0.2796510);
    path_15.cubicTo(
        size.width * 0.3843238,
        size.height * 0.2937607,
        size.width * 0.3928677,
        size.height * 0.3068338,
        size.width * 0.4036049,
        size.height * 0.3166310);
    path_15.cubicTo(
        size.width * 0.4143427,
        size.height * 0.3264290,
        size.width * 0.4274463,
        size.height * 0.3331083,
        size.width * 0.4404183,
        size.height * 0.3341979);
    path_15.cubicTo(
        size.width * 0.4534171,
        size.height * 0.3352897,
        size.width * 0.4640323,
        size.height * 0.3305531,
        size.width * 0.4704293,
        size.height * 0.3215848);
    path_15.cubicTo(
        size.width * 0.4768262,
        size.height * 0.3126166,
        size.width * 0.4786738,
        size.height * 0.2998800,
        size.width * 0.4749811,
        size.height * 0.2857421);
    path_15.cubicTo(
        size.width * 0.4712957,
        size.height * 0.2716324,
        size.width * 0.4627524,
        size.height * 0.2585593,
        size.width * 0.4520146,
        size.height * 0.2487621);
    path_15.cubicTo(
        size.width * 0.4412774,
        size.height * 0.2389641,
        size.width * 0.4281738,
        size.height * 0.2322848,
        size.width * 0.4152012,
        size.height * 0.2311952);
    path_15.cubicTo(
        size.width * 0.4022030,
        size.height * 0.2301034,
        size.width * 0.3915872,
        size.height * 0.2348400,
        size.width * 0.3851902,
        size.height * 0.2438083);
    path_15.cubicTo(
        size.width * 0.3787939,
        size.height * 0.2527766,
        size.width * 0.3769457,
        size.height * 0.2655131,
        size.width * 0.3806384,
        size.height * 0.2796510);
    path_15.close();

    Paint paint_15_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_15_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_stroke);

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(size.width * 0.4671366, size.height * 0.2720766);
    path_16.cubicTo(
        size.width * 0.4557476,
        size.height * 0.2537855,
        size.width * 0.4364287,
        size.height * 0.2399717,
        size.width * 0.4176890,
        size.height * 0.2383972);
    path_16.cubicTo(
        size.width * 0.3928482,
        size.height * 0.2363110,
        size.width * 0.3784311,
        size.height * 0.2565228,
        size.width * 0.3854884,
        size.height * 0.2835414);
    path_16.cubicTo(
        size.width * 0.3867817,
        size.height * 0.2884931,
        size.width * 0.3887061,
        size.height * 0.2933297,
        size.width * 0.3911402,
        size.height * 0.2979393);
    path_16.cubicTo(
        size.width * 0.3874323,
        size.height * 0.2919841,
        size.width * 0.3845646,
        size.height * 0.2855545,
        size.width * 0.3828317,
        size.height * 0.2789186);
    path_16.cubicTo(
        size.width * 0.3757744,
        size.height * 0.2518993,
        size.width * 0.3901915,
        size.height * 0.2316876,
        size.width * 0.4150323,
        size.height * 0.2337745);
    path_16.cubicTo(
        size.width * 0.4353207,
        size.height * 0.2354786,
        size.width * 0.4562878,
        size.height * 0.2515303,
        size.width * 0.4671366,
        size.height * 0.2720766);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(size.width * 0.7722256, size.height * 0.2476379);
    path_17.lineTo(size.width * 0.7720732, size.height * 0.2477779);
    path_17.cubicTo(
        size.width * 0.7793293,
        size.height * 0.2603021,
        size.width * 0.7811341,
        size.height * 0.2771090,
        size.width * 0.7762683,
        size.height * 0.2957379);
    path_17.cubicTo(
        size.width * 0.7709268,
        size.height * 0.3161752,
        size.width * 0.7585305,
        size.height * 0.3351752,
        size.width * 0.7428963,
        size.height * 0.3494400);
    path_17.cubicTo(
        size.width * 0.7272622,
        size.height * 0.3637048,
        size.width * 0.7082256,
        size.height * 0.3733917,
        size.width * 0.6894329,
        size.height * 0.3749697);
    path_17.cubicTo(
        size.width * 0.6723049,
        size.height * 0.3764083,
        size.width * 0.6581646,
        size.height * 0.3708572,
        size.width * 0.6488780,
        size.height * 0.3601903);
    path_17.lineTo(size.width * 0.6486707, size.height * 0.3603766);
    path_17.lineTo(size.width * 0.6472378, size.height * 0.3583634);
    path_17.lineTo(size.width * 0.6311159, size.height * 0.3357579);
    path_17.lineTo(size.width * 0.6296768, size.height * 0.3337448);
    path_17.lineTo(size.width * 0.6314573, size.height * 0.3321214);
    path_17.lineTo(size.width * 0.6370793, size.height * 0.3269917);
    path_17.cubicTo(
        size.width * 0.6369329,
        size.height * 0.3201903,
        size.width * 0.6378110,
        size.height * 0.3129310,
        size.width * 0.6397866,
        size.height * 0.3053676);
    path_17.cubicTo(
        size.width * 0.6451280,
        size.height * 0.2849303,
        size.width * 0.6575244,
        size.height * 0.2659303,
        size.width * 0.6731585,
        size.height * 0.2516655);
    path_17.cubicTo(
        size.width * 0.6887927,
        size.height * 0.2374007,
        size.width * 0.7078293,
        size.height * 0.2277138,
        size.width * 0.7266220,
        size.height * 0.2261359);
    path_17.cubicTo(
        size.width * 0.7335732,
        size.height * 0.2255517,
        size.width * 0.7400366,
        size.height * 0.2261172,
        size.width * 0.7458780,
        size.height * 0.2277138);
    path_17.lineTo(size.width * 0.7514512, size.height * 0.2226303);
    path_17.lineTo(size.width * 0.7532317, size.height * 0.2210062);
    path_17.lineTo(size.width * 0.7546646, size.height * 0.2230193);
    path_17.lineTo(size.width * 0.7707927, size.height * 0.2456255);
    path_17.lineTo(size.width * 0.7722256, size.height * 0.2476379);
    path_17.close();

    Paint paint_17_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_17_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_stroke);

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(size.width * 0.7635244, size.height * 0.2778828);
    path_18.cubicTo(
        size.width * 0.7581890,
        size.height * 0.2983200,
        size.width * 0.7457927,
        size.height * 0.3173200,
        size.width * 0.7301585,
        size.height * 0.3315848);
    path_18.cubicTo(
        size.width * 0.7145244,
        size.height * 0.3458497,
        size.width * 0.6954817,
        size.height * 0.3555366,
        size.width * 0.6766951,
        size.height * 0.3571145);
    path_18.cubicTo(
        size.width * 0.6578780,
        size.height * 0.3586952,
        size.width * 0.6426646,
        size.height * 0.3518366,
        size.width * 0.6335366,
        size.height * 0.3390414);
    path_18.cubicTo(
        size.width * 0.6244146,
        size.height * 0.3262462,
        size.width * 0.6217012,
        size.height * 0.3079793,
        size.width * 0.6270488,
        size.height * 0.2875124);
    path_18.cubicTo(
        size.width * 0.6323841,
        size.height * 0.2670752,
        size.width * 0.6447866,
        size.height * 0.2480752,
        size.width * 0.6604146,
        size.height * 0.2338103);
    path_18.cubicTo(
        size.width * 0.6760488,
        size.height * 0.2195455,
        size.width * 0.6950915,
        size.height * 0.2098586,
        size.width * 0.7138841,
        size.height * 0.2082807);
    path_18.cubicTo(
        size.width * 0.7326951,
        size.height * 0.2067000,
        size.width * 0.7479085,
        size.height * 0.2135586,
        size.width * 0.7570366,
        size.height * 0.2263538);
    path_18.cubicTo(
        size.width * 0.7661646,
        size.height * 0.2391490,
        size.width * 0.7688720,
        size.height * 0.2574166,
        size.width * 0.7635244,
        size.height * 0.2778828);
    path_18.close();

    Paint paint_18_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_18_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_stroke);

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(size.width * 0.7424573, size.height * 0.2796510);
    path_19.cubicTo(
        size.width * 0.7387683,
        size.height * 0.2937607,
        size.width * 0.7302256,
        size.height * 0.3068338,
        size.width * 0.7194878,
        size.height * 0.3166310);
    path_19.cubicTo(
        size.width * 0.7087500,
        size.height * 0.3264290,
        size.width * 0.6956463,
        size.height * 0.3331083,
        size.width * 0.6826768,
        size.height * 0.3341979);
    path_19.cubicTo(
        size.width * 0.6696768,
        size.height * 0.3352897,
        size.width * 0.6590610,
        size.height * 0.3305531,
        size.width * 0.6526646,
        size.height * 0.3215848);
    path_19.cubicTo(
        size.width * 0.6462683,
        size.height * 0.3126166,
        size.width * 0.6444207,
        size.height * 0.2998800,
        size.width * 0.6481159,
        size.height * 0.2857421);
    path_19.cubicTo(
        size.width * 0.6517988,
        size.height * 0.2716324,
        size.width * 0.6603415,
        size.height * 0.2585593,
        size.width * 0.6710793,
        size.height * 0.2487621);
    path_19.cubicTo(
        size.width * 0.6818171,
        size.height * 0.2389641,
        size.width * 0.6949207,
        size.height * 0.2322848,
        size.width * 0.7078902,
        size.height * 0.2311952);
    path_19.cubicTo(
        size.width * 0.7208902,
        size.height * 0.2301034,
        size.width * 0.7315061,
        size.height * 0.2348400,
        size.width * 0.7379024,
        size.height * 0.2438083);
    path_19.cubicTo(
        size.width * 0.7442988,
        size.height * 0.2527766,
        size.width * 0.7461463,
        size.height * 0.2655131,
        size.width * 0.7424573,
        size.height * 0.2796510);
    path_19.close();

    Paint paint_19_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_19_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_stroke);

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(size.width * 0.6559573, size.height * 0.2720766);
    path_20.cubicTo(
        size.width * 0.6673476,
        size.height * 0.2537855,
        size.width * 0.6866646,
        size.height * 0.2399717,
        size.width * 0.7054085,
        size.height * 0.2383972);
    path_20.cubicTo(
        size.width * 0.7302439,
        size.height * 0.2363110,
        size.width * 0.7446646,
        size.height * 0.2565228,
        size.width * 0.7376037,
        size.height * 0.2835414);
    path_20.cubicTo(
        size.width * 0.7363110,
        size.height * 0.2884931,
        size.width * 0.7343902,
        size.height * 0.2933297,
        size.width * 0.7319512,
        size.height * 0.2979393);
    path_20.cubicTo(
        size.width * 0.7356646,
        size.height * 0.2919841,
        size.width * 0.7385305,
        size.height * 0.2855545,
        size.width * 0.7402622,
        size.height * 0.2789186);
    path_20.cubicTo(
        size.width * 0.7473171,
        size.height * 0.2518993,
        size.width * 0.7329024,
        size.height * 0.2316876,
        size.width * 0.7080610,
        size.height * 0.2337745);
    path_20.cubicTo(
        size.width * 0.6877744,
        size.height * 0.2354786,
        size.width * 0.6668049,
        size.height * 0.2515303,
        size.width * 0.6559573,
        size.height * 0.2720766);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(size.width * 0.4473945, size.height * 0.2569310);
    path_21.lineTo(size.width * 0.4475744, size.height * 0.2570159);
    path_21.cubicTo(
        size.width * 0.4423695,
        size.height * 0.2755145,
        size.width * 0.4453915,
        size.height * 0.2972559,
        size.width * 0.4575177,
        size.height * 0.3185979);
    path_21.cubicTo(
        size.width * 0.4706659,
        size.height * 0.3417386,
        size.width * 0.4921268,
        size.height * 0.3602455,
        size.width * 0.5161195,
        size.height * 0.3715559);
    path_21.cubicTo(
        size.width * 0.5401128,
        size.height * 0.3828662,
        size.width * 0.5668421,
        size.height * 0.3870766,
        size.width * 0.5906287,
        size.height * 0.3813476);
    path_21.cubicTo(
        size.width * 0.6125671,
        size.height * 0.3760641,
        size.width * 0.6283476,
        size.height * 0.3631855,
        size.width * 0.6362988,
        size.height * 0.3459814);
    path_21.lineTo(size.width * 0.6365549, size.height * 0.3461028);
    path_21.lineTo(size.width * 0.6374329, size.height * 0.3437159);
    path_21.lineTo(size.width * 0.6502744, size.height * 0.3088752);
    path_21.lineTo(size.width * 0.6511524, size.height * 0.3064876);
    path_21.lineTo(size.width * 0.6490427, size.height * 0.3054931);
    path_21.lineTo(size.width * 0.6400671, size.height * 0.3012614);
    path_21.cubicTo(
        size.width * 0.6380854,
        size.height * 0.2926855,
        size.width * 0.6346585,
        size.height * 0.2839372,
        size.width * 0.6297256,
        size.height * 0.2752517);
    path_21.cubicTo(
        size.width * 0.6165793,
        size.height * 0.2521110,
        size.width * 0.5951165,
        size.height * 0.2336041,
        size.width * 0.5711238,
        size.height * 0.2222938);
    path_21.cubicTo(
        size.width * 0.5471305,
        size.height * 0.2109834,
        size.width * 0.5204012,
        size.height * 0.2067731,
        size.width * 0.4966146,
        size.height * 0.2125021);
    path_21.cubicTo(
        size.width * 0.4876860,
        size.height * 0.2146524,
        size.width * 0.4797805,
        size.height * 0.2180579,
        size.width * 0.4730024,
        size.height * 0.2225062);
    path_21.lineTo(size.width * 0.4641037, size.height * 0.2183110);
    path_21.lineTo(size.width * 0.4619933, size.height * 0.2173159);
    path_21.lineTo(size.width * 0.4611134, size.height * 0.2197034);
    path_21.lineTo(size.width * 0.4482744, size.height * 0.2545441);
    path_21.lineTo(size.width * 0.4473945, size.height * 0.2569310);
    path_21.close();

    Paint paint_21_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_21_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_stroke);

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(size.width * 0.4676604, size.height * 0.2910807);
    path_22.cubicTo(
        size.width * 0.4808085,
        size.height * 0.3142214,
        size.width * 0.5022695,
        size.height * 0.3327283,
        size.width * 0.5262622,
        size.height * 0.3440386);
    path_22.cubicTo(
        size.width * 0.5502555,
        size.height * 0.3553490,
        size.width * 0.5769848,
        size.height * 0.3595593,
        size.width * 0.6007713,
        size.height * 0.3538303);
    path_22.cubicTo(
        size.width * 0.6245854,
        size.height * 0.3480952,
        size.width * 0.6411402,
        size.height * 0.3334090,
        size.width * 0.6482988,
        size.height * 0.3139731);
    path_22.cubicTo(
        size.width * 0.6554634,
        size.height * 0.2945372,
        size.width * 0.6530305,
        size.height * 0.2709000,
        size.width * 0.6398659,
        size.height * 0.2477345);
    path_22.cubicTo(
        size.width * 0.6267195,
        size.height * 0.2245938,
        size.width * 0.6052591,
        size.height * 0.2060869,
        size.width * 0.5812665,
        size.height * 0.1947766);
    path_22.cubicTo(
        size.width * 0.5572732,
        size.height * 0.1834662,
        size.width * 0.5305439,
        size.height * 0.1792559,
        size.width * 0.5067573,
        size.height * 0.1849848);
    path_22.cubicTo(
        size.width * 0.4829445,
        size.height * 0.1907200,
        size.width * 0.4663890,
        size.height * 0.2054062,
        size.width * 0.4592268,
        size.height * 0.2248421);
    path_22.cubicTo(
        size.width * 0.4520646,
        size.height * 0.2442779,
        size.width * 0.4544976,
        size.height * 0.2679152,
        size.width * 0.4676604,
        size.height * 0.2910807);
    path_22.close();

    Paint paint_22_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_22_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_stroke);

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(size.width * 0.4945183, size.height * 0.2846117);
    path_23.cubicTo(
        size.width * 0.5035677,
        size.height * 0.3005386,
        size.width * 0.5183122,
        size.height * 0.3132386,
        size.width * 0.5347598,
        size.height * 0.3209924);
    path_23.cubicTo(
        size.width * 0.5512067,
        size.height * 0.3287455,
        size.width * 0.5695616,
        size.height * 0.3316490,
        size.width * 0.5859335,
        size.height * 0.3277055);
    path_23.cubicTo(
        size.width * 0.6023311,
        size.height * 0.3237566,
        size.width * 0.6138354,
        size.height * 0.3136117,
        size.width * 0.6188232,
        size.height * 0.3000731);
    path_23.cubicTo(
        size.width * 0.6238110,
        size.height * 0.2865352,
        size.width * 0.6220854,
        size.height * 0.2701524,
        size.width * 0.6130183,
        size.height * 0.2542007);
    path_23.cubicTo(
        size.width * 0.6039707,
        size.height * 0.2382738,
        size.width * 0.5892262,
        size.height * 0.2255738,
        size.width * 0.5727787,
        size.height * 0.2178207);
    path_23.cubicTo(
        size.width * 0.5563311,
        size.height * 0.2100669,
        size.width * 0.5379768,
        size.height * 0.2071641,
        size.width * 0.5216049,
        size.height * 0.2111069);
    path_23.cubicTo(
        size.width * 0.5052073,
        size.height * 0.2150566,
        size.width * 0.4937043,
        size.height * 0.2252014,
        size.width * 0.4887152,
        size.height * 0.2387393);
    path_23.cubicTo(
        size.width * 0.4837262,
        size.height * 0.2522779,
        size.width * 0.4854543,
        size.height * 0.2686600,
        size.width * 0.4945183,
        size.height * 0.2846117);
    path_23.close();

    Paint paint_23_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004573171;
    paint_23_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_stroke);

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(size.width * 0.5994110, size.height * 0.2399641);
    path_24.cubicTo(
        size.width * 0.5793159,
        size.height * 0.2218359,
        size.width * 0.5507683,
        size.height * 0.2125572,
        size.width * 0.5268835,
        size.height * 0.2183097);
    path_24.cubicTo(
        size.width * 0.4952226,
        size.height * 0.2259352,
        size.width * 0.4837433,
        size.height * 0.2570862,
        size.width * 0.5012439,
        size.height * 0.2878869);
    path_24.cubicTo(
        size.width * 0.5044512,
        size.height * 0.2935317,
        size.width * 0.5084091,
        size.height * 0.2987724,
        size.width * 0.5129299,
        size.height * 0.3035214);
    path_24.cubicTo(
        size.width * 0.5063872,
        size.height * 0.2976193,
        size.width * 0.5007402,
        size.height * 0.2907786,
        size.width * 0.4964415,
        size.height * 0.2832138);
    path_24.cubicTo(
        size.width * 0.4789409,
        size.height * 0.2524131,
        size.width * 0.4904201,
        size.height * 0.2212621,
        size.width * 0.5220811,
        size.height * 0.2136366);
    path_24.cubicTo(
        size.width * 0.5479402,
        size.height * 0.2074083,
        size.width * 0.5792640,
        size.height * 0.2187993,
        size.width * 0.5994110,
        size.height * 0.2399641);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(size.width * 0.3293433, size.height * 0.2217186);
    path_25.cubicTo(
        size.width * 0.3255299,
        size.height * 0.2328221,
        size.width * 0.3235159,
        size.height * 0.2443779,
        size.width * 0.3235159,
        size.height * 0.2562441);
    path_25.cubicTo(
        size.width * 0.3235159,
        size.height * 0.3420455,
        size.width * 0.4287890,
        size.height * 0.4116014,
        size.width * 0.5586494,
        size.height * 0.4116014);
    path_25.cubicTo(
        size.width * 0.6885122,
        size.height * 0.4116014,
        size.width * 0.7937805,
        size.height * 0.3420455,
        size.width * 0.7937805,
        size.height * 0.2562441);
    path_25.cubicTo(
        size.width * 0.7937805,
        size.height * 0.2443786,
        size.width * 0.7917683,
        size.height * 0.2328234,
        size.width * 0.7879573,
        size.height * 0.2217207);
    path_25.cubicTo(
        size.width * 0.7641951,
        size.height * 0.2909048,
        size.width * 0.6705488,
        size.height * 0.3425524,
        size.width * 0.5586506,
        size.height * 0.3425524);
    path_25.cubicTo(
        size.width * 0.4467482,
        size.height * 0.3425524,
        size.width * 0.3531037,
        size.height * 0.2909041,
        size.width * 0.3293433,
        size.height * 0.2217186);
    path_25.close();

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(size.width * 0.7873354, size.height * 0.2900552);
    path_26.cubicTo(
        size.width * 0.7761768,
        size.height * 0.3168662,
        size.width * 0.7553598,
        size.height * 0.3410359,
        size.width * 0.7273354,
        size.height * 0.3605628);
    path_26.cubicTo(
        size.width * 0.6842134,
        size.height * 0.3906138,
        size.width * 0.6244512,
        size.height * 0.4093124,
        size.width * 0.5582726,
        size.height * 0.4093124);
    path_26.cubicTo(
        size.width * 0.4920963,
        size.height * 0.4093124,
        size.width * 0.4323311,
        size.height * 0.3906138,
        size.width * 0.3892085,
        size.height * 0.3605628);
    path_26.cubicTo(
        size.width * 0.3611878,
        size.height * 0.3410359,
        size.width * 0.3403713,
        size.height * 0.3168662,
        size.width * 0.3292116,
        size.height * 0.2900559);
    path_26.cubicTo(
        size.width * 0.3423573,
        size.height * 0.3154814,
        size.width * 0.3633524,
        size.height * 0.3380055,
        size.width * 0.3898518,
        size.height * 0.3561579);
    path_26.cubicTo(
        size.width * 0.4337348,
        size.height * 0.3862186,
        size.width * 0.4930720,
        size.height * 0.4045855,
        size.width * 0.5582726,
        size.height * 0.4045855);
    path_26.cubicTo(
        size.width * 0.6234756,
        size.height * 0.4045855,
        size.width * 0.6828110,
        size.height * 0.3862186,
        size.width * 0.7266951,
        size.height * 0.3561579);
    path_26.cubicTo(
        size.width * 0.7531951,
        size.height * 0.3380055,
        size.width * 0.7741890,
        size.height * 0.3154814,
        size.width * 0.7873354,
        size.height * 0.2900552);
    path_26.close();

    Paint paint_26_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint_26_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_stroke);

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(size.width * 0.7796707, size.height * 0.2059993);
    path_27.cubicTo(
        size.width * 0.7796707,
        size.height * 0.2446510,
        size.width * 0.7558537,
        size.height * 0.2803138,
        size.width * 0.7160671,
        size.height * 0.3065131);
    path_27.cubicTo(
        size.width * 0.6763598,
        size.height * 0.3326600,
        size.width * 0.6212927,
        size.height * 0.3489476,
        size.width * 0.5602970,
        size.height * 0.3489476);
    path_27.cubicTo(
        size.width * 0.4993000,
        size.height * 0.3489476,
        size.width * 0.4442335,
        size.height * 0.3326600,
        size.width * 0.4045250,
        size.height * 0.3065131);
    path_27.cubicTo(
        size.width * 0.3647378,
        size.height * 0.2803138,
        size.width * 0.3409213,
        size.height * 0.2446510,
        size.width * 0.3409213,
        size.height * 0.2059993);
    path_27.cubicTo(
        size.width * 0.3409213,
        size.height * 0.1673469,
        size.width * 0.3647378,
        size.height * 0.1316841,
        size.width * 0.4045250,
        size.height * 0.1054848);
    path_27.cubicTo(
        size.width * 0.4442335,
        size.height * 0.07933793,
        size.width * 0.4993000,
        size.height * 0.06305041,
        size.width * 0.5602970,
        size.height * 0.06305041);
    path_27.cubicTo(
        size.width * 0.6212927,
        size.height * 0.06305041,
        size.width * 0.6763598,
        size.height * 0.07933793,
        size.width * 0.7160671,
        size.height * 0.1054848);
    path_27.cubicTo(
        size.width * 0.7558537,
        size.height * 0.1316841,
        size.width * 0.7796707,
        size.height * 0.1673469,
        size.width * 0.7796707,
        size.height * 0.2059993);
    path_27.close();

    Paint paint_27_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.006371159;
    paint_27_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_stroke);

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(size.width * 0.7929207, size.height * 0.4457579);
    path_28.cubicTo(
        size.width * 0.7997561,
        size.height * 0.4110821,
        size.width * 0.7667378,
        size.height * 0.3570869,
        size.width * 0.7482317,
        size.height * 0.3482572);
    path_28.cubicTo(
        size.width * 0.7307317,
        size.height * 0.3630972,
        size.width * 0.7222500,
        size.height * 0.3693214,
        size.width * 0.7060793,
        size.height * 0.3787593);
    path_28.cubicTo(
        size.width * 0.7573232,
        size.height * 0.4134352,
        size.width * 0.7480793,
        size.height * 0.4690352,
        size.width * 0.7459451,
        size.height * 0.4891021);
    path_28.lineTo(size.width * 0.7440549, size.height * 0.7620414);
    path_28.cubicTo(
        size.width * 0.7637195,
        size.height * 0.7492690,
        size.width * 0.7758110,
        size.height * 0.7381724,
        size.width * 0.7925244,
        size.height * 0.7206897);
    path_28.cubicTo(
        size.width * 0.7896768,
        size.height * 0.6267766,
        size.width * 0.7860854,
        size.height * 0.4804331,
        size.width * 0.7929207,
        size.height * 0.4457579);
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);

    Path path_29 = Path();
    path_29.moveTo(size.width * 0.3476122, size.height * 0.1188986);
    path_29.lineTo(size.width * 0.3477823, size.height * 0.1189786);
    path_29.cubicTo(
        size.width * 0.3428451,
        size.height * 0.1365255,
        size.width * 0.3457116,
        size.height * 0.1571483,
        size.width * 0.3572140,
        size.height * 0.1773917);
    path_29.cubicTo(
        size.width * 0.3696854,
        size.height * 0.1993414,
        size.width * 0.3900421,
        size.height * 0.2168959,
        size.width * 0.4128000,
        size.height * 0.2276241);
    path_29.cubicTo(
        size.width * 0.4355585,
        size.height * 0.2383524,
        size.width * 0.4609122,
        size.height * 0.2423462,
        size.width * 0.4834750,
        size.height * 0.2369117);
    path_29.cubicTo(
        size.width * 0.5042841,
        size.height * 0.2319000,
        size.width * 0.5192512,
        size.height * 0.2196841,
        size.width * 0.5267939,
        size.height * 0.2033655);
    path_29.lineTo(size.width * 0.5270384, size.height * 0.2034814);
    path_29.lineTo(size.width * 0.5278726, size.height * 0.2012166);
    path_29.lineTo(size.width * 0.5400512, size.height * 0.1681690);
    path_29.lineTo(size.width * 0.5408854, size.height * 0.1659048);
    path_29.lineTo(size.width * 0.5388835, size.height * 0.1649607);
    path_29.lineTo(size.width * 0.5303689, size.height * 0.1609469);
    path_29.cubicTo(
        size.width * 0.5284921,
        size.height * 0.1528124,
        size.width * 0.5252409,
        size.height * 0.1445152,
        size.width * 0.5205598,
        size.height * 0.1362759);
    path_29.cubicTo(
        size.width * 0.5080884,
        size.height * 0.1143262,
        size.width * 0.4877317,
        size.height * 0.09677172,
        size.width * 0.4649732,
        size.height * 0.08604345);
    path_29.cubicTo(
        size.width * 0.4422152,
        size.height * 0.07531517,
        size.width * 0.4168616,
        size.height * 0.07132138,
        size.width * 0.3942988,
        size.height * 0.07675586);
    path_29.cubicTo(
        size.width * 0.3858299,
        size.height * 0.07879586,
        size.width * 0.3783311,
        size.height * 0.08202552,
        size.width * 0.3719018,
        size.height * 0.08624483);
    path_29.lineTo(size.width * 0.3634610, size.height * 0.08226552);
    path_29.lineTo(size.width * 0.3614591, size.height * 0.08132207);
    path_29.lineTo(size.width * 0.3606244, size.height * 0.08358621);
    path_29.lineTo(size.width * 0.3484463, size.height * 0.1166338);
    path_29.lineTo(size.width * 0.3476122, size.height * 0.1188986);
    path_29.close();

    Paint paint_29_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004337823;
    paint_29_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_stroke);

    Paint paint_29_fill = Paint()..style = PaintingStyle.fill;
    paint_29_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_fill);

    Path path_30 = Path();
    path_30.moveTo(size.width * 0.3668329, size.height * 0.1512903);
    path_30.cubicTo(
        size.width * 0.3793043,
        size.height * 0.1732400,
        size.width * 0.3996610,
        size.height * 0.1907945,
        size.width * 0.4224189,
        size.height * 0.2015228);
    path_30.cubicTo(
        size.width * 0.4451774,
        size.height * 0.2122510,
        size.width * 0.4705311,
        size.height * 0.2162448,
        size.width * 0.4930933,
        size.height * 0.2108110);
    path_30.cubicTo(
        size.width * 0.5156811,
        size.height * 0.2053703,
        size.width * 0.5313841,
        size.height * 0.1914407,
        size.width * 0.5381780,
        size.height * 0.1730048);
    path_30.cubicTo(
        size.width * 0.5449713,
        size.height * 0.1545690,
        size.width * 0.5426634,
        size.height * 0.1321483,
        size.width * 0.5301787,
        size.height * 0.1101745);
    path_30.cubicTo(
        size.width * 0.5177067,
        size.height * 0.08822483,
        size.width * 0.4973506,
        size.height * 0.07067034,
        size.width * 0.4745921,
        size.height * 0.05994228);
    path_30.cubicTo(
        size.width * 0.4518341,
        size.height * 0.04921393,
        size.width * 0.4264805,
        size.height * 0.04522028,
        size.width * 0.4039177,
        size.height * 0.05065455);
    path_30.cubicTo(
        size.width * 0.3813305,
        size.height * 0.05609476,
        size.width * 0.3656268,
        size.height * 0.07002483,
        size.width * 0.3588335,
        size.height * 0.08846069);
    path_30.cubicTo(
        size.width * 0.3520396,
        size.height * 0.1068966,
        size.width * 0.3543476,
        size.height * 0.1293166,
        size.width * 0.3668329,
        size.height * 0.1512903);
    path_30.close();

    Paint paint_30_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004337823;
    paint_30_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_stroke);

    Paint paint_30_fill = Paint()..style = PaintingStyle.fill;
    paint_30_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_fill);

    Path path_31 = Path();
    path_31.moveTo(size.width * 0.3923049, size.height * 0.1451531);
    path_31.cubicTo(
        size.width * 0.4008890,
        size.height * 0.1602600,
        size.width * 0.4148744,
        size.height * 0.1723069,
        size.width * 0.4304756,
        size.height * 0.1796607);
    path_31.cubicTo(
        size.width * 0.4460768,
        size.height * 0.1870152,
        size.width * 0.4634866,
        size.height * 0.1897690,
        size.width * 0.4790159,
        size.height * 0.1860290);
    path_31.cubicTo(
        size.width * 0.4945695,
        size.height * 0.1822828,
        size.width * 0.5054811,
        size.height * 0.1726600,
        size.width * 0.5102134,
        size.height * 0.1598186);
    path_31.cubicTo(
        size.width * 0.5149451,
        size.height * 0.1469772,
        size.width * 0.5133061,
        size.height * 0.1314379,
        size.width * 0.5047091,
        size.height * 0.1163069);
    path_31.cubicTo(
        size.width * 0.4961250,
        size.height * 0.1012000,
        size.width * 0.4821396,
        size.height * 0.08915310,
        size.width * 0.4665384,
        size.height * 0.08179862);
    path_31.cubicTo(
        size.width * 0.4509372,
        size.height * 0.07444483,
        size.width * 0.4335274,
        size.height * 0.07169034,
        size.width * 0.4179982,
        size.height * 0.07543103);
    path_31.cubicTo(
        size.width * 0.4024445,
        size.height * 0.07917724,
        size.width * 0.3915329,
        size.height * 0.08880000,
        size.width * 0.3868012,
        size.height * 0.1016414);
    path_31.cubicTo(
        size.width * 0.3820689,
        size.height * 0.1144828,
        size.width * 0.3837079,
        size.height * 0.1300221,
        size.width * 0.3923049,
        size.height * 0.1451531);
    path_31.close();

    Paint paint_31_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.004337823;
    paint_31_stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_stroke);

    Paint paint_31_fill = Paint()..style = PaintingStyle.fill;
    paint_31_fill.color = Color(0xffFFE9B1).withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_fill);

    Path path_32 = Path();
    path_32.moveTo(size.width * 0.4918000, size.height * 0.1028034);
    path_32.cubicTo(
        size.width * 0.4727390,
        size.height * 0.08560759,
        size.width * 0.4456610,
        size.height * 0.07680621,
        size.width * 0.4230055,
        size.height * 0.08226276);
    path_32.cubicTo(
        size.width * 0.3929738,
        size.height * 0.08949586,
        size.width * 0.3820848,
        size.height * 0.1190434,
        size.width * 0.3986854,
        size.height * 0.1482593);
    path_32.cubicTo(
        size.width * 0.4017274,
        size.height * 0.1536138,
        size.width * 0.4054811,
        size.height * 0.1585848,
        size.width * 0.4097689,
        size.height * 0.1630897);
    path_32.cubicTo(
        size.width * 0.4035634,
        size.height * 0.1574910,
        size.width * 0.3982067,
        size.height * 0.1510028,
        size.width * 0.3941299,
        size.height * 0.1438269);
    path_32.cubicTo(
        size.width * 0.3775299,
        size.height * 0.1146110,
        size.width * 0.3884183,
        size.height * 0.08506345,
        size.width * 0.4184500,
        size.height * 0.07783034);
    path_32.cubicTo(
        size.width * 0.4429780,
        size.height * 0.07192276,
        size.width * 0.4726902,
        size.height * 0.08272759,
        size.width * 0.4918000,
        size.height * 0.1028034);
    path_32.close();

    Paint paint_32_fill = Paint()..style = PaintingStyle.fill;
    paint_32_fill.color = Color(0xffEFAF4E).withOpacity(1.0);
    canvas.drawPath(path_32, paint_32_fill);

    Paint paint_33_fill = Paint()..style = PaintingStyle.fill;
    paint_33_fill.color = Color(0xffFFD979).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.7867256, size.height * 0.07229586),
        size.width * 0.008606098, paint_33_fill);

    Paint paint_34_fill = Paint()..style = PaintingStyle.fill;
    paint_34_fill.color = Colors.white.withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.2664518, size.height * 0.06605655),
        size.width * 0.003089427, paint_34_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
