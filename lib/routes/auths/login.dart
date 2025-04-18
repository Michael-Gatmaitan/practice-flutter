import 'package:flutter/material.dart';
import '../../components/_forms.dart';
import '../../auth/auth_actions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 12,
        children: [
          SizedBox(height: 72),
          buildTextField(
            controller: usernameController,
            label: "Username",
            textColor: Colors.white,
            validatorMessage: "Username is required",
          ),
          buildTextField(
            controller: passwordController,
            isPassword: true,
            label: "Password",
            textColor: Colors.white,
            validatorMessage: "Please enter password.",
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AuthAction.loginUser(
                    context,
                    usernameController.text,
                    passwordController.text,
                  );
                }
              },
              style: btnStyle("pri"),
              child: Text("Login"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/signup");
              },
              style: btnStyle("sec"),
              child: Text("Dont have an account? Signup"),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            textAlign: TextAlign.center,
            "Login",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: "Montserrat",
              color: Colors.white,
            ),
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
                    "Creativity starts here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  LoginForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
