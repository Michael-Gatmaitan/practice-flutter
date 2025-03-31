import 'package:flutter/material.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.red,
  minimumSize: Size(100, 50),
  padding: EdgeInsets.symmetric(horizontal: 20),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
  textStyle: TextStyle(fontFamily: "PlayfairDisplay"),
);

class CustomButton extends StatefulWidget {
  final String name;
  const CustomButton(this.name, {super.key});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  int pressed = 0;

  @override
  Widget build(BuildContext context) {
    void setPressed() {
      setState(() {
        pressed++;
      });
    }

    return ElevatedButton(
      onPressed: setPressed,
      style: raisedButtonStyle,
      child: Text('${widget.name}: $pressed'),
    );
  }
}
