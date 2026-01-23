import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';

/// Active Hour Card (En Aktif Saat)
/// Görseldeki gibi büyük saat gösterimi
class ActiveHourCard extends StatelessWidget {
  final String activeHour;
  final double changePercentage;
  final List<double> hourlyData; // 24 saatlik veri

  const ActiveHourCard({
    super.key,
    required this.activeHour,
    required this.changePercentage,
    required this.hourlyData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.get('active_hour'),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              // Değişim badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changePercentage >= 0
                      ? AppColors.darkSuccess.withValues(alpha: 0.1)
                      : AppColors.darkAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${changePercentage >= 0 ? '+' : ''}${changePercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: changePercentage >= 0
                        ? AppColors.darkSuccess
                        : AppColors.darkAccent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Büyük saat gösterimi
          Text(
            activeHour,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Mini bar chart
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _buildMiniChart(isDark),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMiniChart(bool isDark) {
    // Son 6 saatin verisini göster
    final displayData = hourlyData.length >= 6
        ? hourlyData.sublist(hourlyData.length - 6)
        : hourlyData;

    final maxVal = displayData.reduce((a, b) => a > b ? a : b);

    return displayData.asMap().entries.map((entry) {
      final isMax = entry.value == maxVal;

      return Container(
        width: 16,
        height: 40 * (entry.value / maxVal).clamp(0.1, 1.0),
        decoration: BoxDecoration(
          color: isMax
              ? AppColors.darkAccent
              : isDark
              ? AppColors.darkBorder
              : AppColors.lightBorder,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }).toList();
  }
}
