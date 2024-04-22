import 'package:flutter/material.dart';
import '../SongModel.dart';

class SearchScreen extends StatefulWidget {
  final List<SongModel> songs;
  final Function(String) onSongSelected;

  const SearchScreen(
      {super.key, required this.songs, required this.onSongSelected});

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
          'S E A R C H',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17),
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
            child: query.isEmpty
                ? const Center(
                    child: Text(
                        'PLEASE ENTER A SONG NAME.'))
                : ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return ListTile(
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        onTap: () {
                          widget.onSongSelected(song.data);
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
// ignore_for_file: library_private_types_in_public_api