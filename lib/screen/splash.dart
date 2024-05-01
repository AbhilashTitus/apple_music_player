import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:apple_music_player/screen/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkPermissionsAndNavigate();
  }

  Future<void> checkPermissionsAndNavigate() async {
    PermissionStatus permissionStatus;
    PermissionStatus result;
    final status = await Permission.audio.status;

    permissionStatus = await Permission.audio.request();
    debugPrint(status.toString());
    if (permissionStatus.isGranted) {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      result = await Permission.audio.request();

      if (result.isGranted) {
        await Future.delayed(const Duration(seconds: 3));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen()));
      } else if (result.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/newlogo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Mini Project Week',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: use_build_context_synchronously
