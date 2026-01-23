import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';

/// Active Hour Card (En Aktif Saat)
/// Saate göre emoji ve lakap ile birlikte gösterilir
class ActiveHourCard extends StatelessWidget {
  final String activeHour;
  final double changePercentage;
  final List<double> hourlyData;

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

    // Saate göre emoji ve lakap al
    final hourInfo = _getHourInfo(activeHour, l10n);

    return Container(
      height: 200, // Sabit yükseklik
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row with badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.darkAccent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.darkAccent,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.get('active_hour'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: changePercentage >= 0
                      ? AppColors.darkSuccess.withValues(alpha: 0.1)
                      : AppColors.darkAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${changePercentage >= 0 ? '+' : ''}${changePercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 10,
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

          // Saat ve Emoji
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                activeHour,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(hourInfo['emoji']!, style: const TextStyle(fontSize: 20)),
            ],
          ),

          const SizedBox(height: 2),

          // Lakap
          Text(
            hourInfo['nickname']!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.darkSuccess,
            ),
          ),

          const Spacer(),

          // Mini bar chart
          SizedBox(
            height: 35,
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

  /// Saate göre emoji ve lakap döndür
  Map<String, String> _getHourInfo(String hour, AppLocalizations l10n) {
    final parts = hour.split(' ');
    int hourNum = int.tryParse(parts[0]) ?? 12;
    if (parts.length > 1 && parts[1].toUpperCase() == 'PM' && hourNum != 12) {
      hourNum += 12;
    }
    if (parts.length > 1 && parts[1].toUpperCase() == 'AM' && hourNum == 12) {
      hourNum = 0;
    }

    if (hourNum >= 5 && hourNum < 9) {
      return {'emoji': '🐦', 'nickname': l10n.get('early_bird')};
    } else if (hourNum >= 9 && hourNum < 12) {
      return {'emoji': '☀️', 'nickname': l10n.get('morning_person')};
    } else if (hourNum >= 12 && hourNum < 14) {
      return {'emoji': '🌞', 'nickname': l10n.get('lunch_break_scroller')};
    } else if (hourNum >= 14 && hourNum < 18) {
      return {'emoji': '💼', 'nickname': l10n.get('afternoon_explorer')};
    } else if (hourNum >= 18 && hourNum < 21) {
      return {'emoji': '🌆', 'nickname': l10n.get('evening_browser')};
    } else if (hourNum >= 21 && hourNum < 24) {
      return {'emoji': '🦉', 'nickname': l10n.get('night_owl')};
    } else {
      return {'emoji': '🌙', 'nickname': l10n.get('midnight_explorer')};
    }
  }

  List<Widget> _buildMiniChart(bool isDark) {
    final displayData = hourlyData.length >= 6
        ? hourlyData.sublist(hourlyData.length - 6)
        : hourlyData;

    if (displayData.isEmpty) return [];

    final maxVal = displayData.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return [];

    return displayData.asMap().entries.map((entry) {
      final isMax = entry.value == maxVal;

      return Container(
        width: 14,
        height: 35 * (entry.value / maxVal).clamp(0.15, 1.0),
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
