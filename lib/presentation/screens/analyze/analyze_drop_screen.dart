import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/localization/app_localizations.dart';
import 'package:socialsense/core/utils/instagram_launcher.dart';

/// Unfollowers modeli
class Unfollower {
  final String username;
  final String? avatarUrl;
  final DateTime unfollowedAt;
  final int daysSinceUnfollow;

  const Unfollower({
    required this.username,
    this.avatarUrl,
    required this.unfollowedAt,
    required this.daysSinceUnfollow,
  });
}

/// Düşüş Analizi Ekranı
/// Takipten çıkanların detaylı analizi
class AnalyzeDropScreen extends StatelessWidget {
  final int unfollowersCount;
  final List<Unfollower> unfollowers;

  const AnalyzeDropScreen({
    super.key,
    required this.unfollowersCount,
    required this.unfollowers,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: _buildAppBar(context, l10n, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unfollowers listesi
            _buildUnfollowersList(l10n, isDark),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        l10n.get('recent_unfollowers'),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      centerTitle: true,
    );
  }

  /// Unfollowers listesi
  Widget _buildUnfollowersList(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.get('recent_unfollowers'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${unfollowers.length} ${l10n.get('total')}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Liste
          ...unfollowers.take(10).map((u) => _buildUnfollowerItem(u, isDark)),
        ],
      ),
    );
  }

  Widget _buildUnfollowerItem(Unfollower unfollower, bool isDark) {
    return InkWell(
      onTap: () => InstagramLauncher.openProfile(unfollower.username),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.darkAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  unfollower.username[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.darkAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Kullanıcı bilgisi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unfollower.username,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'İnaktif Takip',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Unfollow ikonu
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.darkAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_remove,
                color: AppColors.darkAccent,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
