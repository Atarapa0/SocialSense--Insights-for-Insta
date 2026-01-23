import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';

/// Priority Card (Unfollowers/Takipten Çıkanlar)
/// Görseldeki kırmızı/mor gradient kartı
class PriorityCard extends StatelessWidget {
  final int unfollowersCount;
  final String message;

  const PriorityCard({
    super.key,
    required this.unfollowersCount,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.priorityCardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.darkAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst kısım: Badge + Ok ikonu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // High Priority badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkAccent.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.darkAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.get('high_priority'),
                      style: const TextStyle(
                        color: AppColors.darkAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Sağ ok
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Sayı
          Text(
            unfollowersCount.toString(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),

          const SizedBox(height: 8),

          // Başlık
          Text(
            l10n.get('unfollowers'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          // Açıklama
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // Analyze buton
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.get('analyze_drop'),
                  style: const TextStyle(
                    color: AppColors.lightTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.bar_chart,
                  size: 16,
                  color: AppColors.darkPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
