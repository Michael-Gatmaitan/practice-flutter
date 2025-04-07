import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newflutter/auth/auth_provider.dart';
import 'package:newflutter/graphql/graphql_config.dart';
import 'package:newflutter/graphql/graphql_service.dart';
import 'package:provider/provider.dart';

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.purple[500],
  textStyle: TextStyle(
    fontFamily: "Montserrat",
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  // minimumSize: Size(height: 50),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  foregroundColor: Colors.white,
);

Future<void> signupUser(
  BuildContext context,
  String fullname,
  String username,
  String password,
) async {
  final auth = Provider.of<AuthProvider>(context, listen: false);
  final client = getGraphQLClient(null);

  final result = await client.mutate(
    MutationOptions(
      document: gql(GraphQLService.signupMutation),
      variables: {
        "fullname": fullname,
        "username": username,
        "password": password,
      },
    ),
  );

  final data = result.data?["signup"];
  // print(data);
  if (data != null && data['token'] != null) {
    await auth.saveToken(data['token']);
  } else {
    // if(!mounted)
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(data?["error"] ?? "Signup failed")));
  }
}

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
            // TextField(controller: fullnameController),
            // TextField(controller: usernameController),
            // TextField(controller: passwordContriller, obscureText: true),
            TextFormField(
              controller: fullnameController,
              style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Fullname",
                label: Text("Fullname"),
              ),

              validator: (String? val) {
                // Process validation
                if (val == null || val.isEmpty) {
                  return "Fullname required.";
                }

                // Pass
                return null;
              },
            ),
            TextFormField(
              controller: usernameController,
              style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Username",
                label: Text("Username"),
              ),

              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return "Username is required.";
                }
                return null;
              },
            ),
            TextFormField(
              controller: passwordController,
              style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
                label: Text("Password"),
              ),
              validator: (String? val) {
                if (val == null || val.isEmpty) {
                  return "Please enter your password";
                }
                return null;
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Check validation, if false, error message will pop up and
                  // code inside wont run
                  if (_formKey.currentState!.validate()) {
                    // print(fullnameController.text);
                    // print(usernameController.text);
                    // print(passwordController.text);
                    // Process data, validation passed
                    // setState(() {
                    //   submitted = true;
                    // });
                    //
                    signupUser(
                      context,
                      fullnameController.text,
                      usernameController.text,
                      passwordController.text,
                    );
                  }
                },
                style: elevatedButtonStyle,
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
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
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
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
    );
  }
}
