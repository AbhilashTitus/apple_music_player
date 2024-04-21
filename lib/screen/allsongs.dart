// import 'package:apple_music_player/screen/nowplaying.dart'; 
// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, unused_field, unused_local_variable
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AllSongsPage extends StatefulWidget {
  final Function(String) onSongSelected;

  const AllSongsPage({super.key, required this.onSongSelected});

  @override
  _AllSongsPageState createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  late Future<List<SongModel>> _songsFuture = Future.value([]);
  bool permissionGranted = false;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    getPermissionStatus();
  }

  void getPermissionStatus() async {
    PermissionStatus permission = await Permission.audio.request();

    List<SongModel> tempList = await OnAudioQuery().querySongs();
    // print(tempList.length);

    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: OnAudioQuery().querySongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // print(snapshot.data);
          return SafeArea(
            child: Column(
              children: [
                const Text(
                  'A L L  S O N G S',
                  style: TextStyle(fontSize: 17),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      SongModel song = snapshot.data![index];
                      // print(song);
                      return ListTile(
                        title: Text(song.title),
                        subtitle: Text(song.artist ?? ''),
                        onTap: () => widget.onSongSelected(song.data),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
