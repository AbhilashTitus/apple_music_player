import 'package:apple_music_player/model/db_helper.dart';
import 'package:apple_music_player/screen/constants.dart';
import 'package:apple_music_player/model/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AllSongsPage extends StatefulWidget {
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const AllSongsPage({Key? key, required this.selectedSongNotifier})
      : super(key: key);

  @override
  _AllSongsPageState createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  SongDBHelper dbHelper = SongDBHelper();

  @override
  void initState() {
    super.initState();
    dbHelper.getPermissionStatus();
    openRecentlyPlayedBox();
  }

  Future openRecentlyPlayedBox() async {
    await Hive.openBox<MySongModel>('recentlyPlayed');
  }

  @override
  void dispose() {
    Hive.box('recentlyPlayed').close();
    super.dispose();
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
      body: ValueListenableBuilder(
        valueListenable: Hive.box<MySongModel>('songs').listenable(),
        builder: (context, Box<MySongModel> box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              MySongModel song = box.getAt(index)!;
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
                  Box<MySongModel> recentlyPlayedBox =
                      Hive.box<MySongModel>('recentlyPlayed');
                  recentlyPlayedBox.put(
                      song.data,
                      MySongModel(
                        title: song.title,
                        artist: song.artist,
                        data: song.data,
                        albumArt: song.albumArt,
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
