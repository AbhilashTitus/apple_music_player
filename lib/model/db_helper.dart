import 'package:apple_music_player/model/MySongModel.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';

class SongDBHelper {
  Future<void> getPermissionStatus() async {
    PermissionStatus permission = await Permission.audio.request();

    if (permission.isGranted) {
      final box = Hive.box<MySongModel>('songs');
      if (box.isEmpty) {
        await fetchSongs();
      }
    }
  }

  Future<void> fetchSongs() async {
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
        lastPlayed: DateTime.now(),
      ));
    }
  }
   
  void addToFavorites(MySongModel song) {
    Hive.box<MySongModel>('favorites').add(song);
  }
}

class PlaylistDBHelper {
  static Future<List<MySongModel>> loadSongs(String playlistName) async {
    Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
    List<String> songIds =
        playlistsBox.get(playlistName)?.cast<String>() ?? [];
    Box<MySongModel> songsBox = Hive.box<MySongModel>('songs');
    return songIds
        .map((id) => songsBox.get(int.parse(id)))
        .whereType<MySongModel>()
        .toList();
  }

  static void addSongToPlaylist(String playlistName, List<int> songKeys) {
    Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
    List<String> playlist =
        playlistsBox.get(playlistName)?.cast<String>() ?? [];
    playlist.addAll(songKeys.map((key) => key.toString()));
    playlistsBox.put(playlistName, playlist);
  }

  static void renamePlaylist(String oldName, String newName) {
    Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
    List<dynamic> playlist = playlistsBox.get(oldName) ?? [];
    playlistsBox.delete(oldName);
    playlistsBox.put(newName, playlist);
  }

  static void deletePlaylist(String playlistName) {
    Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
    playlistsBox.delete(playlistName);
  }

  static void removeSongFromPlaylist(String playlistName, String songKey) {
    Box<List<dynamic>> playlistsBox = Hive.box<List<dynamic>>('playlists');
    List<String> playlist =
        playlistsBox.get(playlistName)?.cast<String>() ?? [];
    playlist.remove(songKey);
    playlistsBox.put(playlistName, playlist);
  }
}