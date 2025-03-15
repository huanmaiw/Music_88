import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/song.dart';

class FavoriteProvider with ChangeNotifier {
  List<Song> _favoriteSongs = [];

  List<Song> get favoriteSongs => _favoriteSongs;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorite_songs') ?? [];

    _favoriteSongs = favoriteList
        .map((songJson) => Song.fromJson(jsonDecode(songJson)))
        .toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    final songJson = jsonEncode(song.toJson());

    if (_favoriteSongs.contains(song)) {
      _favoriteSongs.remove(song);
    } else {
      _favoriteSongs.add(song);
    }

    await prefs.setStringList(
      'favorite_songs',
      _favoriteSongs.map((song) => jsonEncode(song.toJson())).toList(),
    );
    notifyListeners();
  }
}
