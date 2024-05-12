import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:apple_music_player/model/MySongModel.dart';

class NowPlayingRecording extends StatefulWidget {
  final MySongModel recording;

  NowPlayingRecording({required this.recording});

  @override
  _NowPlayingRecordingState createState() => _NowPlayingRecordingState();
}

class _NowPlayingRecordingState extends State<NowPlayingRecording> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadRecording();
  }

  Future<void> _loadRecording() async {
    if (widget.recording.filePath != null) {
      await _audioPlayer.setFilePath(widget.recording.filePath!);
    } else {}
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recording.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mic,
              size: 300.0,
            ),
            const SizedBox(
              height: 50.0,
            ),
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioPlayer.duration ?? Duration.zero;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}'),
                          Text(
                              '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'),
                        ],
                      ),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.black.withOpacity(0.5),
                        thumbColor: Colors.black,
                      ),
                      child: Slider(
                        value: position.inMilliseconds
                            .toDouble()
                            .clamp(0.0, duration.inMilliseconds.toDouble()),
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          _audioPlayer
                              .seek(Duration(milliseconds: value.round()));
                        },
                      ),
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 70),
            ElevatedButton(
              onPressed: () {
                if (_isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.play();
                }
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                minimumSize: const Size(100, 100),
              ),
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black, size: 50),
            ),
          ],
        ),
      ),
    );
  }
}
