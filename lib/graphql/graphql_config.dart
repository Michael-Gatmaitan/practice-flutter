import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient getGraphQLClient(String? token) {
  final httpLink = HttpLink("http://192.168.100.9:4000/graphql");

  final authLink = AuthLink(
    getToken: () async => token != null ? 'Bearer $token' : null,
  );

  final link = authLink.concat(httpLink);

  return GraphQLClient(cache: GraphQLCache(), link: link);
}
