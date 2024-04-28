import 'package:apple_music_player/constants.dart';
import 'package:apple_music_player/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

class AllSongsPage extends StatefulWidget {
  final Function(MySongModel) onSongSelected;

  const AllSongsPage({super.key, required this.onSongSelected});

  @override
  _AllSongsPageState createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  late Future<List<MySongModel>> _songsFuture = Future.value([]);
  bool permissionGranted = false;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    getPermissionStatus();
  }

  void getPermissionStatus() async {
    PermissionStatus permission = await Permission.audio.request();

    if (permission.isGranted) {
      final box = await Hive.openBox<MySongModel>('songs');
      if (box.isEmpty) {
        fetchSongs();
      } else {
        setState(() {
          _songsFuture = Future.value(box.values.toList());
        });
      }
    }
  }

  void fetchSongs() async {
    final songs = await OnAudioQuery().querySongs();
    final box = await Hive.openBox<MySongModel>('songs');
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
    setState(() {
      _songsFuture = Future.value(box.values.toList());
    });
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
      body: FutureBuilder<List<SongModel>>(
        future: OnAudioQuery().querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          if (item.data!.isEmpty) {
            return Center(
              child: Text(
                'No songs found',
              ),
            );
          }
          return ListView.builder(
            itemCount: item.data?.length ?? 0,
            itemBuilder: (context, index) {
              SongModel song = item.data![index];
              // print(song);
              return ListTile(
                leading: FutureBuilder<Uint8List?>(
                  future:
                      OnAudioQuery().queryArtwork(song.id, ArtworkType.AUDIO),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.music_note),
                      );
                    } else {
                      return Container(
                        width: 50,
                        height: 50,
                        child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                      );
                    }
                  },
                ),
                title: Text(
                  song.title,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Add your functionality here
                  },
                ),
                onTap: () {
                  Uint8List? albumArt;
                  OnAudioQuery()
                      .queryArtwork(song.id, ArtworkType.AUDIO)
                      .then((value) {
                    albumArt = value;
                  });
                  widget.onSongSelected(MySongModel(
                    title: song.title,
                    artist: song.artist ?? '',
                    data: song.data,
                    albumArt: albumArt,
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, unused_field, unused_local_variable



