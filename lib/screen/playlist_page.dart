import 'package:apple_music_player/model/MySongModel.dart';
import 'package:apple_music_player/model/db_helper.dart';
import 'package:flutter/material.dart';
import 'playlistHelper.dart';

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
    songs = await PlaylistHelper.loadSongs(widget.playlistName);
    setState(() {});
  }

  void _addSong() {
    PlaylistHelper.addSong(context, widget.playlistName, selectedSongKeys, loadSongs);
  }

  void _renamePlaylist() {
    PlaylistHelper.renamePlaylist(context, widget.playlistName);
  }

  void _deletePlaylist() {
    PlaylistHelper.deletePlaylist(context, widget.playlistName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text("Rename Playlist"),
              ),
              const PopupMenuItem(
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