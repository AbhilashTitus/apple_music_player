import 'package:apple_music_player/model/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

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
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                MySongModel song = favorites[index];
                return ListTile(
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  // Add more details about the song or controls to play the song
                );
              },
            ),
    );
  }
}
