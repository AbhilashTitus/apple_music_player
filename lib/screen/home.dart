import 'package:apple_music_player/controls/drawer.dart';
import 'package:apple_music_player/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:apple_music_player/screen/favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  String _filePath = '';

  void _onHomeTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSongSelected(String filePath) {
    setState(() {
      _filePath = filePath;
      _selectedIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: AppDrawer(onHomeTap: _onHomeTap),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            onPressed: () {},
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.playlist_play),
                SizedBox(height: 20),
                Text('DRIVING PLAYLIST'),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            onPressed: () {},
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.playlist_play),
                SizedBox(height: 20),
                Text('SLEEPING PLAYLIST'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
// ignore_for_file: library_private_types_in_public_api, unused_field, unused_element