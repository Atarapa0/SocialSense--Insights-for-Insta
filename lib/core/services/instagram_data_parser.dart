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

    List<InstagramUser> followers = [];
    List<InstagramUser> following = [];
    List<InstagramLike> likes = [];
    List<InstagramComment> comments = [];
    List<InstagramSavedItem> savedItems = [];
    List<InstagramInterest> interests = [];

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
          debugPrint('✅ Likes bulundu: ${likes.length} beğeni');
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
        else if (baseName.contains('your_topics') &&
            baseName.endsWith('.json')) {
          final content = utf8.decode(file.content as List<int>);
          interests = _parseInterests(content);
        }
      } catch (e) {
        debugPrint('Dosya parse hatası ($fileName): $e');
      }
    }

    return InstagramData(
      followers: followers,
      following: following,
      likes: likes,
      comments: comments,
      savedItems: savedItems,
      interests: interests,
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

      return likesList
          .whereType<Map<String, dynamic>>()
          .map((item) => InstagramLike.fromJson(item))
          .toList();
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

      if (data is Map && data.containsKey('topics_your_topics')) {
        final topics = data['topics_your_topics'] as List;
        return topics.map((item) {
          final stringListData = item['string_list_data'] as List?;
          if (stringListData != null && stringListData.isNotEmpty) {
            return InstagramInterest(
              category: stringListData[0]['value'] ?? 'Unknown',
              items: [],
            );
          }
          return const InstagramInterest(category: 'Unknown', items: []);
        }).toList();
      }

      return [];
    } catch (e) {
      debugPrint('Interests parse hatası: $e');
      return [];
    }
  }
}
