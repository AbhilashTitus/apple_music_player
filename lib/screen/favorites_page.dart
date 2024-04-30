import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "F A V O R I T E S",
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true, // Center the title
      ),
      body: Center(
        child: Text(
          "No songs added",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}