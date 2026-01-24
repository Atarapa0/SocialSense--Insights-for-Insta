import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Takip Durumu Kartı
/// Karşılıklı takip ve geri takip etmeyenler istatistiklerini gösterir
class FollowStatusCard extends StatelessWidget {
  final int mutualFollowers;
  final int notFollowingBack;
  final VoidCallback? onMutualTap;
  final VoidCallback? onNotFollowingTap;

  const FollowStatusCard({
    super.key,
    required this.mutualFollowers,
    required this.notFollowingBack,
    this.onMutualTap,
    this.onNotFollowingTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Karşılıklı Takip
        Expanded(
          child: GestureDetector(
            onTap: onMutualTap,
            child: _buildStatusItem(
              context,
              icon: Icons.sync_alt,
              iconColor: const Color(0xFF4CAF50),
              label: 'Karşılıklı',
              value: mutualFollowers,
              isDark: isDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Geri Takip Etmiyor
        Expanded(
          child: GestureDetector(
            onTap: onNotFollowingTap,
            child: _buildStatusItem(
              context,
              icon: Icons.person_off,
              iconColor: const Color(0xFFE53935),
              label: 'Geri Takip Etmiyor',
              value: notFollowingBack,
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required int value,
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
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.lightCardShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark
                    ? AppColors.darkTextHint
                    : AppColors.lightTextHint,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
