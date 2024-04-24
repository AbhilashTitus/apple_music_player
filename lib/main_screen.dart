import 'package:apple_music_player/controls/bottom_navigation_bar.dart';
import 'package:apple_music_player/screen/allsongs.dart';
import 'package:apple_music_player/screen/home.dart';
import 'package:apple_music_player/screen/nowplaying.dart';
import 'package:apple_music_player/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'MySongModel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  MySongModel? _selectedSong;
  List<MySongModel> _songs = [];

@override
  void initState() {
    super.initState();
    fetchSongs();
  }

  void fetchSongs() async {
    final songs = await OnAudioQuery().querySongs();
    _songs = songs
        .map((song) => MySongModel(
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
              : Container(), // Show an empty container if no song is selected
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