import 'package:flutter/material.dart';

ButtonStyle btnStyle(String type) {
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: type == "pri" ? Colors.purple[500] : Colors.black,
    textStyle: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    padding: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide.none,
    ),
    foregroundColor: Colors.white,
  );

  return elevatedButtonStyle;
}

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  bool isNumber = false,
  bool isPassword = false,
  Color textColor = Colors.black,
  String validatorMessage = "This field is required.",
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    style: TextStyle(color: textColor, fontFamily: "Montserrat"),
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      hintText: label,
      label: Text(label),
    ),
    validator: (val) {
      if (val == null || val.isEmpty) return validatorMessage;
      return null;
    },
  );
}
