import 'package:apple_music_player/model/MySongModel.dart';
import 'package:apple_music_player/screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MySongModelAdapter());
  await Hive.openBox<MySongModel>('songs');
  await Hive.openBox<MySongModel>('favorites');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player App',
      home: SplashScreen(),
    );
  }
}
