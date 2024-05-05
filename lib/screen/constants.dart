import 'package:flutter/material.dart';

const String allSongsHeading = 'A L L  S O N G S';
const String libraryHeading = 'L I B R A R Y';
const String nowPlayingHeading = 'N O W  P L A Y I N G';
const String searchHeading = 'S E A R C H';

const TextStyle headingStyle = TextStyle(fontSize: 17);

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final IconData icon;
  final String text;
  final Color? iconColor;

  const CustomElevatedButton({super.key, 
    required this.onPressed,
    required this.onLongPress,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? Colors.black),
          const SizedBox(height: 20),
          Text(text),
        ],
      ),
    );
  }
}

Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onCancel,
  required VoidCallback onOk,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Theme(
        data: ThemeData(
          dialogBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: onCancel,
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: onOk,
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    },
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final String title;
  final TextStyle style;

  const CustomAppBar({super.key, 
    required this.selectedIndex,
    required this.title,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == 1) {
      return AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: style,
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      );
    } else {
      return const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox.shrink(),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
