import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

class ReelsShareCard extends StatefulWidget {
  final Map<String, int> sentReels;
  final Map<String, int> receivedReels;

  const ReelsShareCard({
    super.key,
    required this.sentReels,
    required this.receivedReels,
  });

  @override
  State<ReelsShareCard> createState() => _ReelsShareCardState();
}

class _ReelsShareCardState extends State<ReelsShareCard> {
  bool _isSentExpanded = false;
  bool _isReceivedExpanded = false;
  static const int _initialCount = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sortedSent = widget.sentReels.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sortedReceived = widget.receivedReels.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sentCount = sortedSent.length;
    final receivedCount = sortedReceived.length;

    // Veri yoksa gösterme
    if (sentCount == 0 && receivedCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.darkAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.movie_filter_outlined,
                  color: AppColors.darkAccent,
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
                    'En çok kiminle reels paylaşıyorsun?',
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

          // 1. Bölüm: En Çok Gönderdiklerin
          if (sentCount > 0) ...[
            _buildSectionHeader(context, 'Senin Gönderdiklerin', isDark),
            const SizedBox(height: 12),
            ...sortedSent
                .take(_isSentExpanded ? sentCount : _initialCount)
                .map((e) => _buildUserRow(context, e, isDark)),
            if (sentCount > _initialCount)
              Center(
                child: TextButton(
                  onPressed: () =>
                      setState(() => _isSentExpanded = !_isSentExpanded),
                  child: Text(
                    _isSentExpanded ? 'Daha Az Göster' : 'Tümünü Gör',
                    style: const TextStyle(color: AppColors.darkAccent),
                  ),
                ),
              ),
          ],

          if (sentCount > 0 && receivedCount > 0) ...[
            const SizedBox(height: 20),
            Divider(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            const SizedBox(height: 20),
          ],

          // 2. Bölüm: Sana Gönderenler
          if (receivedCount > 0) ...[
            _buildSectionHeader(context, 'Sana Gönderenler', isDark),
            const SizedBox(height: 12),
            ...sortedReceived
                .take(_isReceivedExpanded ? receivedCount : _initialCount)
                .map((e) => _buildUserRow(context, e, isDark)),
            if (receivedCount > _initialCount)
              Center(
                child: TextButton(
                  onPressed: () => setState(
                    () => _isReceivedExpanded = !_isReceivedExpanded,
                  ),
                  child: Text(
                    _isReceivedExpanded ? 'Daha Az Göster' : 'Tümünü Gör',
                    style: const TextStyle(color: AppColors.darkAccent),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  Widget _buildUserRow(
    BuildContext context,
    MapEntry<String, int> entry,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.darkAccent.withOpacity(0.1),
            radius: 18,
            child: Text(
              entry.key.isNotEmpty ? entry.key[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.darkAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.key, // Username
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.darkAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${entry.value} reels',
              style: const TextStyle(
                color: AppColors.darkAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
