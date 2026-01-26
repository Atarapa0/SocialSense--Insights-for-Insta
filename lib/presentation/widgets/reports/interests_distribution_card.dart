import 'package:flutter/material.dart';

class InterestsDistributionCard extends StatelessWidget {
  final Map<String, List<String>> interests;

  const InterestsDistributionCard({super.key, required this.interests});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Spor':
        return Icons.sports_soccer;
      case 'Yemek & İçecek':
        return Icons.restaurant;
      case 'Oyun & Teknoloji':
        return Icons.sports_esports;
      case 'Moda & Güzellik':
        return Icons.checkroom;
      case 'Hayvanlar':
        return Icons.pets;
      case 'Sanat & Eğlence':
        return Icons.theater_comedy;
      case 'Seyahat':
        return Icons.flight;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Spor':
        return Colors.green;
      case 'Yemek & İçecek':
        return Colors.orange;
      case 'Oyun & Teknoloji':
        return Colors.blue;
      case 'Moda & Güzellik':
        return Colors.pink;
      case 'Hayvanlar':
        return Colors.brown;
      case 'Sanat & Eğlence':
        return Colors.purple;
      case 'Seyahat':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İlgi Alanları (${interests.length} Kategori)',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (interests.isEmpty)
            const Center(child: Text('İlgi alanı verisi bulunamadı.')),

          ...interests.entries.map((entry) {
            final color = _getCategoryColor(entry.key);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(entry.key),
                      color: color,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${entry.value.length}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: entry.value.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(item, style: TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
