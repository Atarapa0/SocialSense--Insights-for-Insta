import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

class StatsRow extends StatelessWidget {
  final int mutualCount;
  final int notFollowingBackCount;
  final int savedCount;
  final int totalLikes;
  final int followerCount;
  final int followingCount;
  final VoidCallback onTap;

  const StatsRow({
    super.key,
    required this.mutualCount,
    required this.notFollowingBackCount,
    required this.savedCount,
    required this.totalLikes,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6, // Yükseklik ayarı
        children: [
          // 1. Karşılıklı
          _buildStatCard(
            context,
            'Karşılıklı',
            mutualCount,
            Icons.people_outline,
            const Color(0xFF00C853), // Yeşil
            isDark,
          ),
          // 2. Geri Takip Etmeyen
          _buildStatCard(
            context,
            'Geri Takip Etmiyor',
            notFollowingBackCount,
            Icons.person_off_outlined,
            const Color(0xFFFF9100), // Turuncu
            isDark,
          ),
          // 3. Toplam Beğeni (İlgi Alanı yerine)
          _buildStatCard(
            context,
            'Toplam Beğeni',
            totalLikes,
            Icons.favorite_border,
            const Color(0xFFFF1744), // Kırmızı
            isDark,
          ),
          // 4. Kayıtlı İçerik
          _buildStatCard(
            context,
            'Kayıtlı İçerik',
            savedCount,
            Icons.bookmark_border,
            const Color(0xFF00B8D4), // Cyan
            isDark,
          ),
          // 5. Takipçi (Yeni)
          _buildStatCard(
            context,
            'Takipçi',
            followerCount,
            Icons.group_outlined,
            const Color(0xFF2962FF), // Mavi
            isDark,
          ),
          // 6. Takip Edilen (Yeni)
          _buildStatCard(
            context,
            'Takip Edilen',
            followingCount,
            Icons.person_add_outlined,
            const Color(0xFF6200EA), // Mor
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 14),
              ),
            ],
          ),
          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 20,
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
