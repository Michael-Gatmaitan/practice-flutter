import 'package:flutter/material.dart';
import '../../components/_forms.dart';
import '../../auth/auth_actions.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        // color: Colors.red,
        margin: EdgeInsets.fromLTRB(0, 50, 0, 12),
        child: Column(
          spacing: 12,
          children: [
            buildTextField(
              controller: fullnameController,
              label: "Fullname",
              validatorMessage: "Fullname is required.",
            ),
            buildTextField(
              controller: usernameController,
              label: "Username",
              validatorMessage: "Username is required",
            ),
            buildTextField(
              controller: passwordController,
              isPassword: true,
              label: "Password",
              validatorMessage: "Please enter password.",
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    AuthAction.signupUser(
                      context,
                      fullnameController.text,
                      usernameController.text,
                      passwordController.text,
                    );
                  }
                },
                style: btnStyle("pri"),
                child: Text("Create account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          textAlign: TextAlign.center,
          "Signup",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Montserrat",
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(40, 55, 40, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Create Your New\nAccount",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Do not use common password for more security.",

                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                  SignupForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
