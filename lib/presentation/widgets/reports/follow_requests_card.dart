import 'package:flutter/material.dart';
import 'package:socialsense/core/constants/app_colors.dart';

class FollowRequestsCard extends StatefulWidget {
  final List<String> sentRequests;
  final List<String> receivedRequests;

  const FollowRequestsCard({
    super.key,
    required this.sentRequests,
    required this.receivedRequests,
  });

  @override
  State<FollowRequestsCard> createState() => _FollowRequestsCardState();
}

class _FollowRequestsCardState extends State<FollowRequestsCard> {
  int _tabIndex = 0; // 0: Giden, 1: Gelen

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sentCount = widget.sentRequests.length;
    final receivedCount = widget.receivedRequests.length;

    // Aktif listeyi seç
    final activeList = _tabIndex == 0
        ? widget.sentRequests
        : widget.receivedRequests;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? AppColors.darkCard : AppColors.lightCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header: Başlık ve Tablar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Takip İstekleri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                // Toggle Buttons (Custom)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(context, 'Gönderilen ($sentCount)', 0),
                      const SizedBox(width: 4),
                      _buildTabButton(context, 'Gelen ($receivedCount)', 1),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Liste
            SizedBox(
              height: 250, // Sabit yükseklik
              child: activeList.isEmpty
                  ? Center(
                      child: Text(
                        _tabIndex == 0
                            ? 'Bekleyen gönderilen istek yok.'
                            : 'Gelen takip isteği yok.',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: activeList.length,
                      separatorBuilder: (_, __) => Divider(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: _tabIndex == 0
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                            child: Icon(
                              _tabIndex == 0
                                  ? Icons.outbound_outlined
                                  : Icons.move_to_inbox_outlined,
                              color: _tabIndex == 0
                                  ? Colors.orange
                                  : Colors.green,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            activeList[index],
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String text, int index) {
    final isSelected = _tabIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}
