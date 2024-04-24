import 'package:apple_music_player/MySongModel.dart';
import 'package:apple_music_player/controls/audio_controls.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatefulWidget {
  final MySongModel? song;

  const NowPlaying({Key? key, this.song}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
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
              color: Colors.grey[200],
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
                        '${widget.song?.title}-${widget.song?.data ?? ""}',
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
                        child: widget.song?.albumArt != null
                            ? Image.memory(widget.song!.albumArt!,
                                fit: BoxFit.cover)
                            : Image.asset('assets/newlogo.png'),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.song?.title ?? "No song selected",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      widget.song?.artist ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    );
  }
}
