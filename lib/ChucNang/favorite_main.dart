import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../data/model/song.dart';
import '../data/repository/now_playing.dart';

class FavoriteSongsPage extends StatefulWidget {
  const FavoriteSongsPage({super.key});

  @override
  State<FavoriteSongsPage> createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {
  List<Song> favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteSongs();
  }

  Future<void> _loadFavoriteSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorite_songs') ?? [];

    setState(() {
      favoriteSongs = favoriteList.map((songJson) => Song.fromJson(jsonDecode(songJson))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Songs")),
      body: favoriteSongs.isEmpty
          ? const Center(child: Text("No favorite songs yet"))
          : ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteSongs[index];
          return ListTile(
            leading: Image.network(song.image, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlaying(playingSong: song, songs: favoriteSongs),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
