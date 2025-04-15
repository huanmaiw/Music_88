import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;
import '../data/model/song.dart';

// Isolate function to parse JSON
Future<List<Song>> _parseSongsInIsolate(String jsonString) async {
  final dynamic data = jsonDecode(jsonString);

  List<dynamic> songList;
  if (data is List) {
    // If the JSON is a list (e.g., [{...}, {...}])
    songList = data;
  } else if (data is Map<String, dynamic> && data.containsKey('songs')) {
    // If the JSON is a map with a "songs" key (e.g., {"songs": [{...}, {...}]})
    songList = data['songs'] as List<dynamic>;
  } else {
    throw Exception('Invalid JSON format: Expected a list or a map with "songs" key');
  }

  return songList
      .cast<Map<String, dynamic>>()
      .map((json) => Song.fromJson(json))
      .toList();
}

class MusicAppViewModel {
  final _songController = StreamController<List<Song>>.broadcast();
  Stream<List<Song>> get songStream => _songController.stream;

  List<Song> _songs = [];
  List<Song> get songs => _songs;

  Future<void> loadSongs() async {
    try {
      // Load JSON string on the main thread (this is lightweight)
      final String response = await rootBundle.loadString('assets/songs.json');

      // Offload parsing to an isolate
      _songs = await compute(_parseSongsInIsolate, response);

      // Add songs to stream
      _songController.add(_songs);
    } catch (e) {
      print('Error loading songs: $e');
      _songController.addError('Failed to load songs: $e');
    }
  }

  void dispose() {
    _songController.close();
  }
}