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

  factory Song.fromJson(Map<String, dynamic> map) {
    return Song(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      album: map['album']?.toString() ?? '',
      artist: map['artist']?.toString() ?? '',
      source: map['source']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      duration: Duration(seconds: map['duration'] as int? ?? 0),
    );
  }

  String id;
  String title;
  String album;
  String artist;
  String source;
  String image;
  Duration duration;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'album': album,
      'artist': artist,
      'source': source,
      'image': image,
      'duration': duration.inSeconds,
    };
  }
}