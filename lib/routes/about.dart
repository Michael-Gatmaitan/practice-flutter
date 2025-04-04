import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Center(
        child: Container(width: 200, height: 200, color: Colors.green),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.api), label: "Item 1"),
          BottomNavigationBarItem(icon: Icon(Icons.api), label: "Item 2"),
        ],
      ),
    );
  }
}
