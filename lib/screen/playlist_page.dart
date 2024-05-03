import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:apple_music_player/model/MySongModel.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistName;
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const PlaylistPage({
    Key? key,
    required this.playlistName,
    required this.selectedSongNotifier,
  }) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<MySongModel> songs = [];
  List<int> selectedSongKeys = [];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
      List<String> songIds =
          playlistsBox.get(widget.playlistName)?.cast<String>() ?? [];
      Box<MySongModel> songsBox = Hive.box<MySongModel>('songs');
      songs = songIds
          .map((id) => songsBox.get(int.parse(id)))
          .whereType<MySongModel>()
          .toList();
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
        List<String> playlist =
            playlistsBox.get(widget.playlistName)?.cast<String>() ?? [];
        Box<MySongModel> songsBox = Hive.box<MySongModel>('songs');
        List<int> allSongKeys = songsBox.keys
            .map((key) => key as int)
            .where((key) => !playlist.contains(key.toString()))
            .toList();

        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Center(child: Text('A D D  S O N G S')),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: allSongKeys.length,
                    itemBuilder: (context, index) {
                      MySongModel song = songsBox.get(allSongKeys[index])!;
                      return ListTile(
                        leading: song.albumArt != null
                            ? SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.memory(song.albumArt!, fit: BoxFit.cover))
                            : const Icon(Icons.music_note),
                        title: Text(song.title,overflow: TextOverflow.ellipsis,),
                        trailing: Checkbox(
                          value: selectedSongKeys.contains(allSongKeys[index]),
                          onChanged: (bool? value) {
                            if (value == true) {
                              selectedSongKeys.add(allSongKeys[index]);
                            } else {
                              selectedSongKeys.remove(allSongKeys[index]);
                            }
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    child:
                        const Text('Cancel', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('OK', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      playlist.addAll(
                          selectedSongKeys.map((key) => key.toString()));
                      playlistsBox.put(widget.playlistName, playlist);
                      selectedSongKeys.clear();
                      Navigator.of(context).pop();
                      loadSongs();
                    },
                  ),
                ],
              );
            },
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
      ),body: ListView.builder(
  itemCount: songs.length,
  itemBuilder: (context, index) {
    MySongModel song = songs[index];
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
            child: Text("Remove from Playlist"),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            Box<List<dynamic>> playlistsBox =
                Hive.box<List<dynamic>>('playlists');
            List<String> playlist =
                playlistsBox.get(widget.playlistName)?.cast<String>() ??
                    [];
            playlist.remove(song.key.toString());
            playlistsBox.put(widget.playlistName, playlist);
            loadSongs();
          }
        },
      ),
      onTap: () {
        widget.selectedSongNotifier.value = song;
        Navigator.pop(context);
      },
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