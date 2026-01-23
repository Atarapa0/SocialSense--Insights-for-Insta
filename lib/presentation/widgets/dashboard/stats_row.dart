import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';

/// Stats Row (Engagement Rate + Total Reach)
/// İki küçük istatistik kartı yan yana
class StatsRow extends StatelessWidget {
  final double engagementRate;
  final double engagementChange;
  final int totalReach;
  final int reachChange;

  const StatsRow({
    super.key,
    required this.engagementRate,
    required this.engagementChange,
    required this.totalReach,
    required this.reachChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // Engagement Rate
        Expanded(
          child: _buildStatCard(
            icon: Icons.thumb_up_outlined,
            iconColor: AppColors.darkPrimary,
            label: l10n.get('engagement_rate'),
            value: '${engagementRate.toStringAsFixed(1)}%',
            change: '+${engagementChange.toStringAsFixed(1)}%',
            isPositive: engagementChange > 0,
            isDark: isDark,
          ),
        ),

        const SizedBox(width: 12),

        // Total Reach
        Expanded(
          child: _buildStatCard(
            icon: Icons.people_outline,
            iconColor: AppColors.darkAccentOrange,
            label: l10n.get('total_reach'),
            value: _formatNumber(totalReach),
            change: '+${_formatNumber(reachChange)}',
            isPositive: reachChange > 0,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String change,
    required bool isPositive,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // İkon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),

          const SizedBox(height: 12),

          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),

          const SizedBox(height: 4),

          // Value ve Change
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPositive
                      ? AppColors.darkSuccess
                      : AppColors.darkAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sayı formatı (1000 -> 1k, 1000000 -> 1M)
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
