import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

/// Aktivite Profili Kartı
/// Resimdeki "Sen bir Akşamcısun!" tipi aktivite profili gösterimi
class ActivityProfileCard extends StatelessWidget {
  final String profileType; // 'morning', 'afternoon', 'evening', 'night'
  final int dominantPercentage;
  final Map<String, int>
  timeDistribution; // Sabahçı, Öğlenci, Akşamcı, Gece Kuşu
  final int weekdayPercentage;
  final int weekendPercentage;
  final bool showDetails;
  final VoidCallback? onTap;

  const ActivityProfileCard({
    super.key,
    required this.profileType,
    required this.dominantPercentage,
    required this.timeDistribution,
    required this.weekdayPercentage,
    required this.weekendPercentage,
    this.showDetails = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Icon(
                  Icons.auto_awesome,
                  color: const Color(0xFFFF6B9D),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aktivite Profilin',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (showDetails) ...[
              // Detaylı görünüm (Raporlar için)
              _buildDetailedView(isDark),
            ] else ...[
              // Özet görünüm (Anasayfa için)
              _buildSummaryView(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryView(bool isDark) {
    return Row(
      children: [
        // Sol: Profil tipi ve icon
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildProfileIcon(),
              const SizedBox(height: 12),
              Text(
                _getProfileTitle(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'Etkileşimlerinin '),
                    TextSpan(
                      text: '%$dominantPercentage',
                      style: const TextStyle(
                        color: Color(0xFFFF6B9D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '\'${_getProfileTimeRange()}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Sağ: Hafta içi/sonu oranları
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSimpleBar('Hafta içi', weekdayPercentage, isDark),
              const SizedBox(height: 12),
              _buildSimpleBar('Hafta sonu', weekendPercentage, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedView(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sol: Profil tipi ve icon
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1A1A2E), const Color(0xFF2D1F3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildProfileIcon(size: 60),
                const SizedBox(height: 16),
                Text(
                  _getProfileTitle(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Etkileşimlerinin '),
                      TextSpan(
                        text: '%$dominantPercentage',
                        style: const TextStyle(
                          color: Color(0xFFFF6B9D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '\'i ${_getProfileTimeRange()} saatlerinde',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Sağ: Zaman dağılımı
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Zaman Dağılımı',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTimeDistributionItem(
                '🌅 Sabahçı (06:00-12:00)',
                timeDistribution['morning'] ?? 0,
                const Color(0xFFFFD93D),
                isDark,
              ),
              const SizedBox(height: 10),
              _buildTimeDistributionItem(
                '☀️ Öğlenci (12:00-18:00)',
                timeDistribution['afternoon'] ?? 0,
                const Color(0xFFFF9800),
                isDark,
              ),
              const SizedBox(height: 10),
              _buildTimeDistributionItem(
                '🌆 Akşamcı (18:00-24:00)',
                timeDistribution['evening'] ?? 0,
                const Color(0xFFFF6B9D),
                isDark,
              ),
              const SizedBox(height: 10),
              _buildTimeDistributionItem(
                '🦉 Gece Kuşu (00:00-06:00)',
                timeDistribution['night'] ?? 0,
                const Color(0xFF9C27B0),
                isDark,
              ),
              const SizedBox(height: 20),
              // Hafta içi/sonu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hafta içi: %$weekdayPercentage',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    'Hafta sonu: %$weekendPercentage',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileIcon({double size = 48}) {
    String emoji;
    switch (profileType) {
      case 'morning':
        emoji = '🌅';
        break;
      case 'afternoon':
        emoji = '☀️';
        break;
      case 'evening':
        emoji = '🌆';
        break;
      case 'night':
        emoji = '🦉';
        break;
      default:
        emoji = '🌆';
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2D1F3D), const Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: size * 0.5)),
      ),
    );
  }

  Widget _buildSimpleBar(String label, int percentage, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
            ),
            Text(
              '%$percentage',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B9D),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeDistributionItem(
    String label,
    int percentage,
    Color color,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            Text(
              '%$percentage',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getProfileTitle() {
    switch (profileType) {
      case 'morning':
        return 'Sen bir Sabahçısın!';
      case 'afternoon':
        return 'Sen bir Öğlencişin!';
      case 'evening':
        return 'Sen bir Akşamcısın!';
      case 'night':
        return 'Sen bir Gece Kuşusun!';
      default:
        return 'Sen bir Akşamcısın!';
    }
  }

  String _getProfileTimeRange() {
    switch (profileType) {
      case 'morning':
        return 'i sabah';
      case 'afternoon':
        return 'i öğle';
      case 'evening':
        return 'i akşam';
      case 'night':
        return 'i gece';
      default:
        return 'i akşam';
    }
  }
}
