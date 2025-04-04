import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newflutter/graphql/graphql_service.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customers")),
      body: Query(
        options: QueryOptions(document: gql(GraphQLService.getCustomersQuery)),
        builder: (QueryResult result, {fetchmore, refetch}) {
          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text("Error: ${result.exception.toString()}"));
          }
        },
      ),
    );
  }
}
