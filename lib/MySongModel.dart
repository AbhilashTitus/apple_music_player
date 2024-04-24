import 'dart:typed_data';

class MySongModel {
  final String title;
  final String artist;
  final String data;
  final Uint8List? albumArt;

  MySongModel(
      {required this.title,
      required this.artist,
      required this.data,
      this.albumArt});
}
