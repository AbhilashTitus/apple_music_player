import 'package:apple_music_player/constants.dart';
import 'package:flutter/material.dart';
import '../MySongModel.dart';

class SearchScreen extends StatefulWidget {
  final List<MySongModel> songs;
  final Function(MySongModel) onSongSelected;

  const SearchScreen(
      {Key? key, required this.songs, required this.onSongSelected}) : super(key: key);

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
                        leading: song.albumArt != null
                            ? Image.memory(
                                song.albumArt!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : IconButton(
                                icon: const Icon(Icons.music_note),
                                onPressed: () {
                                  // Add your functionality here
                                },
                              ),
                        title: Text(
                          song.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.artist,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            // Add your functionality here
                          },
                        ),
                        onTap: () {
                          widget.onSongSelected(song);
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