import 'package:flutter/material.dart';
import 'package:apple_music_player/screen/recorder/recordscreen.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onHomeTap;

  AppDrawer({required this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 220, 218, 218),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 220, 218, 218),
              ),
              child: Image.asset(
                'assets/newlogo.png',
                width: 500,
                height: 500,
              ),
            ),
            const Divider(color: Colors.transparent),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 23),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset('assets/homelogo.png'),
                    ),
                    title: const Text('HOME'),
                    onTap: () {
                      onHomeTap(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: SizedBox(
                      width: 35,
                      height: 35,
                      child: Image.asset('assets/reclogo.png'),
                    ),
                    title: const Text('VOICE RECORDER'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecorderScreen()),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 27),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset('assets/settingslogo.png'),
                    ),
                    title: const Text('SETTINGS'),
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
