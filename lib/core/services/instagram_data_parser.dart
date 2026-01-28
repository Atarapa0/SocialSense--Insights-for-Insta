import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import '../models/instagram_data.dart';

/// Instagram ZIP dosyasını parse eden servis
class InstagramDataParser {
  /// ZIP dosyasını parse et
  static Future<InstagramData> parseZipFile(File zipFile) async {
    try {
      final bytes = await zipFile.readAsBytes();
      return await compute(parseZipBytesSync, bytes);
    } catch (e) {
      debugPrint('ZIP parse hatası: $e');
      rethrow;
    }
  }

  /// Bytes'tan parse et (web için)
  static Future<InstagramData> parseZipBytes(Uint8List bytes) async {
    try {
      return await compute(parseZipBytesSync, bytes);
    } catch (e) {
      debugPrint('ZIP parse hatası: $e');
      rethrow;
    }
  }

  /// ZIP bytes'larını parse et (isolate'de çalışır - sync)
  static InstagramData parseZipBytesSync(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);

    // Debug: Tüm dosyaları listele
    debugPrint('📁 ZIP içindeki dosyalar:');
    for (final file in archive) {
      if (file.isFile) {
        debugPrint('  - ${file.name}');
      }
    }

    // HTML format kontrolü - JSON yerine HTML varsa uyar
    bool hasHtmlFiles = false;
    bool hasJsonFiles = false;
    bool hasInstagramData = false;

    for (final file in archive) {
      if (!file.isFile) continue;
      final fileName = file.name.toLowerCase();

      // Mac meta dosyalarını atla
      if (fileName.contains('__macosx') || fileName.contains('/._')) continue;

      if (fileName.endsWith('.html')) {
        hasHtmlFiles = true;
      }
      if (fileName.endsWith('.json')) {
        hasJsonFiles = true;
      }
      // Instagram verisi olup olmadığını kontrol et
      if (fileName.contains('followers') ||
          fileName.contains('following') ||
          fileName.contains('personal_information') ||
          fileName.contains('likes') ||
          fileName.contains('messages')) {
        hasInstagramData = true;
      }
    }

    if (hasHtmlFiles && !hasJsonFiles) {
      throw FormatException(
        'HTML_FORMAT_ERROR: Instagram verileriniz HTML formatında indirilmiş. '
        'Lütfen Instagram ayarlarından verileri JSON formatında indirin.',
      );
    }

    if (!hasInstagramData) {
      throw FormatException(
        'INVALID_ZIP_ERROR: Bu ZIP dosyası Instagram verisi içermiyor. '
        'Lütfen Instagram\'dan indirdiğiniz doğru dosyayı seçin.',
      );
    }

    List<InstagramUser> followers = [];
    List<InstagramUser> following = [];
    List<InstagramLike> likes = [];
    List<InstagramComment> comments = [];
    List<InstagramSavedItem> savedItems = [];
    List<InstagramInterest> interests = [];
    List<String> closeFriends = [];
    List<InstagramLike> storyLikes = [];
    String? username;
    String? fullName;
    Map<String, int> topReelsSent = {};
    Map<String, int> topReelsReceived = {};
    Map<String, int> msgSentMap = {};
    Map<String, int> msgReceivedMap = {};
    List<String> pendingRequests = [];
    List<String> receivedRequests = []; // Add

    // Mesajlar için: klasör adı -> mesaj sayısı
    final Map<String, int> messageCountByFolder = {};

