import 'package:apple_music_player/controls/bottom_navigation_bar.dart';
import 'package:apple_music_player/screen/allsongs.dart';
import 'package:apple_music_player/screen/home.dart';
import 'package:apple_music_player/screen/nowplaying.dart';
import 'package:apple_music_player/screen/splash.dart';
// import 'package:apple_music_player/song_model.dart';
import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // await Hive.initFlutter();
  // Hive.registerAdapter(SongModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Music Player App',
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          NowPlaying(filePath: '',), 
          HomePage(), 
          AllSongsPage(), 
          // const Search(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}