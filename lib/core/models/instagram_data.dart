/// Instagram veri modelleri
/// ZIP dosyasından parse edilen verileri temsil eder

/// Takipçi/Takip edilen kişi modeli
class InstagramUser {
  final String username;
  final String? profileUrl;
  final DateTime? followDate;

  const InstagramUser({
    required this.username,
    this.profileUrl,
    this.followDate,
  });

  factory InstagramUser.fromJson(Map<String, dynamic> json) {
    // Instagram JSON formatı: {"string_list_data": [{"value": "username", "timestamp": 1234567890}]}
    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;
      return InstagramUser(
        username: data['value'] ?? '',
        profileUrl: data['href'],
        followDate: data['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (data['timestamp'] as int) * 1000,
              )
            : null,
      );
    }
    return InstagramUser(username: json['value'] ?? '');
  }
}

/// Beğeni modeli
class InstagramLike {
  final String username;
  final String? mediaUrl;
  final DateTime timestamp;

  const InstagramLike({
    required this.username,
    this.mediaUrl,
    required this.timestamp,
  });

  factory InstagramLike.fromJson(Map<String, dynamic> json) {
    final stringListData = json['string_list_data'] as List?;
    String username = '';
    DateTime timestamp = DateTime.now();
    String? href;

    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;
      username = data['value'] ?? '';
      href = data['href'];
      if (data['timestamp'] != null) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(
          (data['timestamp'] as int) * 1000,
        );
      }
    }

    return InstagramLike(
      username: username,
      mediaUrl: href,
      timestamp: timestamp,
    );
  }
}

/// Yorum modeli
class InstagramComment {
  final String username;
  final String? commentText;
  final DateTime timestamp;

  const InstagramComment({
    required this.username,
    this.commentText,
    required this.timestamp,
  });

  factory InstagramComment.fromJson(Map<String, dynamic> json) {
    final stringListData = json['string_list_data'] as List?;
    String username = '';
    String? comment;
    DateTime timestamp = DateTime.now();

    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;
      username = data['value'] ?? '';
      if (data['timestamp'] != null) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(
          (data['timestamp'] as int) * 1000,
        );
      }
    }

    // Yorum metni title içinde olabilir
    comment = json['title'] as String?;

    return InstagramComment(
      username: username,
      commentText: comment,
      timestamp: timestamp,
    );
  }
}

/// Mesaj modeli
class InstagramMessage {
  final String participant;
  final int messageCount;
  final DateTime? lastMessageDate;

  const InstagramMessage({
    required this.participant,
    required this.messageCount,
    this.lastMessageDate,
  });
}

/// İlgi alanı modeli
class InstagramInterest {
  final String category;
  final List<String> items;

  const InstagramInterest({required this.category, required this.items});
}

/// Kaydedilen içerik modeli
class InstagramSavedItem {
  final String username;
  final String? mediaUrl;
  final DateTime? savedDate;

  const InstagramSavedItem({
    required this.username,
    this.mediaUrl,
    this.savedDate,
  });

  factory InstagramSavedItem.fromJson(Map<String, dynamic> json) {
    final stringListData = json['string_list_data'] as List?;
    String username = '';
    String? href;
    DateTime? savedDate;

    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;
      username = data['value'] ?? '';
      href = data['href'];
      if (data['timestamp'] != null) {
        savedDate = DateTime.fromMillisecondsSinceEpoch(
          (data['timestamp'] as int) * 1000,
        );
      }
    }

    return InstagramSavedItem(
      username: username,
      mediaUrl: href,
      savedDate: savedDate,
    );
  }
}

/// Ana Instagram veri modeli
/// Tüm parse edilen verileri içerir
class InstagramData {
  final List<InstagramUser> followers;
  final List<InstagramUser> following;
  final List<InstagramLike> likes;
  final List<InstagramComment> comments;
  final List<InstagramSavedItem> savedItems;
  final List<InstagramInterest> interests;
  final DateTime? dataExportDate;
  final DateTime loadedAt;

  InstagramData({
    required this.followers,
    required this.following,
    required this.likes,
    required this.comments,
    required this.savedItems,
    required this.interests,
    this.dataExportDate,
    DateTime? loadedAt,
  }) : loadedAt = loadedAt ?? DateTime.now();

