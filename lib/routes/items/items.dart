import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:newflutter/graphql/graphql_service.dart';
import 'package:newflutter/models/graphql_models.dart';

class ItemListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Items")),
      body: Query(
        // options: QueryOptions(document: gql(query)),
        options: QueryOptions(document: gql(GraphQLService.getItemsQuery)),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.hasException) {
            return Center(child: Text("Error: ${result.exception.toString()}"));
          }

          List<Item> items = GraphQLHelper.fromGraphQLResult(
            result.data,
            "items",
            Item.fromJson,
          );

          if (items.isEmpty) return Text("Empty list of item");

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/item",
                      // arguments: item["productID"],
                      arguments: item.productID,
                    );
                  },
                  child: Text("Product #${item.productID}"),
                ),
                tileColor: Colors.red,
                // style: ListTileStyle.list,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textColor: Colors.white,
                // style: Tile,
                title: Text(item.itemName),
                subtitle: Text(
                  "Price: ${item.unitPrice} | Stock: ${item.stock}",
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ItemById extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(title: Text("Item $args")),
      body: Query(
        options: QueryOptions(
          document: gql(GraphQLService.getItemByProductIDQuery),
          variables: {"productID": args},
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.hasException) {
            return Center(child: Text("Error: ${result.exception.toString()}"));
          }

          Item item = Item.fromJson(
            result.data?["item"] as Map<String, dynamic>,
          );

          return Center(child: Text("${item.itemName}"));
        },
      ),
    );
  }
}
