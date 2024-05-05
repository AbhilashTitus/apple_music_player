import 'package:apple_music_player/model/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
class RecentlyPlayedPage extends StatefulWidget {
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const RecentlyPlayedPage({Key? key, required this.selectedSongNotifier}) : super(key: key);

  @override
  _RecentlyPlayedPageState createState() => _RecentlyPlayedPageState();
}

class _RecentlyPlayedPageState extends State<RecentlyPlayedPage> {
  List<MySongModel> recentlyPlayed = [];

  @override
  void initState() {
    super.initState();
    loadRecentlyPlayed();
  }

  Future<void> loadRecentlyPlayed() async {
    try {
      Box<MySongModel> recentlyPlayedBox = await Hive.openBox<MySongModel>('recentlyPlayed');
      recentlyPlayed = recentlyPlayedBox.values.toList();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

    Future<void> clearRecentlyPlayed() async {
    try {
      Box<MySongModel> recentlyPlayedBox = await Hive.openBox<MySongModel>('recentlyPlayed');
      recentlyPlayedBox.clear();
      recentlyPlayed.clear();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        "R E C E N T L Y  P L A Y E D",
        style: TextStyle(fontSize: 17),
      ),
      centerTitle: true,
      actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearRecentlyPlayed,
          ),
        ],
    ),
    body: recentlyPlayed.isEmpty
        ? const Center(
            child: Text(
              "No songs played recently",
              style: TextStyle(fontSize: 18),
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: recentlyPlayed.length,
            itemBuilder: (context, index) {
              MySongModel song = recentlyPlayed[index];
              return GestureDetector(
                onTap: () {
                  widget.selectedSongNotifier.value = song;
                  Navigator.pop(context);
                },
                child: GridTile(
                  footer: Column(
                    children: [
                      Text(
                        song.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  child: song.albumArt != null
                      ? Image.memory(song.albumArt!, fit: BoxFit.cover)
                      : const Icon(Icons.music_note),
                ),
              );
            },
          ),
  );
}
}