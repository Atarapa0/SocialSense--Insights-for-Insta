import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

class MessageAnalysis {
  final String username;
  final int messageCount;
  const MessageAnalysis({required this.username, required this.messageCount});
}

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.message_outlined, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Direkt Mesajlar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '$totalChats sohbet, $totalMessages mesaj',
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

          const SizedBox(height: 20),

          // İstatistikler (Gelen/Giden)
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  context,
                  'Giden',
                  sentMessages,
                  Colors.blue,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  context,
                  'Gelen',
                  receivedMessages,
                  Colors.purple,
                  isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Liste
          const Text(
            'En Çok Mesajlaşılanlar',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          if (mostMessaged.isEmpty)
            const Center(child: Text('Veri yok'))
          else
            ...mostMessaged.map((m) => _buildUserRow(context, m, isDark)),

          if (mostMessaged.isNotEmpty) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: onMostMessagedTap,
                child: const Text('Tümünü Gör'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    String label,
    int value,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatNumber(value),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(
    BuildContext context,
    MessageAnalysis item,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            child: Text(
              item.username.isNotEmpty && item.username.startsWith('@')
                  ? item.username[1].toUpperCase()
                  : (item.username.isNotEmpty
                        ? item.username[0].toUpperCase()
                        : '?'),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.username,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            _formatNumber(item.messageCount),
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
