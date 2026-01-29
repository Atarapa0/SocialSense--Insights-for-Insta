import 'dart:collection';

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
  Map<String, dynamic> toMap() => {
    'username': username,
    'profile_url': profileUrl,
    'follow_date': followDate?.millisecondsSinceEpoch,
  };

  factory InstagramUser.fromMap(Map<String, dynamic> map) => InstagramUser(
    username: map['username'],
    profileUrl: map['profile_url'],
    followDate: map['follow_date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['follow_date'])
        : null,
  );
}

/// Beğeni modeli
class InstagramLike {
  final String username;
  final String? mediaUrl;
  final DateTime timestamp;
  final bool isStory;

  const InstagramLike({
    required this.username,
    this.mediaUrl,
    required this.timestamp,
    this.isStory = false,
  });

  factory InstagramLike.fromJson(Map<String, dynamic> json) {
    String username = '';
    DateTime timestamp = DateTime.now();
    String? href;

    if (json.containsKey('title') && json['title'] != null) {
      username = json['title'] as String;
    }

    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;

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
      isStory:
          href?.contains('/s/') == true ||
          href?.contains('story') == true ||
          (json['title'] as String?)?.toLowerCase().contains('story') == true,
    );
  }
  Map<String, dynamic> toMap() => {
    'username': username,
    'media_url': mediaUrl,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'is_story': isStory,
  };

  factory InstagramLike.fromMap(Map<String, dynamic> map) => InstagramLike(
    username: map['username'],
    mediaUrl: map['media_url'],
    timestamp: map['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
        : DateTime.now(),
    isStory: map['is_story'] ?? false,
  );
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
    String username = '';
    String? comment;
    DateTime timestamp = DateTime.now();

    if (json.containsKey('title') && json['title'] != null) {
      username = json['title'] as String;
    }

    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;

      if (username.isEmpty && data['value'] != null) {
        username = data['value'] as String;
      }

      if (data['timestamp'] != null) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(
          (data['timestamp'] as int) * 1000,
        );
      }
    }

    comment = json['comment'] as String? ?? json['text'] as String?;

    return InstagramComment(
      username: username,
      commentText: comment,
      timestamp: timestamp,
    );
  }
  Map<String, dynamic> toMap() => {
    'username': username,
    'comment_text': commentText,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory InstagramComment.fromMap(Map<String, dynamic> map) =>
      InstagramComment(
        username: map['username'],
        commentText: map['comment_text'],
        timestamp: map['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
            : DateTime.now(),
      );
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

  factory InstagramMessage.fromFolder(
    String folderName,
    int msgCount,
    DateTime? lastDate,
  ) {
    String username = folderName;
    final underscoreIndex = folderName.lastIndexOf('_');
    if (underscoreIndex > 0) {
      final suffix = folderName.substring(underscoreIndex + 1);
      if (int.tryParse(suffix) != null) {
        username = folderName.substring(0, underscoreIndex);
      }
    }

    return InstagramMessage(
      participant: username,
      messageCount: msgCount,
      lastMessageDate: lastDate,
    );
  }
  Map<String, dynamic> toMap() => {
    'participant': participant,
    'message_count': messageCount,
    'last_message_date': lastMessageDate?.millisecondsSinceEpoch,
  };

  factory InstagramMessage.fromMap(Map<String, dynamic> map) =>
      InstagramMessage(
        participant: map['participant'],
        messageCount: map['message_count'],
        lastMessageDate: map['last_message_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['last_message_date'])
            : null,
      );
}

/// İlgi alanı modeli
class InstagramInterest {
  final String category;
  final List<String> items;

  const InstagramInterest({required this.category, required this.items});
  Map<String, dynamic> toMap() => {'category': category, 'items': items};

  factory InstagramInterest.fromMap(Map<String, dynamic> map) =>
      InstagramInterest(
        category: map['category'],
        items: List<String>.from(map['items'] ?? []),
      );
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
    String username = '';
    String? href;
    DateTime? savedDate;

    if (json.containsKey('title') && json['title'] != null) {
      username = json['title'] as String;
    }

    final stringListData = json['string_list_data'] as List?;
    if (stringListData != null && stringListData.isNotEmpty) {
      final data = stringListData[0] as Map<String, dynamic>;

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
  Map<String, dynamic> toMap() => {
    'username': username,
    'media_url': mediaUrl,
    'saved_date': savedDate?.millisecondsSinceEpoch,
  };

  factory InstagramSavedItem.fromMap(Map<String, dynamic> map) =>
      InstagramSavedItem(
        username: map['username'],
        mediaUrl: map['media_url'],
        savedDate: map['saved_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['saved_date'])
            : null,
      );
}

/// Ana Instagram veri modeli
class InstagramData {
  final String? username;
  final List<InstagramUser> followers;
  final List<InstagramUser> following;
  final List<InstagramLike> likes;
  final List<InstagramComment> comments;
  final List<InstagramSavedItem> savedItems;
  final List<InstagramInterest> interests;
  final List<InstagramMessage> messages;
  final List<String> closeFriends;
  final List<InstagramLike> storyLikes;
  final DateTime? dataExportDate;
  final DateTime loadedAt;
  final Map<String, int> topReelsSent;
  final Map<String, int> topReelsReceived;
  final Map<String, int> msgSentMap;
  final Map<String, int> msgReceivedMap;
  final List<String> pendingRequests;
  final List<String> receivedRequests;
  final String? fullName;

  InstagramData({
    this.username,
    required this.followers,
    required this.following,
    required this.likes,
    required this.comments,
    required this.savedItems,
    required this.interests,
    this.messages = const [],
    this.closeFriends = const [],
    this.storyLikes = const [],
    this.topReelsSent = const {},
    this.topReelsReceived = const {},
    this.msgSentMap = const {},
    this.msgReceivedMap = const {},
    this.pendingRequests = const [],
    this.receivedRequests = const [],
    this.fullName,
    this.dataExportDate,
    DateTime? loadedAt,
  }) : loadedAt = loadedAt ?? DateTime.now();

  InstagramData copyWith({
    String? username,
    List<InstagramUser>? followers,
    List<InstagramUser>? following,
    List<InstagramLike>? likes,
    List<InstagramComment>? comments,
    List<InstagramSavedItem>? savedItems,
    List<InstagramInterest>? interests,
    List<InstagramMessage>? messages,
    List<String>? closeFriends,
    List<InstagramLike>? storyLikes,
    Map<String, int>? topReelsSent,
    Map<String, int>? topReelsReceived,
    Map<String, int>? msgSentMap,
    Map<String, int>? msgReceivedMap,
    List<String>? pendingRequests,
    List<String>? receivedRequests,
    String? fullName,
    DateTime? dataExportDate,
    DateTime? loadedAt,
  }) {
    return InstagramData(
      username: username ?? this.username,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      savedItems: savedItems ?? this.savedItems,
      interests: interests ?? this.interests,
      messages: messages ?? this.messages,
      closeFriends: closeFriends ?? this.closeFriends,
      storyLikes: storyLikes ?? this.storyLikes,
      topReelsSent: topReelsSent ?? this.topReelsSent,
      topReelsReceived: topReelsReceived ?? this.topReelsReceived,
      msgSentMap: msgSentMap ?? this.msgSentMap,
      msgReceivedMap: msgReceivedMap ?? this.msgReceivedMap,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      receivedRequests: receivedRequests ?? this.receivedRequests,
      fullName: fullName ?? this.fullName,
      dataExportDate: dataExportDate ?? this.dataExportDate,
      loadedAt: loadedAt ?? this.loadedAt,
    );
  }

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
      closeFriends: [],
      storyLikes: [],
      topReelsSent: {},
      topReelsReceived: {},
      msgSentMap: {},
      msgReceivedMap: {},
      pendingRequests: [],
      receivedRequests: [],
      fullName: null,
    );
  }

  bool get hasData => followers.isNotEmpty || following.isNotEmpty;

  // --- Analiz Getterları ---

  List<String> get mutualFollowers {
    final followerUsernames = followers
        .map((f) => f.username.toLowerCase())
        .toSet();
    final followingUsernames = following
        .map((f) => f.username.toLowerCase())
        .toSet();
    return followerUsernames.intersection(followingUsernames).toList();
  }

  List<String> get notFollowingBack {
    final followerUsernames = followers
        .map((f) => f.username.toLowerCase())
        .toSet();
    return following
        .where((f) => !followerUsernames.contains(f.username.toLowerCase()))
        .map((f) => f.username)
        .toList();
  }

  List<String> get youDontFollow {
    final followingUsernames = following
        .map((f) => f.username.toLowerCase())
        .toSet();
    return followers
        .where((f) => !followingUsernames.contains(f.username.toLowerCase()))
        .map((f) => f.username)
        .toList();
  }

  Map<String, int> get topLikedAccounts {
    final counts = <String, int>{};
    for (final like in likes) {
      counts[like.username] = (counts[like.username] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(10));
  }

  Map<String, int> get topCommentedAccounts {
    final counts = <String, int>{};
    for (final comment in comments) {
      counts[comment.username] = (counts[comment.username] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(10));
  }

  Map<String, int> get topSavedAccounts {
    final counts = <String, int>{};
    for (final item in savedItems) {
      counts[item.username] = (counts[item.username] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(10));
  }

  List<InstagramMessage> get topMessagedUsers {
    final sorted = List<InstagramMessage>.from(messages)
      ..sort((a, b) => b.messageCount.compareTo(a.messageCount));
    return sorted.take(10).toList();
  }

  int get totalMessageCount {
    return messages.fold(0, (sum, msg) => sum + msg.messageCount);
  }

  int get totalConversationCount => messages.length;

  Map<int, int> get hourlyLikeActivity {
    final counts = <int, int>{};
    for (final like in likes) {
      final hour = like.timestamp.hour;
      counts[hour] = (counts[hour] ?? 0) + 1;
    }
    return counts;
  }

  int get mostActiveHour {
    final hourly = hourlyLikeActivity;
    if (hourly.isEmpty) return 12;
    return hourly.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Map<int, int> get weekdayActivity {
    final counts = <int, int>{};
    for (final like in likes) {
      final weekday = like.timestamp.weekday;
      counts[weekday] = (counts[weekday] ?? 0) + 1;
    }
    return counts;
  }

  List<Map<String, dynamic>> get monthlyLikeActivity {
    if (likes.isEmpty) return [];
    final activityMap = <String, int>{};
    for (final like in likes) {
      final key =
          '${like.timestamp.year}-${like.timestamp.month.toString().padLeft(2, '0')}';
      activityMap[key] = (activityMap[key] ?? 0) + 1;
    }
    final sortedKeys = activityMap.keys.toList()..sort();
    if (sortedKeys.isEmpty) return [];

    final firstKeyParts = sortedKeys.first.split('-').map(int.parse).toList();
    var currentDate = DateTime(firstKeyParts[0], firstKeyParts[1]);
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month);

    final result = <Map<String, dynamic>>[];
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

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      final key =
          '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}';
      final count = activityMap[key] ?? 0;
      final label =
          '${monthNames[currentDate.month - 1]} \'${currentDate.year.toString().substring(2)}';
      result.add({'label': label, 'value': count});
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }
    return result;
  }

  double get estimatedEngagementRate {
    if (followers.isEmpty) return 0.0;
    final recentLikes = likes
        .where(
          (l) => l.timestamp.isAfter(
            DateTime.now().subtract(const Duration(days: 30)),
          ),
        )
        .length;
    return (recentLikes / followers.length) * 100;
  }

  List<String> get ghostFollowersList {
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
    final activeSet = activeUsernames;

    // Aktif olmayanları bul
    final ghosts = followerUsernames.difference(activeSet);

    // Orijinal kullanıcı adlarını bulmak için followers listesini kullan
    return followers
        .where((f) => ghosts.contains(f.username.toLowerCase()))
        .map((f) => f.username)
        .toList();
  }

  int get estimatedGhostFollowers => ghostFollowersList.length;

  double get ghostFollowerPercentage {
    if (followers.isEmpty) return 0.0;
    return (estimatedGhostFollowers / followers.length) * 100;
  }

  Map<String, int> get topStoryLikedAccounts {
    final counts = <String, int>{};
    for (final like in storyLikes) {
      if (like.username.isNotEmpty) {
        counts[like.username] = (counts[like.username] ?? 0) + 1;
      }
    }
    final sortedKeys = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

    return Map.fromEntries(
      sortedKeys.take(20).map((k) => MapEntry(k, counts[k]!)),
    );
  }

  Map<String, double> get timeDistribution {
    int morning = 0;
    int afternoon = 0;
    int evening = 0;
    int night = 0;

    int total = likes.length + comments.length;
    if (total == 0) return {};

    void process(DateTime dt) {
      final h = dt.hour;
      if (h >= 6 && h < 12)
        morning++;
      else if (h >= 12 && h < 18)
        afternoon++;
      else if (h >= 18 && h < 24)
        evening++;
      else
        night++;
    }

    likes.forEach((l) => process(l.timestamp));
    comments.forEach((c) => process(c.timestamp));

    return {
      'morning': (morning / total) * 100,
      'afternoon': (afternoon / total) * 100,
      'evening': (evening / total) * 100,
      'night': (night / total) * 100,
    };
  }

  Map<String, double> get weekDistribution {
    int weekday = 0;
    int weekend = 0;
    int total = likes.length + comments.length;
    if (total == 0) return {};

    void process(DateTime dt) {
      final d = dt.weekday;
      if (d >= 1 && d <= 5)
        weekday++;
      else
        weekend++;
    }

    likes.forEach((l) => process(l.timestamp));
    comments.forEach((c) => process(c.timestamp));

    return {
      'weekday': (weekday / total) * 100,
      'weekend': (weekend / total) * 100,
    };
  }

  Map<String, List<String>> get categorizedInterests {
    final categories = <String, List<String>>{
      'Spor': [],
      'Yemek & İçecek': [],
      'Oyun & Teknoloji': [],
      'Moda & Güzellik': [],
      'Hayvanlar': [],
      'Sanat & Eğlence': [],
      'Seyahat': [],
      'Diğer': [],
    };

    final keywords = {
      'Spor': [
        'sport',
        'football',
        'soccer',
        'basketball',
        'tennis',
        'fitness',
        'gym',
        'athlete',
        'motor',
        'racing',
      ],
      'Yemek & İçecek': [
        'food',
        'drink',
        'cooking',
        'recipe',
        'kitchen',
        'restaurant',
        'coffee',
        'tea',
        'chocolate',
        'cake',
        'beverage',
        'meal',
        'dish',
      ],
      'Oyun & Teknoloji': [
        'game',
        'gaming',
        'video game',
        'console',
        'tech',
        'computer',
        'software',
        'app',
        'mobile',
        'internet',
        'cyber',
        'robot',
        'ai',
        'gadget',
      ],
      'Moda & Güzellik': [
        'fashion',
        'beauty',
        'makeup',
        'style',
        'clothing',
        'shoes',
        'dress',
        'accessories',
        'hair',
        'skin',
        'cosmetic',
      ],
      'Hayvanlar': [
        'animal',
        'pet',
        'dog',
        'cat',
        'bird',
        'fish',
        'wildlife',
        'nature',
        'zoo',
        'veterinary',
      ],
      'Sanat & Eğlence': [
        'art',
        'music',
        'movie',
        'film',
        'cinema',
        'tv',
        'show',
        'entertainment',
        'concert',
        'festival',
        'dance',
        'book',
        'literature',
        'design',
        'drawing',
      ],
      'Seyahat': [
        'travel',
        'trip',
        'holiday',
        'vacation',
        'tourism',
        'hotel',
        'flight',
        'airline',
        'destination',
        'beach',
        'mountain',
        'camping',
      ],
    };

    for (final interest in interests) {
      for (final item in interest.items) {
        bool categorized = false;
        final lowerItem = item.toLowerCase();

        for (final entry in keywords.entries) {
          if (entry.value.any((k) => lowerItem.contains(k))) {
            if (!categories[entry.key]!.contains(item)) {
              categories[entry.key]!.add(item);
            }
            categorized = true;
            break;
          }
        }

        if (!categorized) {
          if (!categories['Diğer']!.contains(item)) {
            categories['Diğer']!.add(item);
          }
        }
      }
    }

    return Map.fromEntries(categories.entries.where((e) => e.value.isNotEmpty));
  }

  Map<String, dynamic> toMap() => {
    'username': username,
    'followers': followers.map((e) => e.toMap()).toList(),
    'following': following.map((e) => e.toMap()).toList(),
    'likes': likes.map((e) => e.toMap()).toList(),
    'comments': comments.map((e) => e.toMap()).toList(),
    'savedItems': savedItems.map((e) => e.toMap()).toList(),
    'interests': interests.map((e) => e.toMap()).toList(),
    'messages': messages.map((e) => e.toMap()).toList(),
    'closeFriends': closeFriends,
    'storyLikes': storyLikes.map((e) => e.toMap()).toList(),
    'dataExportDate': dataExportDate?.millisecondsSinceEpoch,
    'loadedAt': loadedAt.millisecondsSinceEpoch,
    'topReelsSent': topReelsSent,
    'topReelsReceived': topReelsReceived,
    'msgSentMap': msgSentMap,
    'msgReceivedMap': msgReceivedMap,
    'pendingRequests': pendingRequests,
    'receivedRequests': receivedRequests,
    'fullName': fullName,
  };

  factory InstagramData.fromMap(Map<String, dynamic> map) => InstagramData(
    username: map['username'],
    followers: (map['followers'] as List)
        .map((e) => InstagramUser.fromMap(e))
        .toList(),
    following: (map['following'] as List)
        .map((e) => InstagramUser.fromMap(e))
        .toList(),
    likes: (map['likes'] as List).map((e) => InstagramLike.fromMap(e)).toList(),
    comments: (map['comments'] as List)
        .map((e) => InstagramComment.fromMap(e))
        .toList(),
    savedItems: (map['savedItems'] as List)
        .map((e) => InstagramSavedItem.fromMap(e))
        .toList(),
    interests: (map['interests'] as List)
        .map((e) => InstagramInterest.fromMap(e))
        .toList(),
    messages: (map['messages'] as List)
        .map((e) => InstagramMessage.fromMap(e))
        .toList(),
    closeFriends: List<String>.from(map['closeFriends'] ?? []),
    storyLikes: (map['storyLikes'] as List? ?? [])
        .map((e) => InstagramLike.fromMap(e))
        .toList(),
    dataExportDate: map['dataExportDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['dataExportDate'])
        : null,
    loadedAt: map['loadedAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['loadedAt'])
        : null,
    topReelsSent: Map<String, int>.from(map['topReelsSent'] ?? {}),
    topReelsReceived: Map<String, int>.from(map['topReelsReceived'] ?? {}),
    msgSentMap: Map<String, int>.from(map['msgSentMap'] ?? {}),
    msgReceivedMap: Map<String, int>.from(map['msgReceivedMap'] ?? {}),
    pendingRequests: List<String>.from(map['pendingRequests'] ?? []),
    receivedRequests: List<String>.from(map['receivedRequests'] ?? []),
    fullName: map['fullName'],
  );
}
