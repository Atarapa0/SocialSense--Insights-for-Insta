import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Stats Row (Karşılıklı, Geri Takip Etmiyor, İlgi Alanı, Kayıtlı İçerik)
/// 2x2 Grid şeklinde istatistik kartları
class StatsRow extends StatelessWidget {
  final int mutualCount;
  final int notFollowingBackCount;
  final int interestsCount;
  final int savedCount;
  final VoidCallback onTap;

  const StatsRow({
    super.key,
    required this.mutualCount,
    required this.notFollowingBackCount,
    required this.interestsCount,
    required this.savedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2, // Daha yatay kartlar (Görseldeki gibi)
        children: [
          _buildStatCard(
            context,
            'Karşılıklı',
            mutualCount,
            Icons.people_outline,
            const Color(0xFF00C853), // Yeşil
            isDark,
          ),
          _buildStatCard(
            context,
            'Geri Takip Etmiyor',
            notFollowingBackCount,
            Icons.person_off_outlined,
            const Color(0xFFFF9100), // Turuncu
            isDark,
          ),
          _buildStatCard(
            context,
            'İlgi Alanı',
            interestsCount,
            Icons.auto_awesome_outlined,
            const Color(0xFFFFD600), // Sarı
            isDark,
          ),
          _buildStatCard(
            context,
            'Kayıtlı İçerik',
            savedCount,
            Icons.bookmark_border,
            const Color(0xFF00B8D4), // Cyan
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    int value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    // Binlik ayırıcı olarak nokta kullan (Örn: 18.343)
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
