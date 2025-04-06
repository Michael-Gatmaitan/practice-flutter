import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:newflutter/graphql/graphql_service.dart';
import 'package:newflutter/models/graphql_models.dart';

class ItemListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Items"), backgroundColor: Colors.blue[201]),
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

          return Padding(
            padding: EdgeInsets.all(8),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 8.0, // Optional spacing between columns
                mainAxisSpacing: 8.0, // Optional spacing between rows
                childAspectRatio: 1.0, // Adjust as needed
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  // Using Card for better visual separation
                  // color: Colors.red,
                  // shadowColor: Colors.blue,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    // Make card tappable
                    hoverColor: Colors.blueGrey,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/item",
                        arguments: item.productID,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              "http://192.168.100.9/imsa/data/item_images/${item.imageURL}",
                              fit: BoxFit.fill,
                              color: Colors.blueGrey,
                              colorBlendMode: BlendMode.multiply,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.itemName}",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Image.network(
                              //   "http://192.168.100.9/imsa/data/item_images/${item.imageURL}",
                              //   color: Colors.blue,
                              //   height: 100,
                              //   colorBlendMode: BlendMode.multiply,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "${item.stock} pcs.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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

          // item.

          return Center(child: Text("${item.itemName}"));
        },
      ),
    );
  }
}
