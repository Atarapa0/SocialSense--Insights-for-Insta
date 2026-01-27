import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';
import 'package:socialsense/core/utils/instagram_launcher.dart';

class ReelsShareCard extends StatelessWidget {
  final Map<String, int> sentReels;
  final Map<String, int> receivedReels;
  final VoidCallback? onSentTap;
  final VoidCallback? onReceivedTap;

  const ReelsShareCard({
    super.key,
    required this.sentReels,
    required this.receivedReels,
    this.onSentTap,
    this.onReceivedTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sortedSent = sentReels.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sortedReceived = receivedReels.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Veri yoksa gösterme
    if (sortedSent.isEmpty && sortedReceived.isEmpty) {
      return const SizedBox.shrink();
    }

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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.movie_filter_outlined,
                  color: Colors.pink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reels Etkileşimleri',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Reels paylaşım istatistikleri',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // İki Sütunlu Yapı
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol: Senin Attıkların
                Expanded(
                  child: _buildDataColumn(
                    context,
                    title: 'Senin Attıkların',
                    data: sortedSent,
                    isDark: isDark,
                    accentColor: Colors.pink,
                    onSeeAll: onSentTap,
                  ),
                ),

                // Dikey Çizgi
                Container(
                  width: 1,
                  color: isDark ? Colors.white12 : Colors.black12,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                // Sağ: Sana Gelenler
                Expanded(
                  child: _buildDataColumn(
                    context,
                    title: 'Sana Gelenler',
                    data: sortedReceived,
                    isDark: isDark,
                    accentColor: Colors.purple,
                    onSeeAll: onReceivedTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataColumn(
    BuildContext context, {
    required String title,
    required List<MapEntry<String, int>> data,
    required bool isDark,
    required Color accentColor,
    VoidCallback? onSeeAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolon Başlığı
        Row(
          children: [
            Icon(Icons.arrow_right_alt, color: accentColor, size: 16),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Liste Elemanları
        if (data.isEmpty)
          const Text(
            'Veri yok',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        else
          ...data.take(5).map((e) => _buildRowItem(context, e, isDark)),

        // Tümü Butonu
        if (data.length > 5) ...[
          const SizedBox(height: 8),
          Center(
            child: InkWell(
              onTap: onSeeAll,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  'Tümü',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRowItem(
    BuildContext context,
    MapEntry<String, int> entry,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => InstagramLauncher.openProfile(entry.key),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 10,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              child: Text(
                entry.key.isNotEmpty ? entry.key[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${entry.value}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
