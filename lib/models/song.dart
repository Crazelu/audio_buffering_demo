class Song {
  final String url;
  final String filename;

  const Song({required this.url, required this.filename});

  //Credit: https://www.soundhelix.com/audio-examples
  static List<Song> songs = [
    const Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
      filename: "SoundHelix Song 1.mp3",
    ),
    const Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
      filename: "SoundHelix Song 2.mp3",
    ),
    const Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3",
      filename: "SoundHelix Song 10.mp3",
    ),
    const Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3",
      filename: "SoundHelix Song 11.mp3",
    ),
    const Song(
      url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-17.mp3",
      filename: "SoundHelix Song 17.mp3",
    ),
  ];
}