    for (final file in archive) {
      if (!file.isFile) continue;

      final fileName = file.name.toLowerCase();

      // Mac meta dosyalarını atla
      if (fileName.contains('__macosx') ||
          fileName.contains('/._') ||
          fileName.startsWith('._') ||
          fileName.contains('.ds_store')) {
        continue;
      }

      // Sadece dosya adını al (yolu değil)
      final baseName = fileName.split('/').last.toLowerCase();

      try {
        // Takipçiler (followers_1.json, followers.json gibi)
        if (baseName.startsWith('followers') && baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          final parsed = _parseFollowers(content);
          if (parsed.isNotEmpty) {
            followers.addAll(parsed);
            debugPrint('✅ Followers bulundu: ${parsed.length} kişi');
          }
        }
        // Takip edilenler (following.json)
        else if (baseName.startsWith('following') &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          final parsed = _parseFollowing(content);
          if (parsed.isNotEmpty) {
            following.addAll(parsed);
            debugPrint('✅ Following bulundu: ${parsed.length} kişi');
          }
        }
        // Beğeniler
        else if (baseName.contains('liked_posts') &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          likes = _parseLikes(content);
          likes = _parseLikes(content);
          debugPrint('✅ Likes bulundu: ${likes.length} beğeni');
        }
        // Bekleyen Takipler
        else if (baseName.contains('pending_follow_requests') &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          pendingRequests = _parsePendingRequests(content);
          debugPrint(
            '✅ Pending Requests bulundu: ${pendingRequests.length} kişi',
          );
        }
        // Gelen Takip İstekleri
        else if ((baseName.contains('follow_requests_received') ||
                baseName.contains('recent_follow_requests')) &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          receivedRequests = _parseReceivedRequests(content);
          debugPrint(
            '✅ Received Requests bulundu: ${receivedRequests.length} kişi',
          );
        }
        // Yorumlar
        else if (baseName.contains('post_comments') &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          comments = _parseComments(content);
        }
        // Kaydedilenler
        else if (baseName.contains('saved_posts') &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          savedItems = _parseSavedItems(content);
        }
        // İlgi alanları
        else if ((baseName.contains('your_topics') ||
                baseName.contains('recommended_topics')) &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          interests = _parseInterests(content);
        }
        // Hikaye Beğenileri
        else if ((baseName.contains('story_likes') ||
                (baseName.contains('likes') && baseName.contains('story'))) &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          storyLikes = _parseStoryLikes(content);
          debugPrint('✅ Story Likes bulundu: ${storyLikes.length} beğeni');
        }
        // Yakın Arkadaşlar
        else if (baseName.contains('close_friends') &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          closeFriends = _parseCloseFriends(content);
          debugPrint('✅ Close Friends bulundu: ${closeFriends.length} kişi');
        }
        // Profil bilgisi (daha genel arama)
        else if (username == null &&
            (baseName.contains('personal') ||
                baseName.contains('profile') ||
                baseName.contains('account')) &&
            baseName.endsWith('.json')) {
          try {
            final content = utf8.decode(file.content as List<int>);
            // Dosya çok büyükse parse etme (performans için)
            if (content.length < 100000) {
              final profileData = json.decode(content);

              if (profileData is Map) {
                // 1. Yeni format: profile_user -> [0] -> string_map_data -> Username -> value
                if (profileData.containsKey('profile_user')) {
                  final profile = profileData['profile_user'] as List?;
                  if (profile != null && profile.isNotEmpty) {
                    final userData = profile[0] as Map<String, dynamic>?;
                    if (userData != null) {
                      final stringList =
                          userData['string_map_data'] as Map<String, dynamic>?;
                      if (stringList != null) {
                        debugPrint(
                          'String Map Keys: ${stringList.keys.toList()}',
                        );
                        // Username veya Kullanıcı adı ara (Case insensitive)
                        for (final key in stringList.keys) {
                          final lowerKey = key.toLowerCase();
                          if (lowerKey.contains('username') ||
                              lowerKey.contains('kullanıcı adı') ||
                              lowerKey.contains('kullanici adi')) {
                            debugPrint('Username key found: $key');

                            final valObj = stringList[key];
                            if (valObj is Map && valObj.containsKey('value')) {
                              username = valObj['value'] as String?;
                              debugPrint('Username found: $username');
                              if (username != null) break;
                            }
                          }
                        }
                      }
                    }
                  }
                }

                // 2. Basit format: username
                if (username == null && profileData.containsKey('username')) {
                  username = profileData['username'] as String?;
                }

                // 3. Account Information: profile_username
                if (username == null &&
                    profileData.containsKey('profile_username')) {
                  final uList = profileData['profile_username'] as List?;
                  if (uList != null && uList.isNotEmpty) {
                    final uData = uList[0] as Map<String, dynamic>?;
                    if (uData != null) {
                      username = uData['username'] as String?;
                    }
                  }
                }

                // 4. Genel tarama (Fallback)
                if (username == null) {
                  for (final key in profileData.keys) {
                    final k = key.toString().toLowerCase();
                    if ((k == 'username' || k.contains('user_name')) &&
                        profileData[key] is String) {
                      username = profileData[key] as String;
                      break;
                    }
                  }
                }
              }

              if (username != null) {
                debugPrint('✅ Username bulundu ($fileName): $username');
              }

              // Full Name (Display Name) bulma
              // Genelde string_map_data -> Name -> value
              if (fullName == null && profileData.containsKey('profile_user')) {
                try {
                  final profile = profileData['profile_user'] as List?;
                  if (profile != null && profile.isNotEmpty) {
                    final stringList =
                        profile[0]['string_map_data'] as Map<String, dynamic>?;
                    if (stringList != null && stringList.containsKey('Name')) {
                      fullName = stringList['Name']['value'] as String?;
                    }
                  }
                } catch (_) {}
              }
            }
          } catch (e) {
            // Sessizce geç
          }
        }

        // Mesajlar - inbox klasöründeki message_X.json dosyalarını say
        if (fileName.contains('/inbox/') &&
            baseName.startsWith('message_') &&
            baseName.endsWith('.json')) {
          // Klasör adını al: your_instagram_activity/messages/inbox/username_123456/message_1.json
          final parts = fileName.split('/');
          if (parts.length >= 2) {
            final folderName = parts[parts.length - 2]; // username_123456

            // Folder adından username çıkarma (genelde username_ID formatındadır)
            String otherUserUsername = folderName;
            final underscoreIndex = folderName.lastIndexOf('_');
            if (underscoreIndex > 0) {
              // Son parçanın sayı olup olmadığına bak
              final suffix = folderName.substring(underscoreIndex + 1);
              if (int.tryParse(suffix) != null) {
                otherUserUsername = folderName.substring(0, underscoreIndex);
              }
            }

            // Mesaj dosyasını parse et ve mesaj sayısını al
            try {
              final content = utf8.decode(file.content as List<int>);
              final msgData = json.decode(content);
              int msgCount = 0;

              if (msgData is Map && msgData.containsKey('messages')) {
                final msgs = msgData['messages'] as List;
                msgCount = msgs.length;

                // Title genelde karşı tarafın Display Name'idir
                final title = utf8.decode(
                  (msgData['title'] as String? ?? 'Unknown').codeUnits,
                );

                for (final m in msgs) {
                  if (m is! Map) continue;

                  var sender = m['sender_name'] as String? ?? 'Unknown';
                  try {
                    sender = utf8.decode(sender.codeUnits);
                  } catch (_) {}

                  // Mesaj Sayımı
                  // Eğer gönderen başlık (title) ile aynıysa -> Karşı taraftan gelmiştir
                  // Değilse -> Biz göndermişizdir
                  if (sender == title) {
                    msgReceivedMap[otherUserUsername] =
                        (msgReceivedMap[otherUserUsername] ?? 0) + 1;
                  } else {
                    msgSentMap[otherUserUsername] =
                        (msgSentMap[otherUserUsername] ?? 0) + 1;
                  }

                  // Reel Analizi
                  if (m['share'] != null && m['share']['link'] != null) {
                    final link = m['share']['link'].toString();
                    if (link.contains('/reel/')) {
                      if (sender == title) {
                        topReelsReceived[otherUserUsername] =
                            (topReelsReceived[otherUserUsername] ?? 0) + 1;
                      } else {
                        topReelsSent[otherUserUsername] =
                            (topReelsSent[otherUserUsername] ?? 0) + 1;
                      }
                    }
                  }
                }
              }

              // MessageCountByFolder da artık username bazlı tutabiliriz ama folder unique id gibi kalsa daha güvenli.
              // Ancak kullanıcı listelemede folder name kullanıldığı için burada da pure username eklense iyi olur.
              // Şimdilik folderName olarak bırakıyoruz, aşağıda düzelteceğiz.
              messageCountByFolder[folderName] =
                  (messageCountByFolder[folderName] ?? 0) + msgCount;
            } catch (_) {
              // Hata durumunda sadece dosya sayısını ekle
              messageCountByFolder[folderName] =
                  (messageCountByFolder[folderName] ?? 0) + 1;
            }
          }
        }
      } catch (e) {
        debugPrint('Dosya parse hatası ($fileName): $e');
      }
    }

