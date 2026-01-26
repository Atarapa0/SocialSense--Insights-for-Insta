import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Kayıtlı İçerik Hesabı Model
class SavedContentAccount {
  final String username;
  final int savedCount;

  const SavedContentAccount({required this.username, this.savedCount = 0});
}

/// Kayıtlı İçerikler Detay Kartı (Raporlar için)
class SavedContentDetailCard extends StatefulWidget {
  final int totalSavedContent;
  final List<SavedContentAccount> accounts;
  final int storyLikesCount;
  final List<SavedContentAccount> storyLikesAccounts;

  const SavedContentDetailCard({
    super.key,
    required this.totalSavedContent,
    required this.accounts,
    this.storyLikesCount = 0,
    this.storyLikesAccounts = const [],
  });

  @override
  State<SavedContentDetailCard> createState() => _SavedContentDetailCardState();
}

class _SavedContentDetailCardState extends State<SavedContentDetailCard> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Kayıtlı İçerikler
        _buildSavedContentSection(isDark),
        const SizedBox(height: 16),

        // Hikaye Beğenileri (opsiyonel)
        if (widget.storyLikesAccounts.isNotEmpty)
          _buildStoryLikesSection(isDark),
      ],
    );
  }

  Widget _buildSavedContentSection(bool isDark) {
    // İlk 5 hesap veya hepsi
    final displayAccounts = (_showAll || widget.accounts.length <= 5)
        ? widget.accounts
        : widget.accounts.take(5).toList();

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
          // Başlık
          Row(
            children: [
              Icon(Icons.bookmark, color: const Color(0xFF9C27B0), size: 22),
              const SizedBox(width: 10),
              Text(
                'Kayıtlı İçerikler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alt başlık
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.5)
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'En Çok Kaydettiğin Hesaplar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Hesap listesi
          ...displayAccounts.map(
            (account) => _buildAccountItem(account, isDark),
          ),

          // Tümünü Gör / Kapat Butonu
          if (widget.accounts.length > 5) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAll
                          ? 'Daha Az Göster'
                          : 'Tümünü Gör (+${widget.accounts.length - 5})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _showAll
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 16,
                      color: AppColors.darkAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoryLikesSection(bool isDark) {
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
          // Başlık
          Row(
            children: [
              Icon(Icons.favorite, color: const Color(0xFFE91E63), size: 22),
              const SizedBox(width: 10),
              Text(
                'Hikaye Beğenileri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '(${widget.storyLikesCount})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hesap listesi
          ...widget.storyLikesAccounts.map(
            (account) => _buildAccountItem(account, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(SavedContentAccount account, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.3)
            : AppColors.lightSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.3)
              : AppColors.lightBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                account.username.length > 1
                    ? account.username[1].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Username
          Expanded(
            child: Text(
              account.username,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          // Kayıt sayısı (opsiyonel)
          if (account.savedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.darkPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${account.savedCount}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
