import 'package:apple_music_player/model/MySongModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math' as math;

class AudioControls extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;
  final Duration currentPosition;
  final Duration totalDuration;
  final Function playAudio;
  final Function toggleShuffle;
  final Function toggleRepeat;
  final ValueNotifier<int> currentSongIndexNotifier;
  final ValueNotifier<MySongModel?> selectedSongNotifier;
  final List<MySongModel> songs;

  const AudioControls({
    super.key,
    required this.audioPlayer,
    required this.isPlaying,
    required this.isShuffle,
    required this.isRepeat,
    required this.currentPosition,
    required this.totalDuration,
    required this.playAudio,
    required this.toggleShuffle,
    required this.toggleRepeat,
    required this.currentSongIndexNotifier,
    required this.selectedSongNotifier,
     required this.songs,
  });

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: toggleShuffle as void Function()?,
              icon: Icon(
                Icons.shuffle,
                color: isShuffle
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: toggleRepeat as void Function()?,
              icon: Icon(
                Icons.repeat,
                color:
                    isRepeat ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDuration(currentPosition)),
              Text(formatDuration(totalDuration)),
            ],
          ),
        ),
        Slider(
          value: math.min(currentPosition.inSeconds.toDouble(),
              totalDuration.inSeconds.toDouble()),
          min: 0.0,
          max: totalDuration.inSeconds.toDouble(),
          onChanged: (value) {
            audioPlayer.seek(Duration(seconds: value.toInt()));
          },
          activeColor: Colors.black,
        ),
        const SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 75.0,
              height: 75.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                elevation: 5.0,
                child: IconButton(
                  onPressed: () {
                    if (currentSongIndexNotifier.value > 0) {
                      currentSongIndexNotifier.value--;
                      selectedSongNotifier.value =
                          Hive.box<MySongModel>('songs')
                              .getAt(currentSongIndexNotifier.value);
                      print(
                          'Current song index: ${currentSongIndexNotifier.value}');
                      print('Selected song: ${selectedSongNotifier.value}');
                    }
                  },
                  icon: const Icon(Icons.skip_previous),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: playAudio as void Function()?,
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 60.0,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 75.0,
              height: 75.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                elevation: 5.0,
                child: IconButton(
                  onPressed: () {
                    if (currentSongIndexNotifier.value <
                        Hive.box<MySongModel>('songs').length - 1) {
                      currentSongIndexNotifier.value++;
                      selectedSongNotifier.value =
                          Hive.box<MySongModel>('songs')
                              .getAt(currentSongIndexNotifier.value);
                      print(
                          'Current song index: ${currentSongIndexNotifier.value}');
                      print('Selected song: ${selectedSongNotifier.value}');
                    }
                  },
                  icon: const Icon(Icons.skip_next),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
