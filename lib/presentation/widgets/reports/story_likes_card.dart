import 'package:flutter/material.dart';

class StoryLikesCard extends StatefulWidget {
  final Map<String, int> storyLikes;

  const StoryLikesCard({super.key, required this.storyLikes});

  @override
  State<StoryLikesCard> createState() => _StoryLikesCardState();
}

class _StoryLikesCardState extends State<StoryLikesCard> {
  bool _isExpanded = false;
  static const int _initialCount = 5;

  @override
  Widget build(BuildContext context) {
    final entries = widget.storyLikes.entries.toList();
    final itemCount = entries.length;
    final displayCount = _isExpanded
        ? itemCount
        : (itemCount > _initialCount ? _initialCount : itemCount);
    final displayedEntries = entries.take(displayCount);

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE1306C), Color(0xFFF77737)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.history_toggle_off,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'En Çok Hikaye Beğenenler',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Hikayelerine en çok tepki verenler',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (widget.storyLikes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('Hikaye beğenisi verisi bulunamadı.')),
            )
          else ...[
            ...displayedEntries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(
                          0xFFE1306C,
                        ).withOpacity(0.1),
                        child: Text(
                          entry.key.isNotEmpty
                              ? entry.key[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Color(0xFFE1306C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1306C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${entry.value} ❤️',
                          style: const TextStyle(
                            color: Color(0xFFE1306C),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (itemCount > _initialCount)
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Daha Az Göster' : 'Tümünü Gör',
                    style: const TextStyle(
                      color: Color(0xFFE1306C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
