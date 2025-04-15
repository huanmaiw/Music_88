import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/now_playing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistName;
  final List<Song> allSongs;

  const PlaylistDetailScreen({
    super.key,
    required this.playlistName,
    required this.allSongs,
  });

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<String> songIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  @override
  void didUpdateWidget(covariant PlaylistDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playlistName != widget.playlistName) {
      _loadSongs();
    }
  }

  Future<void> _loadSongs() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('playlist_data');
      if (data != null) {
        final playlistMap = Map<String, dynamic>.from(json.decode(data));
        setState(() {
          songIds = List<String>.from(playlistMap[widget.playlistName] ?? []);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi tải danh sách phát!')),
      );
    }
  }

  Future<void> _removeSongFromPlaylist(String songId) async {
    final song = widget.allSongs.firstWhere(
          (s) => s.id == songId,
      orElse: () => Song(
        id: songId,
        title: "",
        album: '',
        artist: '',
        source: '',
        image: '',
        duration: const Duration(seconds: 0),
      ),
    );
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa bài hát'),
        content: Text('Bạn có chắc muốn xóa "${song.title}" khỏi danh sách?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('playlist_data');
    Map<String, dynamic> playlistMap = {};

    if (data != null) {
      playlistMap = Map<String, dynamic>.from(json.decode(data));
    }

    final currentSongs = List<String>.from(playlistMap[widget.playlistName] ?? []);
    currentSongs.remove(songId);
    playlistMap[widget.playlistName] = currentSongs;
    await prefs.setString('playlist_data', json.encode(playlistMap));

    setState(() {
      songIds = currentSongs;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa bài hát khỏi danh sách!')),
    );
  }

  void _playSong(String songId) {
    try {
      final song = widget.allSongs.firstWhere((s) => s.id == songId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NowPlaying(
            songs: widget.allSongs,
            playingSong: song,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy bài hát với ID "$songId"!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const Divider(),
          Expanded(
            child: songIds.isEmpty
                ? const Center(child: Text('Chưa có bài hát nào.'))
                : ListView.builder(
              itemCount: songIds.length,
              itemBuilder: (context, index) {
                final songId = songIds[index];
                final song = widget.allSongs.firstWhere(
                      (s) => s.id == songId,
                  orElse: () => Song(
                    id: songId,
                    title: 'Unknown',
                    album: '',
                    artist: '',
                    source: '',
                    image: '',
                    duration: const Duration(seconds: 0),
                  ),
                );
                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeSongFromPlaylist(songId),
                  ),
                  onTap: () => _playSong(songId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}