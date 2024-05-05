import 'package:apple_music_player/model/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:apple_music_player/model/MySongModel.dart';
import 'package:hive/hive.dart';

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
      songs = await PlaylistDBHelper.loadSongs(widget.playlistName);
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
                title:const Text('Add Songs'),
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
                                child: Image.memory(song.albumArt!,
                                    fit: BoxFit.cover))
                            : const Icon(Icons.music_note),
                        title: Text(
                          song.title,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:
                        const Text('OK', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      PlaylistDBHelper.addSongToPlaylist(widget.playlistName, selectedSongKeys);
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

  void _renamePlaylist() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Rename Playlist'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new playlist name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                PlaylistDBHelper.renamePlaylist(widget.playlistName, controller.text);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePlaylist() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Playlist'),
          content: Text('Are you sure you want to delete this playlist?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                PlaylistDBHelper.deletePlaylist(widget.playlistName);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Rename Playlist"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Delete Playlist"),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                _renamePlaylist();
              } else if (value == 2) {
                _deletePlaylist();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
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
                  PlaylistDBHelper.removeSongFromPlaylist(widget.playlistName, song.key.toString());
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