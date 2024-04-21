// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatefulWidget {
  final String filePath;

  const NowPlaying({super.key, required this.filePath});

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isShuffle = false;
  bool isRepeat = false;

  String songTitle = 'Batman Theme';
  String artist = 'Hans Zimmer';
  String albumArt = 'assets/reclogo.png';

  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  get index => null;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _initAudio();
  }

  @override
  void didUpdateWidget(covariant NowPlaying oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _initAudio();
    }
  }

  Future<void> _initAudio() async {
    String audioFile = widget.filePath;
    try {
      if (isPlaying) {
        await audioPlayer.stop();
      }
      await audioPlayer.setFilePath(audioFile);
      audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.playing != isPlaying) {
          setState(() {
            isPlaying = playerState.playing;
          });
        }
      });

      audioPlayer.positionStream.listen((position) {
        setState(() {
          currentPosition = position;
        });
      });

      audioPlayer.durationStream.listen((duration) {
        setState(() {
          totalDuration = duration ?? Duration.zero;
        });
      });
      await audioPlayer.play();
    } catch (e) {
      // catch load errors: 404, invalid url ...
      // print("An error occurred $e");
    }
  }

  void playAudio() {
    if (audioPlayer.playerState.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void toggleShuffle() {
    setState(() {
      isShuffle = !isShuffle;
      audioPlayer.setShuffleModeEnabled(isShuffle);
    });
  }

  void toggleRepeat() {
    setState(() {
      isRepeat = !isRepeat;
      audioPlayer.setLoopMode(isRepeat ? LoopMode.one : LoopMode.off);
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'N O W  P L A Y I N G',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: Text(
                        '$songTitle-$index',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.asset(albumArt),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      songTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(artist),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: toggleShuffle,
                icon: Icon(
                  Icons.shuffle,
                  color: isShuffle
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : Colors.grey,
                ),
              ),
              IconButton(
                onPressed: toggleRepeat,
                icon: Icon(
                  Icons.repeat,
                  color: isRepeat
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Slider(
            value: currentPosition.inSeconds.toDouble(),
            min: 0.0,
            max: totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            },
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
                    onPressed: () {}, // Add skipPrevious functionality here
                    icon: const Icon(Icons.skip_previous),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: playAudio,
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
                    onPressed: () {}, // Add skipNext functionality here
                    icon: const Icon(Icons.skip_next),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
