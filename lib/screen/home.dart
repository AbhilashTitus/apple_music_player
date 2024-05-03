import 'package:apple_music_player/controls/drawer.dart';
import 'package:apple_music_player/model/MySongModel.dart';
import 'package:apple_music_player/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:apple_music_player/screen/favorites_page.dart';
import 'package:apple_music_player/screen/playlist_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const HomePage({super.key, required this.selectedSongNotifier});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    Hive.openBox<List>('playlists');
  }

  void _onHomeTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addPlaylist() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return Theme(
          data: ThemeData(
              dialogBackgroundColor: Colors.white,
              dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
          child: AlertDialog(
            title: const Text('New Playlist'),
            content: TextField(
              controller: controller,
              decoration:
                  const InputDecoration(hintText: 'Enter playlist name'),
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
                  Box<List> playlistsBox = Hive.box<List>('playlists');
                  playlistsBox.put(controller.text, []);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        selectedIndex: _selectedIndex,
        title: libraryHeading,
        style: headingStyle,
      ),
      drawer: AppDrawer(onHomeTap: _onHomeTap),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<List>('playlists').listenable(),
        builder: (context, Box<List> box, _) {
          return GridView.count(
            crossAxisCount: 2,
            children: [
              CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesPage(
                          selectedSongNotifier: widget.selectedSongNotifier),
                    ),
                  );
                },
                onLongPress: () {},
                icon: Icons.favorite,
                iconColor: Colors.red,
                text: 'FAVORITES',
              ),
              ...box.keys.map((playlist) {
                return CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistPage(
                          playlistName: playlist,
                          selectedSongNotifier: widget.selectedSongNotifier,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showCustomDialog(
                      context: context,
                      title: 'Delete Playlist',
                      content: 'Are you sure you want to delete this playlist?',
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      onOk: () {
                        box.delete(playlist);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  icon: Icons.playlist_play,
                  text: playlist,
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: _addPlaylist,
        child: const Icon(Icons.add),
      ),
    );
  }
}
