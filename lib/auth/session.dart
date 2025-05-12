import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newflutter/graphql/graphql_service.dart';

final storage = FlutterSecureStorage();

Future<Map<String, dynamic>?> getUserInfo() async {
  final token = await storage.read(key: "token");

  if (token == null) {
    return null;
  }

  final client = GraphQLClient(
    link: AuthLink(
      getToken: () async => "Bearer $token",
    ).concat(GraphQLService.httpLink),
    cache: GraphQLCache(),
  );

  try {
    final result = await client.query(
      QueryOptions(document: gql(GraphQLService.meQuery)),
    );

    if (result.hasException) {
      print("Error getting user info ${result.exception.toString()}");
      return null;
    }

    return result.data?["me"];
  } catch (err) {
    print("Something went wrong $err");
    return null;
  }
}
