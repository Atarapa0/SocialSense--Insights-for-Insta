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
    // Yeni Instagram formatı: {title: "username", string_list_data: [{href: ..., timestamp: ...}]}
    // Eski format: {string_list_data: [{value: "username", href: ..., timestamp: ...}]}

    String username = '';
    String? profileUrl;
    DateTime? followDate;

    // Önce 'title' alanını kontrol et (yeni format)
    if (json.containsKey('title') && json['title'] != null) {
      username = json['title'] as String;
    }

    // string_list_data'dan ek bilgileri al
    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;

      // Eğer username hala boşsa, value'dan al (eski format)
      if (username.isEmpty && data['value'] != null) {
        username = data['value'] as String;
      }

      profileUrl = data['href'] as String?;

      if (data['timestamp'] != null) {
        followDate = DateTime.fromMillisecondsSinceEpoch(
          (data['timestamp'] as int) * 1000,
        );
      }
    }

    return InstagramUser(
      username: username,
      profileUrl: profileUrl,
      followDate: followDate,
    );
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
    // Yeni Instagram formatı: {title: "username", string_list_data: [{href: ..., timestamp: ...}]}
    // Eski format: {string_list_data: [{value: "username", href: ..., timestamp: ...}]}

    String username = '';
    DateTime timestamp = DateTime.now();
    String? href;

    // Önce 'title' alanını kontrol et (yeni format)
    if (json.containsKey('title') && json['title'] != null) {
      username = json['title'] as String;
    }

    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;

      // Eğer username hala boşsa, value'dan al (eski format)
      if (username.isEmpty && data['value'] != null) {
        username = data['value'] as String;
      }

      href = data['href'] as String?;

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
    // Yeni Instagram formatı: {title: "username", string_list_data: [{href: ..., timestamp: ...}]}
    String username = '';
    String? comment;
    DateTime timestamp = DateTime.now();

    // Önce 'title' alanını kontrol et (yeni format - username burada)
    if (json.containsKey('title') && json['title'] != null) {
      username = json['title'] as String;
    }

    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;

      // Eğer username hala boşsa, value'dan al (eski format)
      if (username.isEmpty && data['value'] != null) {
        username = data['value'] as String;
      }

      if (data['timestamp'] != null) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(
          (data['timestamp'] as int) * 1000,
        );
      }
    }

    // Yorum metni ayrı bir alanda olabilir
    comment = json['comment'] as String? ?? json['text'] as String?;

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

  /// Mesaj klasöründen parse et
  factory InstagramMessage.fromFolder(
    String folderName,
    int msgCount,
    DateTime? lastDate,
  ) {
    // Klasör adından kullanıcı adını çıkar: "username_1234567890" -> "username"
    String username = folderName;
    final underscoreIndex = folderName.lastIndexOf('_');
    if (underscoreIndex > 0) {
      username = folderName.substring(0, underscoreIndex);
    }

    return InstagramMessage(
      participant: username,
      messageCount: msgCount,
      lastMessageDate: lastDate,
    );
  }
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
    // Yeni Instagram formatı: {title: "username", string_list_data: [{href: ..., timestamp: ...}]}
    String username = '';
    String? href;
    DateTime? savedDate;

    // Önce 'title' alanını kontrol et (yeni format)
    if (json.containsKey('title') && json['title'] != null) {
      username = json['title'] as String;
    }

    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;

      // Eğer username hala boşsa, value'dan al (eski format)
      if (username.isEmpty && data['value'] != null) {
        username = data['value'] as String;
      }

      href = data['href'] as String?;

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
  final String? username; // Kullanıcı adı
  final List<InstagramUser> followers;
  final List<InstagramUser> following;
  final List<InstagramLike> likes;
  final List<InstagramComment> comments;
  final List<InstagramSavedItem> savedItems;
  final List<InstagramInterest> interests;
  final List<InstagramMessage> messages;
  final DateTime? dataExportDate;
  final DateTime loadedAt;

  InstagramData({
    this.username,
    required this.followers,
    required this.following,
    required this.likes,
    required this.comments,
    required this.savedItems,
    required this.interests,
    this.messages = const [],
    this.dataExportDate,
    DateTime? loadedAt,
  }) : loadedAt = loadedAt ?? DateTime.now();

  /// Boş veri
  factory InstagramData.empty() {
    return InstagramData(
      username: null,
      followers: [],
      following: [],
      likes: [],
      comments: [],
      savedItems: [],
      interests: [],
      messages: [],
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

  /// Son 3 aylık beğeni aktivitesi (ay bazında)
  List<Map<String, dynamic>> get monthlyLikeActivity {
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];

    for (int i = 2; i >= 0; i--) {
      final targetMonth = DateTime(now.year, now.month - i, 1);
      final monthEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);

      final count = likes
          .where(
            (l) =>
                l.timestamp.isAfter(
                  targetMonth.subtract(const Duration(days: 1)),
                ) &&
                l.timestamp.isBefore(monthEnd.add(const Duration(days: 1))),
          )
          .length;

      // Ay ismi
      final monthNames = [
        'Oca',
        'Şub',
        'Mar',
        'Nis',
        'May',
        'Haz',
        'Tem',
        'Ağu',
        'Eyl',
        'Eki',
        'Kas',
        'Ara',
      ];
      final monthName = monthNames[targetMonth.month - 1];

      result.add({'label': monthName, 'value': count});
    }

    return result;
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

  /// En çok mesajlaşılan kişiler (sıralı)
  List<InstagramMessage> get topMessagedUsers {
    final sorted = List<InstagramMessage>.from(messages)
      ..sort((a, b) => b.messageCount.compareTo(a.messageCount));
    return sorted.take(10).toList();
  }

  /// Toplam mesaj sayısı
  int get totalMessageCount {
    return messages.fold(0, (sum, m) => sum + m.messageCount);
  }

  /// Toplam konuşma sayısı
  int get totalConversationCount => messages.length;
}
