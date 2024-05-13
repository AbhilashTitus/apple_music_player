import 'package:apple_music_player/model/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecentlyPlayedController {
  final ValueNotifier<bool> recentlyPlayedChangedNotifier =
      ValueNotifier(false);

  Future<List<MySongModel>> loadRecentlyPlayed() async {
    Box<MySongModel> recentlyPlayedBox =
        await Hive.openBox<MySongModel>('recentlyPlayed');
    List<MySongModel> recentlyPlayed = recentlyPlayedBox.values.toList();
    recentlyPlayed.sort((a, b) {
      DateTime aLastPlayed = a.lastPlayed ?? DateTime.now();
      DateTime bLastPlayed = b.lastPlayed ?? DateTime.now();
      return bLastPlayed.compareTo(aLastPlayed);
    });
    return recentlyPlayed;
  }
  

  Future<void> clearRecentlyPlayed() async {
    Box<MySongModel> recentlyPlayedBox =
        await Hive.openBox<MySongModel>('recentlyPlayed');
    await recentlyPlayedBox.clear();
    recentlyPlayedChangedNotifier.value = !recentlyPlayedChangedNotifier.value;
  }
}


class RecentlyPlayedPage extends StatelessWidget {
  final ValueNotifier<MySongModel?> selectedSongNotifier;
  final RecentlyPlayedController controller = RecentlyPlayedController();

  RecentlyPlayedPage({super.key, required this.selectedSongNotifier});

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
            onPressed: () async {
              await controller.clearRecentlyPlayed();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.recentlyPlayedChangedNotifier,
        builder: (context, value, child) {
          return FutureBuilder<List<MySongModel>>(
            future: controller.loadRecentlyPlayed(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              final recentlyPlayed = snapshot.data!.take(8).toList();

              if (recentlyPlayed.isEmpty) {
                return const Center(
                  child: Text(
                    "No songs played recently",
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: recentlyPlayed.length,
                itemBuilder: (context, index) {
                  MySongModel song = recentlyPlayed[index];
                  return GestureDetector(
                    onTap: () {
                      selectedSongNotifier.value = song;
                      Navigator.pop(context);
                    },
                    child: Card(
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 15,
                      child: GridTile(
                        footer: Column(
                          children: [
                            Text(
                              song.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              song.artist,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        child: song.albumArt != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(song.albumArt!,
                                    fit: BoxFit.cover),
                              )
                            : const Icon(Icons.music_note),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
