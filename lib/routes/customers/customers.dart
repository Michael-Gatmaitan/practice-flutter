import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newflutter/graphql/graphql_service.dart';
import 'package:newflutter/models/graphql_models.dart';

class CustomersScreen extends StatelessWidget {
  // const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customers")),
      body: Query(
        options: QueryOptions(document: gql(GraphQLService.getCustomersQuery)),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(child: Text("Error: ${result.exception.toString()}"));
          }

          List<Customer> customers = GraphQLHelper.fromGraphQLResult(
            result.data,
            "customers",
            Customer.fromJson,
          );

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final Customer customer = customers[index];
              // return Container();
              // return ListTile(
              //
              // );
              return Container(
                color: Colors.red,
                child: Text(customer.fullName),
              );
            },
          );
        },
      ),
    );
  }
}
