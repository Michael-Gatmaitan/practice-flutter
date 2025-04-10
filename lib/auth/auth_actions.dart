import 'package:flutter/material.dart';
import 'package:newflutter/auth/auth_provider.dart';
import 'package:newflutter/graphql/graphql_config.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newflutter/graphql/graphql_service.dart';

class AuthAction {
  static Future<void> loginUser(
    BuildContext context,
    String username,
    String password,
  ) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final client = getGraphQLClient(null);

    final result = await client.mutate(
      MutationOptions(
        document: gql(GraphQLService.loginMutation),
        variables: {"username": username, "password": password},
      ),
    );

    final data = result.data?["login"];

    if (data != null && data["token"] != null) {
      await auth.saveToken(data["token"]);

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logged in successfully")));
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data?["error"] ?? "Username of $username does not exist.",
          ),
        ),
      );
    }
  }

  static Future<void> signupUser(
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data?["error"] ?? "Signup failed")),
      );
    }
  }
}
