import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  const FormInput({super.key});

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: TextStyle(color: submitted ? Colors.green : Colors.red),
            decoration: const InputDecoration(hintText: "Enter your name"),
            validator: (String? val) {
              // Process validation
              if (val == null || val.isEmpty) {
                return "Please enter your name";
              }

              // Pass
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process data, validation passed
                  setState(() {
                    submitted = true;
                  });
                }
              },
              child: Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
