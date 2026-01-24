import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Paylaşım Analizi Model
class SharingAnalysis {
  final String username;
  final int shareCount;

  const SharingAnalysis({required this.username, required this.shareCount});
}

/// Paylaşım Analizleri Kartı
/// Sana en çok reel/içerik atan ve en çok attığın hesapları gösterir
class SharingAnalysisCard extends StatelessWidget {
  final List<SharingAnalysis> receivedFromAccounts;
  final List<SharingAnalysis> sentToAccounts;
  final VoidCallback? onReceivedTap;
  final VoidCallback? onSentTap;

  const SharingAnalysisCard({
    super.key,
    required this.receivedFromAccounts,
    required this.sentToAccounts,
    this.onReceivedTap,
    this.onSentTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Sana En Çok Reel/İçerik Atan
        Expanded(
          child: _buildSharingSection(
            context,
            icon: '🎬',
            title: 'Sana En Çok Reel/İçerik Atan',
            accounts: receivedFromAccounts,
            onTap: onReceivedTap,
            isDark: isDark,
            countLabel: 'paylaşım',
          ),
        ),
        const SizedBox(width: 12),
        // En Çok Reel/İçerik Attığın
        Expanded(
          child: _buildSharingSection(
            context,
            icon: '📤',
            title: 'En Çok Reel/İçerik Attığın',
            accounts: sentToAccounts,
            onTap: onSentTap,
            isDark: isDark,
            countLabel: 'paylaşım',
          ),
        ),
      ],
    );
  }

  Widget _buildSharingSection(
    BuildContext context, {
    required String icon,
    required String title,
    required List<SharingAnalysis> accounts,
    VoidCallback? onTap,
    required bool isDark,
    required String countLabel,
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
            // Başlık
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
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
              ],
            ),
            const SizedBox(height: 14),

            // Hesap listesi
            ...accounts.take(5).map((account) {
              return _buildAccountItem(account, isDark, countLabel);
            }),

            if (accounts.length > 5) ...[
              const SizedBox(height: 8),
              Text(
                '+${accounts.length - 5} kişi daha',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.darkPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(
    SharingAnalysis account,
    bool isDark,
    String countLabel,
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
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                account.username.isNotEmpty
                    ? account.username[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 12,
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
          // Sayı
          Text(
            '${account.shareCount} $countLabel',
            style: TextStyle(
              fontSize: 10,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
