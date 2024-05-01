import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'MySongModel.g.dart';

@HiveType(typeId: 0)
class MySongModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String artist;

  @HiveField(2)
  final String data;

  @HiveField(3)
  final Uint8List? albumArt;

  MySongModel({
    required this.title,
    required this.artist,
    required this.data,
    this.albumArt,
  });

}