import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/utils/instagram_launcher.dart';

/// Takipçi Detayları Kartı
/// Karşılıklı takipler, seni takip etmeyenler gibi bilgileri gösterir
class FollowerDetailsCard extends StatelessWidget {
  final int mutualFollowersCount;
  final List<String> mutualFollowers;
  final int notFollowingYouCount;
  final List<String> notFollowingYou;
  final int youDontFollowCount;
  final List<String> youDontFollow;
  final VoidCallback? onMutualTap;
  final VoidCallback? onNotFollowingYouTap;
  final VoidCallback? onYouDontFollowTap;

  const FollowerDetailsCard({
    super.key,
    required this.mutualFollowersCount,
    required this.mutualFollowers,
    required this.notFollowingYouCount,
    required this.notFollowingYou,
    required this.youDontFollowCount,
    required this.youDontFollow,
    this.onMutualTap,
    this.onNotFollowingYouTap,
    this.onYouDontFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Text(
          'Takipçi Detayları',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Karşılıklı Takipler ve Seni Takip Edip Takip Etmediğin
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildFollowerSection(
                  context,
                  title: 'Karşılıklı\nTakipler',
                  count: mutualFollowersCount,
                  accounts: mutualFollowers,
                  onTap: onMutualTap,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFollowerSection(
                  context,
                  title: 'Geri Takip\nEtmediklerin',
                  count: youDontFollowCount,
                  accounts: youDontFollow,
                  onTap: onYouDontFollowTap,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Seni Geri Takip Etmeyenler
        _buildFollowerSection(
          context,
          title: 'Seni Geri Takip\nEtmeyenler',
          count: notFollowingYouCount,
          accounts: notFollowingYou,
          onTap: onNotFollowingYouTap,
          isDark: isDark,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildFollowerSection(
    BuildContext context, {
    required String title,
    required int count,
    required List<String> accounts,
    VoidCallback? onTap,
    required bool isDark,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Başlık ve sayı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$count hesap',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Hesap listesi (ilk 3)
            ...accounts.take(3).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final account = entry.value;
              return _buildAccountItem(index + 1, account, isDark);
            }),

            if (count > 3) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.1)
                      : AppColors.lightPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Tümü Gör',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(int rank, String username, bool isDark) {
    return InkWell(
      onTap: () => InstagramLauncher.openProfile(username),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            // Sıra numarası
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Kullanıcı adı
            Expanded(
              child: Text(
                username,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Instagram'da aç ikonu
            Icon(
              Icons.open_in_new,
              size: 14,
              color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint,
            ),
          ],
        ),
      ),
    );
  }
}
