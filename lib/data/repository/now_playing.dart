import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../../ChucNang/recently_played_service.dart';
import '../../data/model/song.dart';
import '../source/favorite_provider.dart';
import 'progress_bar.dart';
import 'song_info.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});

  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(playingSong: playingSong, songs: songs);
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key, required this.songs, required this.playingSong});

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  int _currentIndex = 0;
  late AnimationController _rotationController;
  bool isRepeatingOne = false;
  bool isRepeatingAll = false;
  bool isFavorite = false;

  Future<void> _checkIfFavorite() async {
    final provider = Provider.of<FavoriteProvider>(context, listen: false);
    setState(() {
      isFavorite = provider.isFavorite(widget.songs[_currentIndex]);
    });
  }

  // Moved _playSong outside of initState
  void _playSong() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(widget.songs[_currentIndex].source));
    setState(() {
      isPlaying = true;
    });
  }

  @override
  void initState() {
    super.initState();
    RecentlyPlayedService().addToRecentlyPlayed(widget.playingSong);
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.songs.indexOf(widget.playingSong);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (isRepeatingOne) {
        _playSong();
      } else {
        _playNext();
      }
      _checkIfFavorite(); // Kiểm tra trạng thái yêu thích khi bài hát thay đổi
    });

    _checkIfFavorite(); // Kiểm tra ngay khi khởi tạo
  }

  void _playNext() {
    if (_currentIndex < widget.songs.length - 1) {
      _currentIndex++;
    } else if (isRepeatingAll) {
      _currentIndex = 0;
    } else {
      return;
    }
    _playSong();
  }

  void _playPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _playSong();
    }
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
      _rotationController.stop();
    } else {
      await _audioPlayer.play(UrlSource(widget.songs[_currentIndex].source));
      _rotationController.repeat();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _toggleRepeatMode() {
    setState(() {
      if (!isRepeatingOne && !isRepeatingAll) {
        isRepeatingOne = true;
      } else if (isRepeatingOne) {
        isRepeatingOne = false;
        isRepeatingAll = true;
      } else {
        isRepeatingOne = false;
        isRepeatingAll = false;
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SongInfo(imageUrl: widget.songs[_currentIndex].image, rotationController: _rotationController),
          const SizedBox(height: 20),

          // Hiển thị thời gian hiện tại và tổng thời gian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  _formatDuration(_totalDuration),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          ProgressBar(
            currentPosition: _currentPosition,
            totalDuration: _totalDuration,
            onSeek: (duration) => _audioPlayer.seek(duration),
          ),

          // Hàng chứa các nút điều khiển chính
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút yêu thích
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black87,
                  ),
                  onPressed: () {
                    final provider = Provider.of<FavoriteProvider>(context, listen: false);
                    provider.toggleFavorite(widget.songs[_currentIndex]);
                    _checkIfFavorite(); // Cập nhật giao diện sau khi thay đổi
                  },
                ),

                // Nút Previous
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 36),
                  onPressed: _playPrevious,
                ),

                // Nút Play / Pause
                FloatingActionButton(
                  onPressed: _togglePlayPause,
                  backgroundColor: Colors.deepPurple[400], // Màu nền
                  shape: const CircleBorder(), // Đảm bảo nút là hình tròn
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 36,
                    color: Colors.white, // Màu icon trắng
                  ),
                ),

                // Nút Next
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 36),
                  onPressed: _playNext,
                ),

                // Nút Repeat
                IconButton(
                  icon: Icon(
                    isRepeatingOne
                        ? Icons.repeat_one
                        : (isRepeatingAll ? Icons.repeat : Icons.repeat_outlined),
                    color: isRepeatingOne
                        ? Colors.red  // Màu đỏ cho Repeat One
                        : (isRepeatingAll ? Colors.red : Colors.black), // Màu đỏ cho Repeat All
                  ),
                  onPressed: _toggleRepeatMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm format thời gian thành chuỗi "mm:ss"
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}