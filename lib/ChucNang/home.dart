import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/ChucNang/discovery.dart';
import 'package:music_app/ChucNang/viewmodel.dart';
import 'package:music_app/ChucNang/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/song.dart';
import '../data/repository/now_playing.dart';
import 'settings.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MusicApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MusicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  late final String playlistName;
  final List<Widget> _tab = [
    HomeTab(),
    DiscoveryTab(),
    AccountTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Music App'),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Discovery'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return _tab[index];
        },
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final String? newSongTitle;

  const HomeTab({super.key, this.newSongTitle});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    observeData();
    _viewModel.loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getBody() {
    if (_hasError) {
      return const Center(
        child: Text('Failed to load songs. Please try again.'),
      );
    }
    if (songs.isEmpty) {
      return getPropressBar();
    }
    return getListView();
  }

  Widget getPropressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<List<String>> loadPlaylistNames() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('playlist_data');
    if (data != null) {
      final Map<String, dynamic> playlistMap = json.decode(data);
      return playlistMap.keys.toList();
    }
    return [];
  }

  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(
      parent: this,
      song: songs[index],
    );
  }

  void observeData() {
    _viewModel.songStream.listen((songList) {
      setState(() {
        songs = songList;
        _hasError = false;
      });
    }, onError: (error) {
      setState(() {
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  void showBottomSheet(Song song) async {
    final playlists = await loadPlaylistNames();
    String? selectedPlaylist;

    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có danh sách phát nào.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.deepPurple[100],
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thêm vào danh sách phát',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Chọn danh sách',
                    ),
                    value: selectedPlaylist,
                    items: playlists.map((playlist) {
                      return DropdownMenuItem<String>(
                        value: playlist,
                        child: Text(playlist),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPlaylist = value;
                      });
                    },
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm vào danh sách'),
                    onPressed: selectedPlaylist == null
                        ? null
                        : () async {
                      Navigator.pop(context);
                      final prefs = await SharedPreferences.getInstance();
                      final data = prefs.getString('playlist_data');
                      Map<String, dynamic> playlistMap = {};

                      try {
                        if (data != null) {
                          playlistMap = Map<String, dynamic>.from(json.decode(data));
                        }

                        final currentSongs = List<String>.from(
                            playlistMap[selectedPlaylist!] ?? []);

                        if (!currentSongs.contains(song.id)) {
                          currentSongs.add(song.id);
                          playlistMap[selectedPlaylist!] = currentSongs;
                          await prefs.setString(
                              'playlist_data', json.encode(playlistMap));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Đã thêm "${song.title}" vào "$selectedPlaylist"!'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bài hát đã có trong danh sách!'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lỗi khi lưu bài hát!'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void navigate(Song song) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songs: songs,
        playingSong: song,
      );
    }));
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({
    required this.parent,
    required this.song,
  });

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: song.image.startsWith('http')
            ? FadeInImage.assetNetwork(
          placeholder: 'assets/itunes.jpg',
          image: song.image,
          width: 48,
          height: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/zing.jpg',
              width: 48,
              height: 48,
            );
          },
        )
            : Image.asset(
          song.image,
          width: 48,
          height: 48,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/zing.jpg',
              width: 48,
              height: 48,
            );
          },
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () => parent.showBottomSheet(song),
      ),
      onTap: () => parent.navigate(song),
    );
  }
}