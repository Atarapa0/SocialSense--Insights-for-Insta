import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Hesap Analizi Model
class AccountAnalysis {
  final String username;
  final int count;

  const AccountAnalysis({required this.username, required this.count});
}

/// Hesap Analizleri Kartı
/// En çok beğenilen, en çok yorum yapılan hesapları gösterir
class AccountAnalysisCard extends StatelessWidget {
  final int mostLikedCount;
  final List<AccountAnalysis> mostLikedAccounts;
  final int mostCommentedCount;
  final List<AccountAnalysis> mostCommentedAccounts;
  final VoidCallback? onMostLikedTap;
  final VoidCallback? onMostCommentedTap;

  const AccountAnalysisCard({
    super.key,
    required this.mostLikedCount,
    required this.mostLikedAccounts,
    required this.mostCommentedCount,
    required this.mostCommentedAccounts,
    this.onMostLikedTap,
    this.onMostCommentedTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Text(
          'Hesap Analizleri',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // En Çok Beğendiğin ve En Çok Yorum Yaptığın
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildAnalysisSection(
                  context,
                  title: 'En Çok\nBeğendiğin H...',
                  count: mostLikedCount,
                  accounts: mostLikedAccounts,
                  onTap: onMostLikedTap,
                  isDark: isDark,
                  iconData: Icons.favorite,
                  iconColor: const Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalysisSection(
                  context,
                  title: 'En Çok Yorum\nYaptığın Hesa...',
                  count: mostCommentedCount,
                  accounts: mostCommentedAccounts,
                  onTap: onMostCommentedTap,
                  isDark: isDark,
                  iconData: Icons.chat_bubble,
                  iconColor: const Color(0xFF4ECDC4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisSection(
    BuildContext context, {
    required String title,
    required int count,
    required List<AccountAnalysis> accounts,
    VoidCallback? onTap,
    required bool isDark,
    required IconData iconData,
    required Color iconColor,
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
                      fontSize: 13,
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
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Hesap listesi (ilk 3)
            ...accounts.take(3).map((account) {
              return _buildAccountItem(account, isDark, iconData, iconColor);
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
                    'Tümünü Gör',
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

  Widget _buildAccountItem(
    AccountAnalysis account,
    bool isDark,
    IconData iconData,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                account.username.length > 1
                    ? account.username[1].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Kullanici adi
          Expanded(
            child: Text(
              account.username,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Sayi
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, size: 12, color: iconColor),
              const SizedBox(width: 4),
              Text(
                '${account.count}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