    // Mesaj listesi oluştur
    final List<InstagramMessage> messages =
        messageCountByFolder.entries
            .map((e) => InstagramMessage.fromFolder(e.key, e.value, null))
            .toList()
          ..sort((a, b) => b.messageCount.compareTo(a.messageCount));

    debugPrint(
      '✅ Messages bulundu: ${messages.length} konuşma, toplam ${messages.fold(0, (sum, m) => sum + m.messageCount)} mesaj',
    );

    return InstagramData(
      username: username,
      followers: followers,
      following: following,
      likes: likes,
      comments: comments,
      savedItems: savedItems,
      interests: interests,
      messages: messages,
      closeFriends: closeFriends,
      storyLikes: storyLikes,
      topReelsSent: topReelsSent,
      topReelsReceived: topReelsReceived,
      msgSentMap: msgSentMap,
      msgReceivedMap: msgReceivedMap,
      pendingRequests: pendingRequests,
      receivedRequests: receivedRequests,
      fullName: fullName,
      dataExportDate: DateTime.now(),
    );
  }

  /// Takipçileri parse et
  static List<InstagramUser> _parseFollowers(String jsonContent) {
    try {
      final data = json.decode(jsonContent);

      // Instagram formatı: Liste veya {"relationships_followers": [...]}
      List<dynamic> followerList = [];

      if (data is List) {
        followerList = data;
      } else if (data is Map) {
        // Önce bilinen key'leri dene
        if (data.containsKey('relationships_followers')) {
          followerList = data['relationships_followers'] as List? ?? [];
        } else {
          // Follower içeren ilk key'i bul
          for (final key in data.keys) {
            if (key.toString().toLowerCase().contains('follower') &&
                data[key] is List) {
              followerList = data[key] as List;
              break;
            }
          }
        }
      }

      if (followerList.isEmpty) return [];

      return followerList
          .whereType<Map<String, dynamic>>()
          .map((item) => InstagramUser.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('Followers parse hatası: $e');
      return [];
    }
  }

  /// Takip edilenleri parse et
  static List<InstagramUser> _parseFollowing(String jsonContent) {
    try {
      final data = json.decode(jsonContent);

      List<dynamic> followingList = [];

      if (data is List) {
        followingList = data;
      } else if (data is Map) {
        if (data.containsKey('relationships_following')) {
          followingList = data['relationships_following'] as List? ?? [];
        } else {
          for (final key in data.keys) {
            if (key.toString().toLowerCase().contains('following') &&
                data[key] is List) {
              followingList = data[key] as List;
              break;
            }
          }
        }
      }

      if (followingList.isEmpty) return [];

      // Debug: İlk öğenin formatını göster
      if (followingList.isNotEmpty) {
        debugPrint('📋 Following ilk öğe formatı: ${followingList[0]}');
      }

      return followingList
          .whereType<Map<String, dynamic>>()
          .map((item) => InstagramUser.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('Following parse hatası: $e');
      return [];
    }
  }

  /// Beğenileri parse et
  static List<InstagramLike> _parseLikes(String jsonContent) {
    try {
      final data = json.decode(jsonContent);

      List<dynamic> likesList = [];

      if (data is List) {
        likesList = data;
      } else if (data is Map) {
        if (data.containsKey('likes_media_likes')) {
          likesList = data['likes_media_likes'] as List? ?? [];
        } else {
          for (final key in data.keys) {
            if (key.toString().toLowerCase().contains('like') &&
                data[key] is List) {
              likesList = data[key] as List;
              break;
            }
          }
        }
      }

      if (likesList.isEmpty) return [];

      // Debug: İlk beğeninin formatını göster
      if (likesList.isNotEmpty) {
        debugPrint('📋 Likes ilk öğe formatı: ${likesList[0]}');
      }

      final result = likesList
          .whereType<Map<String, dynamic>>()
          .map((item) => InstagramLike.fromJson(item))
          .toList();

      // Debug: İlk birkaç username'i göster
      if (result.isNotEmpty) {
        final firstUsernames = result.take(5).map((l) => l.username).toList();
        debugPrint('📊 İlk 5 beğenilen hesap: $firstUsernames');
      }

      return result;
    } catch (e) {
      debugPrint('Likes parse hatası: $e');
      return [];
    }
  }

  /// Yorumları parse et
  static List<InstagramComment> _parseComments(String jsonContent) {
    try {
      final data = json.decode(jsonContent);

      List<dynamic> commentsList = [];

      if (data is List) {
        commentsList = data;
      } else if (data is Map) {
        if (data.containsKey('comments_media_comments')) {
          commentsList = data['comments_media_comments'] as List? ?? [];
        } else {
          for (final key in data.keys) {
            if (key.toString().toLowerCase().contains('comment') &&
                data[key] is List) {
              commentsList = data[key] as List;
              break;
            }
          }
        }
      }

      if (commentsList.isEmpty) return [];

      return commentsList
          .whereType<Map<String, dynamic>>()
          .map((item) => InstagramComment.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('Comments parse hatası: $e');
      return [];
    }
  }

  /// Kaydedilenleri parse et
  static List<InstagramSavedItem> _parseSavedItems(String jsonContent) {
    try {
      final data = json.decode(jsonContent);

      List<dynamic> savedList = [];

      if (data is List) {
        savedList = data;
      } else if (data is Map) {
        if (data.containsKey('saved_saved_media')) {
          savedList = data['saved_saved_media'] as List? ?? [];
        } else {
          for (final key in data.keys) {
            if (key.toString().toLowerCase().contains('saved') &&
                data[key] is List) {
              savedList = data[key] as List;
              break;
            }
          }
        }
      }

      if (savedList.isEmpty) return [];

      return savedList
          .whereType<Map<String, dynamic>>()
          .map((item) => InstagramSavedItem.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('Saved items parse hatası: $e');
      return [];
    }
  }

  /// İlgi alanlarını parse et
  static List<InstagramInterest> _parseInterests(String jsonContent) {
    try {
      final data = json.decode(jsonContent);

      List<String> topicsList = [];

      if (data is Map) {
        // topics_your_topics
        for (final key in data.keys) {
          if (key.toString().contains('topics') ||
              key.toString().contains('interests')) {
            final list = data[key] as List?;
            if (list != null) {
              for (final item in list) {
                // 1. String List Data
                final stringListData = item['string_list_data'] as List?;
                if (stringListData != null && stringListData.isNotEmpty) {
                  final val = stringListData[0]['value'];
                  if (val != null) topicsList.add(val.toString());
                }
                // 2. String Map Data
                final stringMapData =
                    item['string_map_data'] as Map<String, dynamic>?;
                if (stringMapData != null) {
                  for (final k in stringMapData.keys) {
                    final valData = stringMapData[k];
                    if (valData is Map && valData.containsKey('value')) {
                      topicsList.add(valData['value'].toString());
                    }
                  }
                }
              }
            }
          }
        }
      } else if (data is List) {
        // Liste ise direkt string olabilir veya obje
        // ...
      }

      if (topicsList.isNotEmpty) {
        return [
          InstagramInterest(category: 'All Interests', items: topicsList),
        ];
      }

      return [];
    } catch (e) {
      debugPrint('Interests parse hatası: $e');
      return [];
    }
  }

  /// Close Friends parse et
  static List<String> _parseCloseFriends(String jsonContent) {
    try {
      final data = json.decode(jsonContent);
      List<String> friends = [];

      if (data is Map) {
        if (data.containsKey('relationships_close_friends')) {
          final list = data['relationships_close_friends'] as List? ?? [];
          for (final item in list) {
            final stringListData = item['string_list_data'] as List?;
            if (stringListData != null && stringListData.isNotEmpty) {
              final val = stringListData[0]['value'];
              if (val != null) friends.add(val.toString());
            }
          }
        }
      }
      return friends;
    } catch (e) {
      debugPrint('Close Friends parse hatası: $e');
      return [];
    }
  }

  /// Story Likes parse et
  static List<InstagramLike> _parseStoryLikes(String jsonContent) {
    try {
      final data = json.decode(jsonContent);
      List<dynamic> likesList = [];

      if (data is Map) {
        // story_activities_story_likes
        for (final key in data.keys) {
          if (key.contains('story_likes') && data[key] is List) {
            likesList = data[key] as List;
          }
        }
      }

      if (likesList.isEmpty) return [];

      return likesList
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => InstagramLike.fromJson(item),
          ) // isStory check zaten var
          .toList();
    } catch (e) {
      debugPrint('Story Likes parse hatası: $e');
      return [];
    }
  }

  /// Bekleyen Takip İstekleri parse et
  static List<String> _parsePendingRequests(String jsonContent) {
    try {
      final data = json.decode(jsonContent);
      List<String> requests = [];
      if (data is Map &&
          data.containsKey('relationships_follow_requests_sent')) {
        final list = data['relationships_follow_requests_sent'] as List? ?? [];
        for (final item in list) {
          final stringList = item['string_list_data'] as List?;
          if (stringList != null && stringList.isNotEmpty) {
            requests.add(stringList[0]['value'].toString());
          }
        }
      }
      return requests;
    } catch (_) {
      return [];
    }
  }

  /// Gelen Takip İstekleri parse et
  static List<String> _parseReceivedRequests(String jsonContent) {
    try {
      final data = json.decode(jsonContent);
      List<String> requests = [];
      if (data is Map) {
        for (final key in data.keys) {
          if (key.toString().contains('follow_requests') && data[key] is List) {
            final list = data[key] as List;
            for (final item in list) {
              final stringList = item['string_list_data'] as List?;
              if (stringList != null && stringList.isNotEmpty) {
                requests.add(stringList[0]['value'].toString());
              }
            }
          }
        }
      }
      return requests;
    } catch (_) {
      return [];
    }
  }
}
