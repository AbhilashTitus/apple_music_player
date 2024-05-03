import 'package:apple_music_player/controls/drawer.dart';
import 'package:apple_music_player/model/MySongModel.dart';
import 'package:apple_music_player/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:apple_music_player/screen/favorites_page.dart';
import 'package:apple_music_player/screen/playlist_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const HomePage({Key? key, required this.selectedSongNotifier})
      : super(key: key);

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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (_selectedIndex == 1) {
      return AppBar(
        title: const Text(
          libraryHeading,
          textAlign: TextAlign.center,
          style: headingStyle,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      );
    } else {
      return const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox.shrink(),
      );
    }
  }

  void _addPlaylist() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('New Playlist'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter playlist name'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Box<List> playlistsBox = Hive.box<List>('playlists');
                playlistsBox.put(controller.text, []);
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
      appBar: _buildAppBar(context),
      drawer: AppDrawer(onHomeTap: _onHomeTap),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<List>('playlists').listenable(),
        builder: (context, Box<List> box, _) {
          return GridView.count(
            crossAxisCount: 2,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesPage(
                          selectedSongNotifier: widget.selectedSongNotifier),
                    ),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    SizedBox(height: 20),
                    Text('FAVORITES'),
                  ],
                ),
              ),
              ...box.keys.map((playlist) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Playlist'),
                          content: const Text(
                              'Are you sure you want to delete this playlist?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                box.delete(playlist);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.playlist_play),
                      const SizedBox(height: 20),
                      Text(playlist),
                    ],
                  ),
                );
              }).toList(),
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
