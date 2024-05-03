import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:apple_music_player/model/MySongModel.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistName;

  const PlaylistPage({super.key, required this.playlistName});

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<MySongModel> songs = [];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
      List<String> songIds = playlistsBox.get(widget.playlistName)?.cast<String>() ?? [];
      Box<MySongModel> songsBox = Hive.box<MySongModel>('songs');
      songs = songIds.map((id) => songsBox.get(int.parse(id))).whereType<MySongModel>().toList();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  void _addSong() {
    showDialog(
      context: context,
      builder: (context) {
        Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
        List<String> playlist = playlistsBox.get(widget.playlistName)?.cast<String>() ?? [];
        Box<MySongModel> songsBox = Hive.box<MySongModel>('songs');
        List<int> allSongKeys = songsBox.keys.map((key) => key as int).where((key) => !playlist.contains(key.toString())).toList();

        return AlertDialog(
          title: const Text('Add Song'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: allSongKeys.length,
              itemBuilder: (context, index) {
                MySongModel song = songsBox.get(allSongKeys[index])!;
                return ListTile(
                  title: Text(song.title),
                  onTap: () {
                    playlist.add(allSongKeys[index].toString());
                    playlistsBox.put(widget.playlistName, playlist);
                    Navigator.of(context).pop();
                    loadSongs();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          MySongModel song = songs[index];
          return ListTile(
            title: Text(song.title),
            subtitle: Text(song.artist),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: _addSong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
// ignore_for_file: library_private_types_in_public_api