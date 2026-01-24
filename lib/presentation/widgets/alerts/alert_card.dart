import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Uyarı tipi enum'u
enum AlertType {
  followerDrop,
  ghostFollower,
  engagementDrop,
  activeHourChanged,
  newUnfollowers,
  tip,
}

/// Uyarı modeli
class AlertItem {
  final String id;
  final AlertType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;

  AlertItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });

  AlertItem copyWith({bool? isRead}) {
    return AlertItem(
      id: id,
      type: type,
      title: title,
      description: description,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      data: data,
    );
  }
}

/// Tek bir uyarı kartı
class AlertCard extends StatelessWidget {
  final AlertItem alert;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AlertCard({super.key, required this.alert, this.onTap, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final alertConfig = _getAlertConfig(alert.type);

    return Dismissible(
      key: Key(alert.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: alert.isRead
              ? null
              : Border.all(
                  color: alertConfig.color.withValues(alpha: 0.3),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İkon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          alertConfig.color,
                          alertConfig.color.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: alertConfig.color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      alertConfig.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // İçerik
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: alert.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            if (!alert.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: alertConfig.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTime(alert.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.darkTextHint
                                : AppColors.lightTextHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _AlertConfig _getAlertConfig(AlertType type) {
    switch (type) {
      case AlertType.followerDrop:
        return _AlertConfig(
          icon: Icons.trending_down,
          color: const Color(0xFFFF6B6B),
        );
      case AlertType.ghostFollower:
        return _AlertConfig(
          icon: Icons.visibility_off,
          color: const Color(0xFF9B59B6),
        );
      case AlertType.engagementDrop:
        return _AlertConfig(
          icon: Icons.show_chart,
          color: const Color(0xFFE67E22),
        );
      case AlertType.activeHourChanged:
        return _AlertConfig(
          icon: Icons.schedule,
          color: const Color(0xFF3498DB),
        );
      case AlertType.newUnfollowers:
        return _AlertConfig(
          icon: Icons.person_remove,
          color: const Color(0xFFE74C3C),
        );
      case AlertType.tip:
        return _AlertConfig(
          icon: Icons.lightbulb,
          color: const Color(0xFF2ECC71),
        );
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Şimdi';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} dk önce';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} saat önce';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} gün önce';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}

class _AlertConfig {
  final IconData icon;
  final Color color;

  _AlertConfig({required this.icon, required this.color});
}
