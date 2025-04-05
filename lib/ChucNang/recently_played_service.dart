import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/song.dart';

class RecentlyPlayedService {
  static const _key = 'recently_played';

  Future<void> addToRecentlyPlayed(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getStringList(_key) ?? [];

    // Chuyển song thành json
    final newSongJson = jsonEncode(song.toJson());

    // Xoá nếu đã tồn tại
    recentJson.removeWhere((item) => item == newSongJson);
    // Thêm lên đầu
    recentJson.insert(0, newSongJson);
    // Giới hạn 20 bài gần đây
    if (recentJson.length > 20) recentJson.removeLast();

    await prefs.setStringList(_key, recentJson);
  }

  Future<List<Song>> getRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getStringList(_key) ?? [];
    return recentJson.map((jsonStr) => Song.fromJson(jsonDecode(jsonStr))).toList();
  }
}
