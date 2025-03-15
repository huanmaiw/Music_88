import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../source/favorite_provider.dart';

class FavoriteSongsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteSongs = Provider.of<FavoriteProvider>(context).favoriteSongs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài hát yêu thích'),
      ),
      body: favoriteSongs.isEmpty
          ? Center(child: Text('Chưa có bài hát yêu thích nào!'))
          : ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteSongs[index];
          return ListTile(
            title: Text(song.title),
            subtitle: Text(song.artist),
            leading: Image.network(song.image),
            onTap: () {
              // Điều hướng đến màn hình phát nhạc
            },
          );
        },
      ),
    );
  }
}
