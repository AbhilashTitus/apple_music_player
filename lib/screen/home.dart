// ignore_for_file: library_private_types_in_public_api

import 'package:apple_music_player/screen/allsongs.dart';
import 'package:apple_music_player/screen/nowplaying.dart';
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
      _selectedIndex = 0; // Assuming NowPlaying is at index 0
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 220, 218, 218),
            ),
            child: Image.asset(
              'assets/logo.JPG',
              width: 100,
              height: 100,
            ),
          ),
          ListTile(
            title: const Text('HOME'),
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('VOICE RECORDER'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecorderScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('SETTINGS'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          NowPlaying(filePath: _filePath),
          Container(),
          AllSongsPage(onSongSelected: _onSongSelected),
          Container(),
        ],
      ),
    );
  }
}