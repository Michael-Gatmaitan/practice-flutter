import 'package:flutter/material.dart';

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue[500],
  textStyle: TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  foregroundColor: Colors.white,
);

class CounterState extends StatefulWidget {
  const CounterState({super.key});

  @override
  State<CounterState> createState() => _CounterState();
}

class _CounterState extends State<CounterState> {
  int count = 0;

  void add() {
    setState(() {
      count++;
    });
  }

  void sub() {
    setState(() {
      count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$count"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: add,
              style: elevatedButtonStyle,
              child: Text("Add"),
            ),
            ElevatedButton(
              onPressed: sub,
              style: elevatedButtonStyle,
              child: Text("Sub"),
            ),
          ],
        ),
      ],
    );
  }
}
