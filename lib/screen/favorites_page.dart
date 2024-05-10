import 'package:apple_music_player/model/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritesPage extends StatefulWidget {
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const FavoritesPage({super.key, required this.selectedSongNotifier});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<MySongModel> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      Box<MySongModel> favoritesBox =
          await Hive.openBox<MySongModel>('favorites');
      favorites = favoritesBox.values.toList();
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
          "F A V O R I T E S",
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No songs added",
                style: TextStyle(fontSize: 15),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                MySongModel song = favorites[index];
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
                        child: Text("Remove from Favorites"),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        Hive.box<MySongModel>('favorites').deleteAt(index);
                        setState(() {
                          favorites.removeAt(index);
                        });
                        print('Removed song from favorites');
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
    );
  }
}
