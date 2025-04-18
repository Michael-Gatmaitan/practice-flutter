import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../graphql/graphql_service.dart';

class ItemOutScreen extends StatefulWidget {
  const ItemOutScreen({super.key});

  @override
  State<ItemOutScreen> createState() => _ItemOutScreenState();
}

class _ItemOutScreenState extends State<ItemOutScreen> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> selectedItems = [];

  void _updateSelectedItem(Map<String, dynamic> item, bool isChecked) {
    setState(() {
      final index = items.indexWhere(
        (i) => i['productID'] == item['productID'],
      );
      if (index != -1) {
        items[index]['isChecked'] = isChecked;
        if (isChecked) {
          if (!selectedItems.any(
            (selected) => selected['productID'] == item['productID'],
          )) {
            selectedItems.add({
              ...item,
              'selectedQuantity': 0,
              'isChecked': true,
            }); // Add with initial quantity
          }
        } else {
          selectedItems.removeWhere(
            (selected) => selected['productID'] == item['productID'],
          );
          items[index]['selectedQuantity'] = 0;
        }
      }
    });
  }

  void _updateQuantity(Map<String, dynamic> item, int quantity) {
    setState(() {
      final itemIndex = items.indexWhere(
        (i) => i['productID'] == item['productID'],
      );
      if (itemIndex != -1) {
        items[itemIndex]['selectedQuantity'] = quantity.clamp(
          0,
          items[itemIndex]['stock'] as int? ?? 0,
        );

        final selectedIndex = selectedItems.indexWhere(
          (s) => s['productID'] == item['productID'],
        );
        if (selectedIndex != -1) {
          selectedItems[selectedIndex]['selectedQuantity'] =
              items[itemIndex]['selectedQuantity'];
        }
      }
    });
  }

  // UPDATE item SET stock = stock - q WHERE productID = q

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
        options: QueryOptions(document: gql(GraphQLService.getItemsQuery)),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Center(
              child: Text(
                "Error fetching data: ${result.exception.toString()}",
              ),
            );
          }

          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final fetchedItems = result.data?['items'] as List<dynamic>;

          if (fetchedItems != null) {
            items =
                fetchedItems.map((item) {
                  return {
                    'productID': item['productID'],
                    'itemName': item['itemName'],
                    'stock': item['stock'],
                    'imageURL': item['imageURL'],
                    'isChecked':
                        items.firstWhere(
                          (existing) =>
                              existing['productID'] == item['productID'],
                          orElse: () => {'isChecked': false},
                        )['isChecked'] ??
                        false,
                    'selectedQuantity':
                        items.firstWhere(
                          (existing) =>
                              existing['productID'] == item['productID'],
                          orElse: () => {'selectedQuantity': 0},
                        )['selectedQuantity'] ??
                        0,
                  };
                }).toList();

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  leading: Checkbox(
                    value: item['isChecked'],
                    onChanged: (bool? value) {
                      _updateSelectedItem(item, value!);
                    },
                  ),
                  title: Text(item['itemName']),
                  // subtitle: Text(''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed:
                            item['isChecked'] &&
                                    (item['selectedQuantity'] as int? ?? 0) > 0
                                ? () => _updateQuantity(
                                  item,
                                  (item['selectedQuantity'] as int) - 1,
                                )
                                : null,
                      ),
                      SizedBox(width: 8),
                      Text("${item['selectedQuantity']}"),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed:
                            item['isChecked'] &&
                                    (item['selectedQuantity'] as int? ?? 0) <
                                        (item['stock'] as int? ?? 0)
                                ? () => _updateQuantity(
                                  item,
                                  (item['selectedQuantity'] as int) + 1,
                                )
                                : null,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // return
          return Center(child: Text('No items found.'));
        },
      ),
    );
  }
}
