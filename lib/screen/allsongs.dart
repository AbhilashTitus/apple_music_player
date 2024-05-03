// ignore_for_file: library_private_types_in_public_api

import 'package:apple_music_player/screen/constants.dart';
import 'package:apple_music_player/model/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

class AllSongsPage extends StatefulWidget {
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const AllSongsPage({super.key, required this.selectedSongNotifier});

  @override
  _AllSongsPageState createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  bool permissionGranted = false;

  @override
  void initState() {
    super.initState();
    getPermissionStatus();
  }

  void getPermissionStatus() async {
    PermissionStatus permission = await Permission.audio.request();

    if (permission.isGranted) {
      final box = Hive.box<MySongModel>('songs');
      if (box.isEmpty) {
        fetchSongs();
      } else {
        setState(() {});
      }
    }
  }

  void fetchSongs() async {
    final songs = await OnAudioQuery().querySongs();
    final box = Hive.box<MySongModel>('songs');
    for (var song in songs) {
      Uint8List? albumArt =
          await OnAudioQuery().queryArtwork(song.id, ArtworkType.AUDIO);
      box.add(MySongModel(
        title: song.title,
        artist: song.artist ?? '',
        data: song.data,
        albumArt: albumArt,
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          allSongsHeading,
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Box<MySongModel>>(
        future: Hive.openBox<MySongModel>('songs'),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
          return ListView.builder(
            itemCount: item.data?.length ?? 0,
            itemBuilder: (context, index) {
              MySongModel song = item.data!.getAt(index)!;
              return ListTile(
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: song.albumArt != null
                      ? Image.memory(song.albumArt!, fit: BoxFit.cover)
                      : const Icon(Icons.music_note),
                ),
                title: Text(
                  song.title,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Add to Favorites"),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 1) {
                      Hive.box<MySongModel>('favorites').add(MySongModel(
                        title: song.title,
                        artist: song.artist,
                        data: song.data,
                        albumArt: song.albumArt,
                      ));
                      print('Added song to favorites');
                    }
                  },
                ),
                onTap: () {
                  widget.selectedSongNotifier.value = song;
                },
              );
            },
          );
        },
      ),
    );
  }
}