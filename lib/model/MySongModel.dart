// ignore_for_file: file_names

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

  @HiveField(4)
  DateTime? lastPlayed;

  @HiveField(5)
  final String? filePath;

  @HiveField(6)
  String? recordTitle; 

  @HiveField(7)
  String? duration;

  @HiveField(8)
  DateTime? dateRecorded;

  MySongModel({
    required this.title,
    required this.artist,
    required this.data,
    this.albumArt,
    required this.lastPlayed,
    this.filePath,
    this.recordTitle, 
    this.duration,
    this.dateRecorded,
  });
}