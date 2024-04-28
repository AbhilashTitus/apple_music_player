import 'package:apple_music_player/controls/bottom_navigation_bar.dart';
import 'package:apple_music_player/screen/allsongs.dart';
import 'package:apple_music_player/screen/home.dart';
import 'package:apple_music_player/screen/nowplaying.dart';
import 'package:apple_music_player/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'MySongModel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  MySongModel? _selectedSong;
  List<MySongModel> _songs = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden) {
      fetchSongs();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() async {
    try {
      final songs = await OnAudioQuery().querySongs();
      _songs = songs.map((song) {
        // print(song);
        return MySongModel(
          title: song.title,
          artist: song.artist ?? '',
          data: song.data,
        );
      }).toList();
    } catch (e) {
      print("Error $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSongSelected(MySongModel song) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedSong = song;
      _selectedIndex = 0;
    });
  }

  

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _selectedSong != null
              ? NowPlaying(
                  song: _selectedSong!,
                )
              : Container(), 
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
