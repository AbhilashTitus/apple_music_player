import 'package:flutter/material.dart';
import 'package:apple_music_player/MySongModel.dart';

class CustomCard extends StatelessWidget {
  final MySongModel? song;

  const CustomCard({Key? key, this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  '${song?.title}-${song?.data ?? ""}',
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
                  child: song?.albumArt != null
                      ? Image.memory(song!.albumArt!, fit: BoxFit.cover)
                      : Image.asset('assets/newlogo.png'),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                song?.title ?? "No song selected",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                song?.artist ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}