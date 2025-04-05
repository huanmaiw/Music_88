import 'package:flutter/material.dart';
import 'package:music_app/ChucNang/recently_played_service.dart';

import '../data/model/song.dart';
import '../data/repository/now_playing.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  @override
  _RecentlyPlayedScreenState createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  List<Song> _recentSongs = [];

  @override
  void initState() {
    super.initState();
    _loadRecentlyPlayed();
  }

  void _loadRecentlyPlayed() async {
    final songs = await RecentlyPlayedService().getRecentlyPlayed();
    setState(() {
      _recentSongs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bài hát nghe gần đây")),
      body: _recentSongs.isEmpty
          ? Center(child: Text("Chưa có bài hát nào."))
          : ListView.builder(
        itemCount: _recentSongs.length,
        itemBuilder: (context, index) {
          final song = _recentSongs[index];
          return ListTile(
            leading: Image.network(song.image, width: 50, height: 50),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NowPlaying(songs: _recentSongs, playingSong: song)),
              );
            },
          );
        },
      ),
    );
  }
}
