import 'package:apple_music_player/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/MySongModel.dart';

class SearchScreen extends StatefulWidget {
  final List<MySongModel> songs;
  final ValueNotifier<MySongModel?> selectedSongNotifier;

  const SearchScreen(
      {Key? key, required this.songs, required this.selectedSongNotifier})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredSongs = widget.songs
        .where((song) => song.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          searchHeading,
          textAlign: TextAlign.center,
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredSongs.isEmpty
                ? const Center(child: Text('No songs found.'))
                : ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: song.albumArt != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(song.albumArt!),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.music_note),
                        ),
                        title: Text(
                          song.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.artist,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton<int>(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Add to Favorites"),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 1) {
                              Hive.box<MySongModel>('favorites')
                                  .add(MySongModel(
                                title: song.title,
                                artist: song.artist,
                                data: song.data,
                                albumArt: song.albumArt,
                              ));
                            }
                          },
                        ),
                        onTap: () {
                          widget.selectedSongNotifier.value = song;
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
