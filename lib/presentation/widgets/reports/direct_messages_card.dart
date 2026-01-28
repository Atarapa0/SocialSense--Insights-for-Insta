import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

import 'package:socialsense/core/localization/app_localizations.dart';

class DirectMessagesCard extends StatelessWidget {
  final int totalChats;
  final int totalMessages;
  final Map<String, int> sentMessagesMap;
  final Map<String, int> receivedMessagesMap;
  final VoidCallback? onSentTap;
  final VoidCallback? onReceivedTap;

  const DirectMessagesCard({
    super.key,
    required this.totalChats,
    required this.totalMessages,
    required this.sentMessagesMap,
    required this.receivedMessagesMap,
    this.onSentTap,
    this.onReceivedTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final sentTotal = sentMessagesMap.values.fold(0, (a, b) => a + b);
    final receivedTotal = receivedMessagesMap.values.fold(0, (a, b) => a + b);

    final sortedSent = sentMessagesMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sortedReceived = receivedMessagesMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
                    l10n.get('direct_messages'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '$totalChats ${l10n.get('chats')}, ${l10n.get('total')} $totalMessages ${l10n.get('messages')}',
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

          // İstatistik Kutucukları
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  context,
                  l10n.get('total_sent'),
                  sentTotal,
                  Colors.blue,
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  context,
                  l10n.get('total_received'),
                  receivedTotal,
                  Colors.purple,
                  isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Divider(color: isDark ? Colors.white10 : Colors.black12, height: 1),
          const SizedBox(height: 20),

          // Listeler (Split View - Clean Design)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildSimpleList(
                    context,
                    l10n.get('sent_by_you'),
                    sortedSent,
                    onSentTap,
                    isDark,
                    Colors.blue,
                    l10n,
                  ),
                ),

                Container(
                  width: 1,
                  color: isDark ? Colors.white12 : Colors.black12,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                Expanded(
                  child: _buildSimpleList(
                    context,
                    l10n.get('received_by_you'),
                    sortedReceived,
                    onReceivedTap,
                    isDark,
                    Colors.purple,
                    l10n,
                  ),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleList(
    BuildContext context,
    String title,
    List<MapEntry<String, int>> items,
    VoidCallback? onSeeAll,
    bool isDark,
    Color accentColor,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        if (items.isEmpty)
          Text(
            l10n.get('no_data'),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

        ...items
            .take(5)
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.key,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${e.value}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

        if (items.length > 5) ...[
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
                  l10n.get('see_all'),
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
}
