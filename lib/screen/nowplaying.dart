import 'package:apple_music_player/model/MySongModel.dart';
import 'package:apple_music_player/screen/constants.dart';
import 'package:apple_music_player/controls/audio_controls.dart';
import 'package:apple_music_player/screen/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatefulWidget {
  final MySongModel? song;

  const NowPlaying({super.key, this.song});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isShuffle = false;
  bool isRepeat = false;

  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _initAudio();
  }

  @override
  void didUpdateWidget(covariant NowPlaying oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.song?.data != widget.song?.data && widget.song != null) {
      _initAudio();
    }
  }

  Future<void> _initAudio() async {
    if (widget.song == null) {
      return;
    }

    String audioFile = widget.song!.data;
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
      // print("An error occurred");
    }
  }

  void playAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void toggleShuffle() {
    setState(() {
      isShuffle = !isShuffle;
    });
    audioPlayer.setShuffleModeEnabled(isShuffle);
  }

  void toggleRepeat() {
    setState(() {
      isRepeat = !isRepeat;
    });
    audioPlayer.setLoopMode(isRepeat ? LoopMode.one : LoopMode.off);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          nowPlayingHeading,
          textAlign: TextAlign.center,
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCard(song: widget.song),
            AudioControls(
              audioPlayer: audioPlayer,
              isPlaying: isPlaying,
              isShuffle: isShuffle,
              isRepeat: isRepeat,
              currentPosition: currentPosition,
              totalDuration: totalDuration,
              playAudio: playAudio,
              toggleShuffle: toggleShuffle,
              toggleRepeat: toggleRepeat,
            ),
          ],
        ),
      ),
    );
  }
}
