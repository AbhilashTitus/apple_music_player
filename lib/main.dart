import 'package:apple_music_player/screen/splash.dart';
import 'package:flutter/material.dart';

void main() async {
  // await Hive.initFlutter();
  // Hive.registerAdapter(MySongModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player App',
      home: SplashScreen(),
    );
  }
}