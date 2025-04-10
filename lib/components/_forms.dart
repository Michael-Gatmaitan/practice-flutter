import 'package:flutter/material.dart';

ButtonStyle btnStyle(String type) {
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: type == "pri" ? Colors.purple[500] : Colors.black,
    textStyle: TextStyle(
      fontFamily: "Montserrat",
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    // minimumSize: Size(height: 50),
    padding: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side:
          type == "pri"
              ? BorderSide.none
              : BorderSide(width: 2, color: Colors.grey),
    ),
    foregroundColor: Colors.white,
  );

  return elevatedButtonStyle;
}

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  bool isPassword = false,
  String validatorMessage = "This field is required",
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
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
