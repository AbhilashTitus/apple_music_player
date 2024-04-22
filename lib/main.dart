import 'package:apple_music_player/controls/bottom_navigation_bar.dart';
import 'package:apple_music_player/screen/allsongs.dart';
import 'package:apple_music_player/screen/home.dart';
import 'package:apple_music_player/screen/nowplaying.dart';
import 'package:apple_music_player/screen/search.dart';
import 'package:apple_music_player/screen/splash.dart';
// import 'package:apple_music_player/song_model.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'SongModel.dart' as my;
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
      debugShowCheckedModeBanner: false,
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
  String _filePath = '';
  List<my.SongModel> _songs = [];

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() async {
    final songs = await OnAudioQuery().querySongs();
    _songs = songs
        .map((song) => my.SongModel(
              title: song.title,
              artist: song.artist ?? '',
              data: song.data,
            ))
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSongSelected(String filePath) {
    FocusScope.of(context).unfocus();
    setState(() {
      _filePath = filePath;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          NowPlaying(
            filePath: _filePath,
          ),
          const HomePage(),
          AllSongsPage(onSongSelected: _onSongSelected),
          SearchScreen(songs: _songs, onSongSelected: _onSongSelected),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
// ignore_for_file: library_private_types_in_public_api