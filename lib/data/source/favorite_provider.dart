import 'package:flutter/material.dart';
import '../../data/model/song.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Song> _favoriteSongs = [];

  List<Song> get favoriteSongs => _favoriteSongs;

  void toggleFavorite(Song song) {
    if (_favoriteSongs.contains(song)) {
      _favoriteSongs.remove(song);
    } else {
      _favoriteSongs.add(song);
    }
    notifyListeners(); // Thông báo khi danh sách thay đổi
  }

  bool isFavorite(Song song) {
    return _favoriteSongs.contains(song);
  }
}