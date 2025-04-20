import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:newflutter/components/_forms.dart';
import 'package:newflutter/components/counter_state.dart';
import 'package:newflutter/graphql/graphql_config.dart';
import '../../../graphql/graphql_service.dart';

class ItemOutScreen extends StatefulWidget {
  const ItemOutScreen({super.key});

  @override
  State<ItemOutScreen> createState() => _ItemOutScreenState();
}

class _ItemOutScreenState extends State<ItemOutScreen> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> selectedItems = [];
  // List<Map<String, dynamic>> users = [
  //   // {"customerID": 1, "fullname": "michael"},
  // ];
  Future<List<Map<String, dynamic>>>?
  _usersFuture; // Use a Future to hold the eventual result
  List<Map<String, dynamic>> users = [];

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

  Future<void> _loadUsers() async {
    final fetchedUsers = await getUsers();

    setState(() {
      users = fetchedUsers;
    });
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final client = getGraphQLClient(null);
    final result = await client.query(
      QueryOptions(document: gql(GraphQLService.getCustomersQuery)),
    );

    final userResults = result.data?['customers'];
    print("USER RESULTS: $userResults");
    // return userResults;
    return userResults?.cast<Map<String, dynamic>>() ?? [];
  }

  //   Future<List<Map<String, dynamic>>> getUsers() async {
  //     final client = getGraphQLClient(null);
  //     final result = await client.query(
  //       QueryOptions(document: gql(GraphQLService.getCustomersQuery)),
  //     );
  //
  //     final userResults = result.data?["customers"];
  //
  //     // print("USER RESULTS: $userResults");
  //     // setState(() {
  //     //   users = result.data?['customers'];
  //     // });
  //
  // if (userResults != null && userResults is List) {
  //     return userResults.cast<Map<String, dynamic>>();
  //   } else {
  //     print("Error: 'customers' field not found or is not a list in GraphQL response.");
  //     return [];
  //   }
  //   }

  @override
  void initState() {
    super.initState();
    // getUsersFunc();
  }
  // UPDATE item SET stock = stock - q WHERE productID = q

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          "Item-OUT",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Montserrat",
          ),
        ),
        // actions: [
        //   DropdownMenu(
        //     dropdownMenuEntries: [DropdownMenuEntry(value: 1, label: "Label")],
        //   ),
        // ],
      ),
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

          if (!fetchedItems.isEmpty) {
            items =
                fetchedItems.map((item) {
                  return {
                    'productID': item['productID'],
                    'itemName': item['itemName'],
                    'stock': item['stock'],
                    'imageURL': item['imageURL'],
                    'unitPrice': item['unitPrice'],
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
                  title: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          "${GraphQLService.baseUrl}/imsa/data/item_images/${item["imageURL"]}",
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['itemName']),
                          Text(
                            '${item["unitPrice"]}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final finalSelectedItems = selectedItems.where(
            (item) => (item['selectedQuantity'] as int) > 0,
          );

          print("Final selected items are: $finalSelectedItems");

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Selected Items'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.min,
                  children:
                      finalSelectedItems.isEmpty
                          ? [Text('No items selected.')]
                          : finalSelectedItems.map((selectedItem) {
                            return Text(
                              "${selectedItem['itemName']} : ${selectedItem['selectedQuantity']}",
                            );
                          }).toList(),
                ),
                actions: [
                  // DropdownButton(
                  //   items:
                  //       users.map((user) {
                  //         return DropdownMenuItem(
                  //           value: user["customerID"],
                  //           child: Text(user["fullname"]),
                  //         );
                  //       }).toList(),
                  //   onChanged: (val) {
                  //     print(val);
                  //   },
                  // ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: getUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Or some loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        users = snapshot.data!;
                        return DropdownButton(
                          items:
                              users.map((user) {
                                return DropdownMenuItem(
                                  value: user["customerID"],
                                  child: Text(user["fullName"]),
                                );
                              }).toList(),
                          onChanged: (val) {
                            print(val);
                          },
                        );
                      } else {
                        return Text('No data');
                      }
                    },
                  ),
                  // DropdownButton(
                  //   // items: [DropdownMenuItem(value: 0, child: Text("ASD"))],
                  //   items:
                  //       users.map((user) {
                  //         // return user["customerID"];
                  //         print(user);
                  //         return DropdownMenuItem(
                  //           value: user["customerID"],
                  //           child: Text(user["fullname"]),
                  //         );
                  //       }).toList(),
                  //   // value: 0,
                  //   onChanged: (val) {
                  //     print(val);
                  //   },
                  // ),
                  TextButton(
                    // style: btnStyle("pri"),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/generateqr",
                        arguments: {
                          // data: finalSelectedItems,
                          "data": finalSelectedItems.toList(),
                          "type": "out",
                        },
                      );
                    },
                    child: Text("Proceed"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

// class UsersDropDown extends StatelessWidget {
//   List<Map<String, dynamic>> users = [];
//   UsersDropDown({super.key, required this.users});
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu();
//   }
// }
