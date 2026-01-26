import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Aktivite Zaman Çizelgesi Kartı
/// Beğeni ve Yorum aktivitelerini grafik olarak gösterir
class ActivityTimelineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ActivityDataPoint> dataPoints;
  final Color lineColor;
  final bool hasData;

  const ActivityTimelineCard({
    super.key,
    required this.title,
    this.subtitle = 'Son 90 gün',
    required this.dataPoints,
    this.lineColor = const Color(0xFFFF6B9D),
    this.hasData = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Grafik
          if (hasData && dataPoints.isNotEmpty)
            SizedBox(
              height: 150,
              child: CustomPaint(
                size: const Size(double.infinity, 150),
                painter: _LineChartPainter(
                  dataPoints: dataPoints,
                  lineColor: lineColor,
                  isDark: isDark,
                ),
              ),
            )
          else
            SizedBox(
              height: 150,
              child: Center(
                child: Text(
                  'Veri bulunamadı',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextHint
                        : AppColors.lightTextHint,
                  ),
                ),
              ),
            ),
          if (hasData && dataPoints.isNotEmpty) ...[
            const SizedBox(height: 12),
            // X ekseni etiketleri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildXAxisLabels(isDark),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildXAxisLabels(bool isDark) {
    if (dataPoints.isEmpty) return [];

    final labels = <Widget>[];
    final step = (dataPoints.length / 6).ceil();

    for (int i = 0; i < dataPoints.length; i += step) {
      if (i < dataPoints.length) {
        labels.add(
          Text(
            dataPoints[i].label,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
            ),
          ),
        );
      }
    }

    return labels;
  }
}

class ActivityDataPoint {
  final String label;
  final double value;

  const ActivityDataPoint({required this.label, required this.value});
}

class _LineChartPainter extends CustomPainter {
  final List<ActivityDataPoint> dataPoints;
  final Color lineColor;
  final bool isDark;

  _LineChartPainter({
    required this.dataPoints,
    required this.lineColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final maxValue = dataPoints
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final minValue = 0.0;
    final range = maxValue - minValue;

    // Grid çizgileri
    final gridPaint = Paint()
      ..color = isDark
          ? AppColors.darkBorder.withValues(alpha: 0.3)
          : AppColors.lightBorder.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Çizgi grafiği
    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < dataPoints.length; i++) {
      final x = dataPoints.length > 1
          ? size.width * i / (dataPoints.length - 1)
          : size.width / 2; // Tek nokta varsa ortala

      final range = maxValue - minValue;
      final normalizedValue = range == 0
          ? 0.5
          : (dataPoints[i].value - minValue) / range;

      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    // Çizgi
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Gradient dolgu
    final gradientPath = Path.from(path);
    gradientPath.lineTo(size.width, size.height);
    gradientPath.lineTo(0, size.height);
    gradientPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.3),
          lineColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(gradientPath, gradientPaint);

    // Y ekseni değerleri
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i <= 4; i++) {
      final value = minValue + (range * (4 - i) / 4);
      textPainter.text = TextSpan(
        text: value.toInt().toString(),
        style: TextStyle(
          fontSize: 9,
          color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, size.height * i / 4 - 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
