import 'package:apple_music_player/model/MySongModel.dart';
import 'package:apple_music_player/screen/recorder/nowplayingrecording.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AllRecordingsScreen extends StatefulWidget {
  @override
  _AllRecordingsScreenState createState() => _AllRecordingsScreenState();
}

class _AllRecordingsScreenState extends State<AllRecordingsScreen> {
  Box<MySongModel>? recordingsBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    recordingsBox = await Hive.openBox<MySongModel>('recordings');
    setState(() {});
  }

  Widget _buildPopupMenu(int index) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'Delete') {
          setState(() {
            recordingsBox!.deleteAt(index);
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return {'Delete'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'A L L  R E C O R D I N G S',
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: recordingsBox == null
          ? const Center(child: CircularProgressIndicator())
          : recordingsBox!.isEmpty
              ? const Center(child: Text("No Recordings Found"))
              : ListView.builder(
                  itemCount: recordingsBox!.length,
                  itemBuilder: (context, index) {
                    final recording = recordingsBox!.getAt(index);

                    return ListTile(
                      leading: const Icon(Icons.mic),
                      title: Text(recording!.title),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NowPlayingRecording(
                              recording: recording,
                            ),
                          ),
                        );
                      },
                      trailing: _buildPopupMenu(index),
                    );
                  },
                ),
    );
  }
}