  /// Boş veri
  factory InstagramData.empty() {
    return InstagramData(
      followers: [],
      following: [],
      likes: [],
      comments: [],
      savedItems: [],
      interests: [],
    );
  }

  /// Veri var mı kontrolü
  bool get hasData => followers.isNotEmpty || following.isNotEmpty;

  /// Karşılıklı takipleşenler
  List<String> get mutualFollowers {
    final followerUsernames = followers
        .map((f) => f.username.toLowerCase())
        .toSet();
    final followingUsernames = following
        .map((f) => f.username.toLowerCase())
        .toSet();
    return followerUsernames.intersection(followingUsernames).toList();
  }

  /// Sizi takip etmeyenler (siz takip ediyorsunuz ama onlar etmiyor)
  List<String> get notFollowingBack {
    final followerUsernames = followers
        .map((f) => f.username.toLowerCase())
        .toSet();
    return following
        .where((f) => !followerUsernames.contains(f.username.toLowerCase()))
        .map((f) => f.username)
        .toList();
  }

  /// Sizin takip etmedikleriniz (onlar takip ediyor ama siz etmiyorsunuz)
  List<String> get youDontFollow {
    final followingUsernames = following
        .map((f) => f.username.toLowerCase())
        .toSet();
    return followers
        .where((f) => !followingUsernames.contains(f.username.toLowerCase()))
        .map((f) => f.username)
        .toList();
  }

  /// En çok beğenilen hesaplar
  Map<String, int> get topLikedAccounts {
    final counts = <String, int>{};
    for (final like in likes) {
      counts[like.username] = (counts[like.username] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(10));
  }

  /// En çok yorum yapılan hesaplar
  Map<String, int> get topCommentedAccounts {
    final counts = <String, int>{};
    for (final comment in comments) {
      counts[comment.username] = (counts[comment.username] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(10));
  }

  /// Saatlik aktivite dağılımı (beğeniler)
  Map<int, int> get hourlyLikeActivity {
    final counts = <int, int>{};
    for (final like in likes) {
      final hour = like.timestamp.hour;
      counts[hour] = (counts[hour] ?? 0) + 1;
    }
    return counts;
  }

  /// En aktif saat
  int get mostActiveHour {
    final hourly = hourlyLikeActivity;
    if (hourly.isEmpty) return 12;
    return hourly.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Günlük aktivite dağılımı
  Map<int, int> get weekdayActivity {
    final counts = <int, int>{};
    for (final like in likes) {
      final weekday = like.timestamp.weekday;
      counts[weekday] = (counts[weekday] ?? 0) + 1;
    }
    return counts;
  }

  /// Engagement rate tahmini (basit hesaplama)
  double get estimatedEngagementRate {
    if (followers.isEmpty) return 0.0;
    // Son 30 günlük aktivite / takipçi sayısı
    final recentLikes = likes
        .where(
          (l) => l.timestamp.isAfter(
            DateTime.now().subtract(const Duration(days: 30)),
          ),
        )
        .length;
    return (recentLikes / followers.length) * 100;
  }

  /// Ghost follower tahmini (son 90 gün etkileşim olmayanlar)
  int get estimatedGhostFollowers {
    final activeUsernames = <String>{};
    final cutoffDate = DateTime.now().subtract(const Duration(days: 90));

    for (final like in likes.where((l) => l.timestamp.isAfter(cutoffDate))) {
      activeUsernames.add(like.username.toLowerCase());
    }
    for (final comment in comments.where(
      (c) => c.timestamp.isAfter(cutoffDate),
    )) {
      activeUsernames.add(comment.username.toLowerCase());
    }

    final followerUsernames = followers
        .map((f) => f.username.toLowerCase())
        .toSet();
    final ghostCount = followerUsernames.difference(activeUsernames).length;

    return ghostCount;
  }

  /// Ghost follower yüzdesi
  double get ghostFollowerPercentage {
    if (followers.isEmpty) return 0.0;
    return (estimatedGhostFollowers / followers.length) * 100;
  }

  /// En çok kaydedilen hesaplar
  Map<String, int> get topSavedAccounts {
    final counts = <String, int>{};
    for (final item in savedItems) {
      counts[item.username] = (counts[item.username] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(10));
  }
}
