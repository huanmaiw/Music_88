import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:music_app/ChucNang/playlist_detail_screen.dart';
import 'package:music_app/ChucNang/viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/song.dart';

class MyListPlay extends StatefulWidget {
  const MyListPlay({super.key});

  @override
  State<MyListPlay> createState() => _MyListPlayState();
}

class _MyListPlayState extends State<MyListPlay> {
  final TextEditingController _playlistNameController = TextEditingController();
  Map<String, List<String>> _playlistMap = {};
  bool _isLoading = true;
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    try {
      await _viewModel.loadSongs(); // Await to ensure songs are loaded
      await _loadPlaylists();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi tải dữ liệu!')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('playlist_data');
    if (data != null) {
      final rawMap = json.decode(data) as Map;
      _playlistMap = Map<String, List<String>>.from(
        rawMap.map((key, value) {
          final ids = List<String>.from(value).map((item) {
            // Migrate titles to IDs
            final song = _viewModel.songs.firstWhere(
                  (s) => s.title == item || s.id == item,
              orElse: () => Song(
                id: item,
                title: item,
                album: '',
                artist: '',
                source: '',
                image: '',
                duration: const Duration(seconds: 0),
              ),
            );
            return song.id;
          }).toList();
          return MapEntry(key, ids);
        }),
      );
    }
    if (!_playlistMap.containsKey('Favorites')) {
      _playlistMap['Favorites'] = [];
      await _savePlaylists();
    }
  }

  Future<void> _savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playlist_data', json.encode(_playlistMap));
  }

  void _navigateToDetail(String playlistName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailScreen(
          playlistName: playlistName,
          allSongs: _viewModel.songs,
        ),
      ),
    );
  }

  void _showAddPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tạo danh sách phát'),
          content: TextField(
            controller: _playlistNameController,
            decoration: const InputDecoration(
              hintText: 'Tên danh sách...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _playlistNameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Tên danh sách không được để trống!')),
                  );
                  return;
                }
                if (_playlistMap.containsKey(name)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Danh sách đã tồn tại!')),
                  );
                  return;
                }
                setState(() {
                  _playlistMap[name] = [];
                });
                _savePlaylists();
                _playlistNameController.clear();
                Navigator.pop(context);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void _deletePlaylist(String playlistName) {
    if (playlistName == 'Favorites') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa danh sách Yêu thích!')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa danh sách phát?'),
          content: const Text('Bạn chắc chắn muốn xóa danh sách phát này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _playlistMap.remove(playlistName);
                });
                _savePlaylists();
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _playlistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlists = _playlistMap.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎶 Danh sách phát'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddPlaylistDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : playlists.isEmpty
          ? const Center(child: Text('🎵 Chưa có danh sách phát nào.'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final name = playlists[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(
                name == 'Favorites'
                    ? Icons.favorite
                    : Icons.music_note,
                color: Colors.deepPurple,
              ),
              title: Text(name),
              subtitle:
              Text('${_playlistMap[name]!.length} bài hát'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePlaylist(name),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => _navigateToDetail(name),
            ),
          );
        },
      ),
    );
  }
}