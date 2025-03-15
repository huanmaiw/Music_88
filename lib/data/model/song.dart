class Song {
  Song({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.source,
    required this.image,
    required this.duration,
  });

  // Factory constructor để tạo đối tượng từ Map
  factory Song.fromJson(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      album: map['album'],
      artist: map['artist'],
      source: map['source'],
      image: map['image'],
      // Chuyển duration từ số giây sang Duration
      duration: Duration(seconds: map['duration']),
    );
  }

  String id;
  String title;
  String album;
  String artist;
  String source;
  String image;
  Duration duration;  // Sử dụng Duration thay vì int

  @override
  String toString() {
    return 'Song{id: $id, title: $title, album: $album, artist: $artist, source: $source, image: $image, duration: $duration}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Chuyển đối tượng Song thành Map (Json)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'album': album,
      'artist': artist,
      'source': source,
      'image': image,
      // Lưu duration dưới dạng số giây
      'duration': duration.inSeconds,
    };
  }
}
