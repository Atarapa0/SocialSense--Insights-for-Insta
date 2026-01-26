import 'package:flutter/material.dart';

class CloseFriendsCard extends StatelessWidget {
  final List<String> closeFriends;

  const CloseFriendsCard({super.key, required this.closeFriends});

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.star, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yakın Arkadaşlar',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${closeFriends.length} kişi ekli',
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
          if (closeFriends.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('Yakın arkadaş listeniz boş veya bulunamadı.'),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: closeFriends.map((friend) {
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      friend.isNotEmpty ? friend[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  label: Text(friend),
                  backgroundColor: Colors.green.withOpacity(0.05),
                  side: BorderSide(color: Colors.green.withOpacity(0.2)),
                  labelStyle: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
