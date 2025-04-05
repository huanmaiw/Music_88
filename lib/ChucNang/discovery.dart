import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/song.dart';
import '../data/repository/now_playing.dart';
import '../data/source/source.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  _DiscoveryTabState createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab> {
  List<Song> _recentSongs = [];

  List<Song> _songs = [];
  List<Song> _filteredSongs = [];
  bool _isLoading = true;
  bool _hasError = false;
  Future<void> _saveRecentSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = _recentSongs.map((song) => jsonEncode(song.toJson())).toList();
    await prefs.setStringList('recent_songs', recentJson);
  }
  Future<void> _loadRecentSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getStringList('recent_songs') ?? [];
    setState(() {
      _recentSongs = recentJson.map((jsonStr) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        return Song.fromJson(map);
      }).toList();
    });
  }
  @override
  void initState() {
    super.initState();
    _fetchSongs();
    _loadRecentSongs();
  }


  Future<void> _fetchSongs() async {
    try {
      final remoteSource = RemoteDataSource();
      final songs = await remoteSource.loadData();
      if (songs != null) {
        setState(() {
          _songs = songs;
          _filteredSongs = songs;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _searchSongs(String query) {
    setState(() {
      _filteredSongs = _songs
          .where((song) => song.title.toLowerCase().contains(query.toLowerCase()) ||
          song.artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Khám phá'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _searchSongs,
                  decoration: InputDecoration(
                    hintText: 'Search songs...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(child: Text('Failed to load songs'))
          : ListView.builder(
        itemCount: _filteredSongs.length,
        itemBuilder: (context, index) {
          final song = _filteredSongs[index];
          return ListTile(
            leading: Image.network(song.image, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NowPlaying(songs: _songs, playingSong: song)));
            },
          );
        },
      ),
    );
  }
}
