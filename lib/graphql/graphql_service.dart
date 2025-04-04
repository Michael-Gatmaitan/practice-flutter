import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  // static final HttpLink httpLink = HttpLink("http://localhost:4000/graphql");
  static final HttpLink httpLink = HttpLink(
    // "http://192.168.100.9:4000/graphql",
    "http://192.168.68.66:4000/graphql",
  );
  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(link: httpLink, cache: GraphQLCache()),
  );

  static const String getItemsQuery = """
    query {
      items {
        productID
        itemNumber
        itemName
        discount
        stock
        unitPrice
        imageURL
      }
    }
  """;

  static const String getItemByProductIDQuery = """
    query GetItem(\$productID: Int!) {
      item(productID: \$productID) {
        productID
        itemNumber
        itemName
        discount
        stock
        unitPrice
        imageURL
      }
    }
  """;

  static const String getPurchasesQuery = """
    query {
      purchases {
          purchaseID
          itemNumber
          purchaseDate
          itemName
          unitPrice
          quantity
          vendorName
          vendorID
        }
    }
  """;

  static const String getPurchaseByPurchaseIDQuery = """
    query GetPurchase(\$purchaseID: Int!) {
      purchase(purchaseID: \$purchaseID) {
        purchaseID
        itemNumber
        purchaseDate
        itemName
        unitPrice
        quantity
        vendorName
        vendorID
      }
    }
  """;

  static const String getCustomersQuery = """
    query {
      customers {
          customerID
          fullName
          email
          mobile
          phone2
          address
          address2
          city
          district
          status
          createdOn
        }
    }
  """;

  static const String getCustomerByCustomerIDQuery = """
    query GetCustomer(\$purchaseID: Int!) {
      customer(customerID: \$customerID) {
        customerID
        fullName
        email
        mobile
        phone2
        address
        address2
        city
        district
        status
        createdOn
      }
    }
  """;

  // type Customer {
  //   customerID: Int!
  //   fullName: String!
  //   email: String!
  //   mobile: Int!
  //   phone2: Int!
  //   address: String!
  //   address2: String!
  //   city: String!
  //   district: String!
  //   status: String!
  //   createdOn: String!
  // }

  // static Future<QueryResult> fetchItems() async {
  //   String query = """
  //     query {
  //       items {
  //         productID
  //         itemNumber
  //         itemName
  //         discount
  //         stock
  //         unitPrice
  //         imageURL
  //       }
  //     }
  //   """;
  //
  //   final QueryOptions options = QueryOptions(document: gql(query));
  //   return await client.value.query(options);
  // }
}
