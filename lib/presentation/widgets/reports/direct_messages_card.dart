import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/utils/instagram_launcher.dart';

/// Mesaj Analizi Model
class MessageAnalysis {
  final String username;
  final int messageCount;

  const MessageAnalysis({required this.username, required this.messageCount});
}

/// Direkt Mesajlar Kartı
/// Mesaj istatistiklerini ve en çok yazışılan kişileri gösterir
class DirectMessagesCard extends StatelessWidget {
  final int totalChats;
  final int totalMessages;
  final int sentMessages;
  final int receivedMessages;
  final List<MessageAnalysis> mostMessaged;
  final List<MessageAnalysis> mostMessagedBy;
  final VoidCallback? onMostMessagedTap;
  final VoidCallback? onMostMessagedByTap;

  const DirectMessagesCard({
    super.key,
    required this.totalChats,
    required this.totalMessages,
    required this.sentMessages,
    required this.receivedMessages,
    required this.mostMessaged,
    required this.mostMessagedBy,
    this.onMostMessagedTap,
    this.onMostMessagedByTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              const Icon(
                Icons.mail_outline,
                color: AppColors.darkPrimary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Direkt Mesajlar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // İstatistik kartları
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: 'Sohbet',
                  value: totalChats,
                  color: AppColors.darkPrimary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  label: 'Toplam Mesaj',
                  value: totalMessages,
                  color: Colors.white,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  label: 'Gönderilen (Metin)',
                  value: sentMessages,
                  color: const Color(0xFF4CAF50),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  label: 'Alınan (Metin)',
                  value: receivedMessages,
                  color: const Color(0xFF4ECDC4),
                  isDark: isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // En Çok Yazdığın ve Sana En Çok Yazan
          Row(
            children: [
              Expanded(
                child: _buildPersonList(
                  icon: Icons.send,
                  title: 'En Çok Yazdığın Kişiler',
                  accounts: mostMessaged,
                  onTap: onMostMessagedTap,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPersonList(
                  icon: Icons.inbox,
                  title: 'Sana En Çok Yazan Kişiler',
                  accounts: mostMessagedBy,
                  onTap: onMostMessagedByTap,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required int value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder.withValues(alpha: 0.5)
              : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonList({
    required IconData icon,
    required String title,
    required List<MessageAnalysis> accounts,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.3)
              : AppColors.lightSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.3)
                : AppColors.lightBorder.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.darkPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Kişi listesi
            ...accounts.take(5).map((account) {
              return _buildPersonItem(account, isDark);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonItem(MessageAnalysis account, bool isDark) {
    return InkWell(
      onTap: () => InstagramLauncher.openProfile(account.username),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  account.username.isNotEmpty
                      ? account.username.replaceAll('@', '')[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Kullanici adi
            Expanded(
              child: Text(
                account.username,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Mesaj sayisi
            Text(
              '${account.messageCount}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}.${((number % 1000) / 100).toInt()}${((number % 100) / 10).toInt()}${number % 10}';
    }
    return number.toString();
  }
}
