import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:apple_music_player/model/MySongModel.dart';
import 'package:apple_music_player/screen/recorder/AllRecordingsScreen.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({Key? key}) : super(key: key);

  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Record _recorder = Record();
  bool _isRecording = false;
  String? _filePath;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _recorder.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopAndSaveRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _filePath = '${directory.path}/$fileName';

    await _recorder.start(path: _filePath!);
    setState(() {
      _isRecording = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });
  }

  Future<void> _stopAndSaveRecording() async {
    await _recorder.stop();
    _timer?.cancel();

    final recordingsBox = Hive.box<MySongModel>('recordings');
    recordingsBox.add(MySongModel(
      title: 'RECORDING ${recordingsBox.length + 1}',
      artist: 'Unknown',
      data: '',
      albumArt: null,
      lastPlayed: DateTime.now(),
      filePath: _filePath!,
    ));

    setState(() {
      _isRecording = false;
      _recordingDuration = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'V O I C E  R E C O R D E R',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu),
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text("More Options",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 1,
                child: Text("All recordings"),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllRecordingsScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/reclogo.png'),
            const SizedBox(height: 40),
            Text(
              "${_recordingDuration.inMinutes}:${(_recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 45,
                color: _isRecording ? Colors.red : Colors.black,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 100,
              height: 100,
              child: ElevatedButton(
                onPressed: _toggleRecording,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      _isRecording ? Colors.black : Colors.red),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    const CircleBorder(),
                  ),
                  elevation: MaterialStateProperty.all(5.0),
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.fiber_manual_record,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
