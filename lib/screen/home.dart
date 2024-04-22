import 'package:apple_music_player/screen/recorder/recordscreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  String _filePath = '';

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
          'L I B R A R Y',
          textAlign: TextAlign.center,
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

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 220, 218, 218),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 220, 218, 218),
              ),
              child: Image.asset(
                'assets/newlogo.png',
                width: 500,
                height: 500,
              ),
            ),
            const Divider(color: Colors.transparent),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 23),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset('assets/homelogo.png'),
                    ),
                    title: const Text('HOME'),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: SizedBox(
                      width: 35,
                      height: 35,
                      child: Image.asset('assets/reclogo.png'),
                    ),
                    title: const Text('VOICE RECORDER'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecorderScreen()),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 27),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset('assets/settingslogo.png'),
                    ),
                    title: const Text('SETTINGS'),
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
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
            onPressed: () {},
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