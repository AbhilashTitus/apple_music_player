import 'package:apple_music_player/controls/NowPlayingDummy.dart';
import 'package:apple_music_player/controls/bottom_navigation_bar.dart';
import 'package:apple_music_player/screen/allsongs.dart';
import 'package:apple_music_player/screen/home.dart';
import 'package:apple_music_player/screen/nowplaying.dart';
import 'package:apple_music_player/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../model/MySongModel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  MySongModel? _selectedSong;
  List<MySongModel> _songs = [];
  ValueNotifier<MySongModel?> selectedSongNotifier =
      ValueNotifier<MySongModel?>(null);
  ValueNotifier<int> currentSongIndexNotifier = ValueNotifier<int>(0);

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
    selectedSongNotifier.addListener(() {
      if (selectedSongNotifier.value != null) {
        setState(() {
          _selectedSong = selectedSongNotifier.value;
          _selectedIndex = 0;
        });
      }
    });
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
          lastPlayed: DateTime.now(),
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

  @override
  void dispose() {
    selectedSongNotifier.dispose();
    super.dispose();
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
                  selectedSongNotifier: selectedSongNotifier,
                  currentSongIndexNotifier: currentSongIndexNotifier,
                )
              : const NowPlayingDummy(),
          HomePage(selectedSongNotifier: selectedSongNotifier),
          AllSongsPage(
            selectedSongNotifier: selectedSongNotifier,
            currentSongIndexNotifier: currentSongIndexNotifier,
          ),
          SearchScreen(
              songs: _songs, selectedSongNotifier: selectedSongNotifier),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
