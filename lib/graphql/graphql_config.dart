import 'package:graphql_flutter/graphql_flutter.dart';
import './graphql_service.dart';

GraphQLClient getGraphQLClient(String? token) {
  // final httpLink = HttpLink("http://192.168.100.9:4000/graphql");

  final authLink = AuthLink(
    getToken: () async => token != null ? 'Bearer $token' : null,
  );

  final link = authLink.concat(GraphQLService.httpLink);

  return GraphQLClient(cache: GraphQLCache(), link: link);
}
