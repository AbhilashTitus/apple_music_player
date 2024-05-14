
// ignore_for_file: file_names

import 'package:apple_music_player/model/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:apple_music_player/model/MySongModel.dart';
import 'package:hive/hive.dart';

class PlaylistHelper {
  static Future<List<MySongModel>> loadSongs(String playlistName) async {
    try {
      return await PlaylistDBHelper.loadSongs(playlistName);
    } catch (e) {
      return [];
    }
  }

  static void addSong(BuildContext context, String playlistName,
      List<int> selectedSongKeys, Function loadSongs) {
    showDialog(
      context: context,
      builder: (context) {
        Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
        List<String> playlist =
            playlistsBox.get(playlistName)?.cast<String>() ?? [];
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
                title: const Text('Add Songs'),
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
                          activeColor: Colors.black,
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
                      PlaylistDBHelper.addSongToPlaylist(
                          playlistName, selectedSongKeys);
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

  static void renamePlaylist(BuildContext context, String playlistName) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Rename Playlist'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Enter new playlist name'),
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
                PlaylistDBHelper.renamePlaylist(playlistName, controller.text);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void deletePlaylist(BuildContext context, String playlistName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('Delete Playlist'),
          content: const Text('Are you sure you want to delete this playlist?'),
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
                PlaylistDBHelper.deletePlaylist(playlistName);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
