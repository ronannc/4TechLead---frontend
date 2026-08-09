import 'package:flutter/material.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _AppLogoMarkPainter(Theme.of(context))),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.markSize = 40});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogoMark(size: markSize),
        const SizedBox(width: 8),
        Text('4TechLead', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _AppLogoMarkPainter extends CustomPainter {
  _AppLogoMarkPainter(this.theme);

  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surfaceContainerHighest;
    final foreground = theme.colorScheme.onSurface;
    final unit = size.shortestSide / 40;
    final stroke = 3.6 * unit;
    final radius = Radius.circular(10 * unit);
    final rect = Offset.zero & size;

    final backgroundPaint = Paint()
      ..color = surface
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1 * unit), radius),
      backgroundPaint,
    );

    final accentPaint = Paint()
      ..color = primary.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(28 * unit, 12 * unit), 8 * unit, accentPaint);

    final fourPaint = Paint()
      ..color = foreground
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final fourPath = Path()
      ..moveTo(25 * unit, 8 * unit)
      ..lineTo(13 * unit, 23 * unit)
      ..lineTo(29 * unit, 23 * unit)
      ..moveTo(25 * unit, 8 * unit)
      ..lineTo(25 * unit, 32 * unit);
    canvas.drawPath(fourPath, fourPaint);

    final circuitPaint = Paint()
      ..color = primary
      ..strokeWidth = 2.4 * unit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final circuitPath = Path()
      ..moveTo(8 * unit, 31 * unit)
      ..lineTo(14 * unit, 31 * unit)
      ..lineTo(20 * unit, 27 * unit)
      ..lineTo(31 * unit, 27 * unit);
    canvas.drawPath(circuitPath, circuitPaint);

    final leadershipPath = Path()
      ..moveTo(12 * unit, 15 * unit)
      ..lineTo(17 * unit, 10 * unit)
      ..lineTo(21 * unit, 14 * unit);
    canvas.drawPath(leadershipPath, circuitPaint);

    final nodePaint = Paint()
      ..color = primary
      ..style = PaintingStyle.fill;
    for (final point in [
      Offset(8 * unit, 31 * unit),
      Offset(20 * unit, 27 * unit),
      Offset(31 * unit, 27 * unit),
      Offset(17 * unit, 10 * unit),
    ]) {
      canvas.drawCircle(point, 2.4 * unit, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AppLogoMarkPainter oldDelegate) {
    return oldDelegate.theme.colorScheme != theme.colorScheme;
  }
}
