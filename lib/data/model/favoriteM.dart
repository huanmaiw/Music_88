import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repository/now_playing.dart';
import '../source/favorite_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu Thích'),
      ),
      body: favoriteProvider.favoriteSongs.isEmpty
          ? const Center(child: Text('Chưa có bài hát nào trong danh sách yêu thích.'))
          : ListView.builder(
        itemCount: favoriteProvider.favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteProvider.favoriteSongs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(song.image),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                favoriteProvider.toggleFavorite(song); // Xóa khỏi yêu thích
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlaying(
                    playingSong: song,
                    songs: favoriteProvider.favoriteSongs,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}